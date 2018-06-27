package de.hdm.mad.ss18_schwablication;

import android.Manifest;
import android.app.Activity;
import android.app.Fragment;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.database.Cursor;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.drawable.BitmapDrawable;
import android.net.Uri;
import android.os.Bundle;
import android.os.Environment;
import android.os.StrictMode;
import android.provider.MediaStore;
import android.support.v4.app.ActivityCompat;
import android.support.v4.content.ContextCompat;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageView;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import static android.app.Activity.RESULT_OK;


/**
 * A simple {@link Fragment} subclass.
 * Activities that contain this fragment must implement the
 * {@link ExtendedInfoFragment.OnFragmentInteractionListener} interface
 * to handle interaction events.
 * Use the {@link ExtendedInfoFragment#newInstance} factory method to
 * create an instance of this fragment.
 */
public class ExtendedInfoFragment extends Fragment {
    static final int REQUEST_TAKE_PHOTO_AND_SAVE = 1;
    public ImageView pictureView;
    public EditText edit_amount,
            edit_desc, edit_title, edit_date;
    public static final String ARG_PARAM1 = "id";
    private Uri photoUri;
    private String curPhotoPath;
    public String row_id = "";
    private static DbHelper db = MainActivity.db;
    private Button saveButton;

    private OnFragmentInteractionListener mListener;
    /**
     * OnClickListener for taking a picture when pressing the specific button.
     */
    private View.OnClickListener takePictureOnClickListener = new View.OnClickListener() {
        @Override
        public void onClick(View v) {
            StrictMode.VmPolicy.Builder builder = new StrictMode.VmPolicy.Builder();
            StrictMode.setVmPolicy(builder.build());
            if (checkAndRequestPermission(getActivity())) {
                generatePicture();
            } else {
                ActivityCompat.requestPermissions(getActivity(),
                        new String[]{Manifest.permission.CAMERA,
                                Manifest.permission.WRITE_EXTERNAL_STORAGE}, REQUEST_TAKE_PHOTO_AND_SAVE);
            }
        }
    };

    public boolean checkAndRequestPermission(Activity context) {
        int extStorePermission = ContextCompat.checkSelfPermission(context,
                Manifest.permission.READ_EXTERNAL_STORAGE);
        int cameraPermission = ContextCompat.checkSelfPermission(context,
                Manifest.permission.CAMERA);

        List<String> listPermissionsNeeded = new ArrayList<>();

        if (cameraPermission != PackageManager.PERMISSION_GRANTED) {
            listPermissionsNeeded.add(Manifest.permission.CAMERA);
        }
        if (extStorePermission != PackageManager.PERMISSION_GRANTED) {
            listPermissionsNeeded
                    .add(Manifest.permission.WRITE_EXTERNAL_STORAGE);
        }
        if (!listPermissionsNeeded.isEmpty()) {
            ActivityCompat.requestPermissions(context, listPermissionsNeeded
                            .toArray(new String[listPermissionsNeeded.size()]),
                    REQUEST_TAKE_PHOTO_AND_SAVE);
            return false;
        }
        return true;
    }

    private View.OnClickListener saveButtonOnClickListener = new View.OnClickListener() {
        @Override
        public void onClick(View v) {
            updateEntries();
            ((MainActivity) getActivity()).closeExtended();
        }
    };

    public ExtendedInfoFragment() {
        // Required empty public constructor
    }

    public static ExtendedInfoFragment newInstance(String id) {
        Fragment fra = new ExtendedInfoFragment();
        Bundle bundle = new Bundle();
        bundle.putString(ARG_PARAM1, id);
        fra.setArguments(bundle);
        return (ExtendedInfoFragment) fra;
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        Log.d("oncreatemethod", "has been called");
        if (getArguments() != null) {
            row_id = getArguments().getString(ARG_PARAM1);
            Log.d("rowid", row_id);
        }
        Log.d("rowid", "Rowid: " + row_id);
    }

