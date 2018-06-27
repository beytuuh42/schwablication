package de.hdm.mad.ss18_schwablication;

import android.app.Fragment;
import android.content.Context;
import android.database.Cursor;
import android.graphics.Color;
import android.net.Uri;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.ListView;
import android.widget.SimpleCursorAdapter;
import android.widget.TextView;

import java.text.DecimalFormat;


    /**
     * A simple {@link Fragment} subclass.
     * Activities that contain this fragment must implement the
     * {@link ListViewFragment.OnFragmentInteractionListener} interface
     * to handle interaction events.
     * Use the {@link ListViewFragment#newInstance} factory method to
     * create an instance of this fragment.
     */
    public class ListViewFragment extends Fragment {
        DecimalFormat df = new DecimalFormat("0.00");
        private SimpleCursorAdapter dataAdapter;
        private OnFragmentInteractionListener mListener;

    public ListViewFragment() {
        // Required empty public constructor
    }

    public static ListViewFragment newInstance() {
        ListViewFragment fragment = new ListViewFragment();
        return fragment;
    }

    /**
     *
     * @param savedInstanceState if the activity needs to be recreated so that we dont lose the prior information
     */
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

    }

    /**
     * Initializing the layout
     * @param inflater
     * @param container
     * @param savedInstanceState
     * @return the displayListView method
     */
    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {

        View v = inflater.inflate(R.layout.fragment_list_view, container, false);
        displayListView(v);
        return v;
    }

    /**
     * This method is creating a listview by retrieving data from the DB.
     * It will save the db content in a cursor, column names and UI textview IDs in an array.
     * Those params will be passed to an adapter which will render the listview from it.
     * Also styling the output so incoming money is green outgoing red with a hyphen in front it.
     *
     * @param v
     */
    private void displayListView(View v) {
        Cursor c = MainActivity.db.getAllData();

        String[] from = new String[]{
                "date_created",
                DbHelper.COLUMN_NAME,
                DbHelper.COLUMN_AMOUNT
        };

        int[] to = new int[]{
                R.id.tv_list_item_date,
                R.id.tv_list_item_title,
                R.id.tv_list_item_amount
        };

        dataAdapter = new SimpleCursorAdapter(getActivity(), R.layout.list_view_items,
                c, from, to, 0);

        dataAdapter.setViewBinder(new SimpleCursorAdapter.ViewBinder() {
            @Override
            public boolean setViewValue(View view, Cursor cursor, int columnIndex) {
                if (columnIndex == 3) {
                    TextView v = (TextView) view;
                    if (cursor != null && cursor.getCount() > 0) {
                        String s = cursor.getString(cursor.getColumnIndex(DbHelper.COLUMN_CATEGORIES));
                        String s2 = cursor.getString(cursor.getColumnIndex(DbHelper.COLUMN_AMOUNT));
                        if (s.equals(DbHelper.CATEGORY_OUT)) {
                            v.setText(String.format("- %s", df.format(Double.parseDouble(s2))).replace(".", ", "));
                            v.setTextColor(Color.RED);
                        } else {
                            v.setText((df.format(Double.parseDouble(s2))).replace(".", ", "));
                            v.setTextColor(Color.rgb(0, 100, 0));
                        }
                        return true;
                    }

                }
                return false;
            }

        });

        ListView lv = v.findViewById(R.id.itemsListView);
        lv.setAdapter(dataAdapter);

        lv.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> listView, View view,
                                    int position, long id) {
                Fragment nextFrag = ExtendedInfoFragment.newInstance(String.valueOf(id));
                getActivity().getFragmentManager().beginTransaction()
                        .replace(R.id.frag_container, nextFrag, "extended")
                        .addToBackStack("extended")
                        .commit();
            }
        });
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

    public interface OnFragmentInteractionListener {
        // TODO: Update argument type and name
        void onFragmentInteraction(Uri uri);
    }
}