    /**
     * Initializing the layout items so we can edit them when receiving information from the DB.
     *
     * @param inflater
     * @param container
     * @param savedInstanceState
     * @return
     */
    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        View v = inflater.inflate(R.layout.fragment_extended_info, container, false);
        pictureView = v.findViewById(R.id.edit_pic);
        edit_amount = v.findViewById(R.id.edit_amount);
        edit_date = v.findViewById(R.id.edit_date);
        edit_desc = v.findViewById(R.id.edit_desc);
        edit_title = v.findViewById(R.id.edit_title);
        pictureView.setOnClickListener(takePictureOnClickListener);
        saveButton = v.findViewById(R.id.button_save);
        saveButton.setOnClickListener(saveButtonOnClickListener);
        fillForm(row_id);
        return v;
    }

    /**
     * This method will edit the text fields from our view based on the current list item.
     *
     * @param id id of the DB entry.
     */
    private void fillForm(String id) {
        if (id != null && !id.isEmpty()) {
            Cursor var = db.load(Integer.parseInt(id));
            if (var != null) {
                if (var.moveToFirst()) {
                    fillData(edit_date, "date_created", var);
                    fillData(edit_title, DbHelper.COLUMN_NAME, var);
                    fillData(edit_amount, DbHelper.COLUMN_AMOUNT, var);
                    fillData(edit_desc, DbHelper.COLUMN_COMENTARY, var);
                    fillData(pictureView, "photo", var);
                }
            }
        }
    }

    public void onButtonPressed(Uri uri) {
        if (mListener != null) {
            mListener.onFragmentInteraction(uri);
        }
    }

    @Override
    public void onAttach(Context context) {
        super.onAttach(context);
        if (context instanceof OnFragmentInteractionListener) {
            mListener = (OnFragmentInteractionListener) context;
        } else {
            throw new RuntimeException(context.toString()
                    + " must implement OnFragmentInteractionListener");
        }
    }

    @Override
    public void onDetach() {
        super.onDetach();
        mListener = null;
    }

    public boolean isValidInput(EditText e) {
        return (e != null && e.getText().toString().length() > 0);
    }

    public boolean isValidInput(ImageView v) {
        return v.getDrawable() != null;
    }

    public void fillData(EditText e, String column, Cursor c) {
        e.setText(c.getString(c.getColumnIndex(column)));
    }

    public void fillData(ImageView v, String column, Cursor c) {
        byteToImageView(c.getBlob(c.getColumnIndex(column)));
    }

    /**
     * This method starts a external activies (for capturing and storing a photo) and handles the input.
     * When our app can handle the intent then it'll be stored in a variable and saved in the storage
     * of the device.
     */
    private void generatePicture() {
        Intent intent = new Intent(MediaStore.ACTION_IMAGE_CAPTURE);
        // Ensure that there's a camera activity to handle the intent
        if (intent.resolveActivity(getActivity().getPackageManager()) != null) {
            File pictureDirectory = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_PICTURES);
            String pictureName = generatePictureName();
            File imageFile = new File(pictureDirectory, pictureName);
            Uri pictureUri = Uri.fromFile(imageFile);
            photoUri = pictureUri;
            intent.putExtra(MediaStore.EXTRA_OUTPUT, pictureUri);
            startActivityForResult(intent, REQUEST_TAKE_PHOTO_AND_SAVE);
        }

    }

    /**
     * This method generates the name of the picture.
     *
     * @return string name for the image
     */
    private String generatePictureName() {
        String timeStamp = new SimpleDateFormat("yyyyMMdd_HHmmss").format(new Date());
        String prefix = "JPEG_" + timeStamp;
        String suffix = ".jpg";
        return prefix + suffix;
    }

    /**
     * This method checks the result of the intent for taking a picture and if everything was fine
     * it'll place the image within the activity after taking it.
     */
    @Override
    public void onActivityResult(int requestCode, int resultCode, Intent data) {
        if (requestCode == REQUEST_TAKE_PHOTO_AND_SAVE) {
            if (resultCode == RESULT_OK) {
                Log.d("JA", "JAAAAAAAAAA");
                pictureView.setImageURI(photoUri);
            }
        }
    }

    public void updateEntries() {
        int id = Integer.parseInt(row_id);

        if (isValidInput(edit_title))
            db.editObject(id, edit_title.getText().toString(), DbHelper.COLUMN_NAME);
        if (isValidInput(edit_desc))
            db.editObject(id, edit_desc.getText().toString(), DbHelper.COLUMN_COMENTARY);
        if (isValidInput(edit_amount))
            db.editObject(id, edit_amount.getText().toString(), DbHelper.COLUMN_AMOUNT);
        if (isValidInput(pictureView)) db.editObject(id, imageViewToByte(pictureView));
    }

    public byte[] imageViewToByte(ImageView v) {
        if (isValidInput(v)) {
            Bitmap bitmap = ((BitmapDrawable) v.getDrawable()).getBitmap();
            ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
            bitmap.compress(Bitmap.CompressFormat.PNG, 50, outputStream);
            byte[] byteArr = outputStream.toByteArray();
            return byteArr;
        }
        return null;
    }

    public ImageView byteToImageView(byte[] arr) {
        if (arr != null && arr.length > 0) {
            Bitmap bmp = BitmapFactory.decodeByteArray(arr, 0, arr.length);
            ImageView image = pictureView;

            image.setImageBitmap(Bitmap.createBitmap(bmp));
            return image;
        }
        return null;
    }


    /**
     * This interface must be implemented by activities that contain this
     * fragment to allow an interaction in this fragment to be communicated
     * to the activity and potentially other fragments contained in that
     * activity.
     * <p>
     * See the Android Training lesson <a href=
     * "http://developer.android.com/training/basics/fragments/communicating.html"
     * >Communicating with Other Fragments</a> for more information.
     */
    public interface OnFragmentInteractionListener {
        // TODO: Update argument type and name
        void onFragmentInteraction(Uri uri);
    }
}