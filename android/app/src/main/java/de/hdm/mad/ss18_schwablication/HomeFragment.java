package de.hdm.mad.ss18_schwablication;

import android.app.Fragment;
import android.content.Context;
import android.graphics.Color;
import android.net.Uri;
import android.os.Bundle;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.inputmethod.InputMethodManager;
import android.widget.Button;
import android.widget.EditText;
import android.widget.Toast;

import com.github.mikephil.charting.animation.Easing;
import com.github.mikephil.charting.charts.PieChart;
import com.github.mikephil.charting.data.PieData;
import com.github.mikephil.charting.data.PieDataSet;
import com.github.mikephil.charting.data.PieEntry;

import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.List;


/**
 * A simple {@link Fragment} subclass.
 * Activities that contain this fragment must implement the
 * {@link HomeFragment.OnFragmentInteractionListener} interface
 * to handle interaction events.
 * Use the {@link HomeFragment#newInstance} factory method to
 * create an instance of this fragment.
 */
public class HomeFragment extends Fragment {
    public static final int[] test_COLORS = {Color.rgb(249, 58, 75), Color.rgb(72, 149, 75)};
    EditText inEditText;
    EditText outEditText;
    EditText titleEditText;
    View fragmentView;
    double incomSum = 0;
    double outgoSum = 0;
    double balance = 0;

    double rainfall[] = {outgoSum, incomSum};

    String charName[] = {"", ""};
    String s = MainActivity.db.getTotalAmount();
    String in = MainActivity.db.getIncomingAmount();
    String out = MainActivity.db.getOutgoingAmount();
    DecimalFormat df = new DecimalFormat("0.00");
    String balanceString = String.valueOf(df.format(balance)) + " €";

    private OnFragmentInteractionListener mListener;

    /**
     * OnClickListener for click the + button.
     * This method is checking for a valid input and accordingly updating the chart and adding
     * the input tot the DB.
     */

    private View.OnClickListener showNameBtnOnClickListener = new View.OnClickListener() {
        @Override
        public void onClick(View v) {
            String s = inEditText.getText().toString();
            String s2 = titleEditText.getText().toString();
            if (s.isEmpty() || s2.isEmpty()) {
                Toast.makeText(getActivity(), "Bitte den Betrag/Titel eingeben.", Toast.LENGTH_LONG).show();
            } else {
                incomSum = Double.parseDouble(s);
                rainfall[1] = incomSum;
                MainActivity.db.addObject(DbHelper.CATEGORY_IN, String.valueOf(incomSum), s2);
                upDateBilanz();
                inEditText.setText("");
            }
            if (v != null) {
                hideKeyboard(v);
            }
        }
    };

    /**
     * OnClickListener for click the + button.
     * This method is checking for a valid input and accordingly updating the chart and adding
     * the input tot the DB.
     */
    private View.OnClickListener showNameBtn2OnClickListener = new View.OnClickListener() {
        @Override
        public void onClick(View v) {
            String s = outEditText.getText().toString();
            String s2 = titleEditText.getText().toString();
            if (s.isEmpty() || s2.isEmpty()) {
                Toast.makeText(getActivity(), "Bitte den Betrag/Titel eingeben.", Toast.LENGTH_LONG).show();
            } else {
                outgoSum = Double.parseDouble(s);

                if (outgoSum < 0) outgoSum = Math.abs(outgoSum);
                rainfall[0] = outgoSum;

                MainActivity.db.addObject(DbHelper.CATEGORY_OUT, String.valueOf(outgoSum), s2);
                upDateBilanz();
                outEditText.setText("");
            }
            if (v != null) {
                hideKeyboard(v);
            }
        }
    };

    public void hideKeyboard(View v) {
        InputMethodManager imm = (InputMethodManager) getActivity().getSystemService(Context.INPUT_METHOD_SERVICE);
        imm.hideSoftInputFromWindow(v.getWindowToken(), 0);
    }

    public HomeFragment() {
        // Required empty public constructor
    }

    public static HomeFragment newInstance() {
        HomeFragment fragment = new HomeFragment();
        return fragment;
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        refresh();
    }


    /**
     * Fetch data from db and work with that.
     */
    private void refresh() {
        s = MainActivity.db.getTotalAmount();
        in = MainActivity.db.getIncomingAmount();
        out = MainActivity.db.getOutgoingAmount();

        if (in != null && !in.isEmpty()) {
            Log.d("in", in);
            incomSum = Double.parseDouble(in);
            rainfall[1] = incomSum;
        }
        if (out != null && !out.isEmpty()) {
            Log.d("out", out);
            outgoSum = Double.parseDouble(out);
            rainfall[0] = outgoSum;
        }
        if (s != null && !s.isEmpty()) {
            balance = Double.parseDouble(s);
            balanceString = String.valueOf(df.format(balance));
        }
    }

    /**
     * Initializing the text fields and buttons.
     * Also setting up the pie chart.
     */
    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {

        fragmentView = inflater.inflate(R.layout.fragment_home, container, false);
        upDateBilanz();
        titleEditText = fragmentView.findViewById(R.id.input_title);
        inEditText = fragmentView.findViewById(R.id.einkommen);
        final Button showNameBtn = fragmentView.findViewById(R.id.plus);
        showNameBtn.setOnClickListener(showNameBtnOnClickListener);

        outEditText = fragmentView.findViewById(R.id.ausgaben);
        final Button showNameBtn2 = fragmentView.findViewById(R.id.minus);
        showNameBtn2.setOnClickListener(showNameBtn2OnClickListener);

        return fragmentView;
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

    /**
     * Updating the total value.
     */
    public void upDateBilanz() {
        refresh();
        balance = incomSum - outgoSum;
        balanceString = String.valueOf(df.format(balance)) + " €";
        setupPieChart();
    }

    /**
     * Setting up the pie chart.
     */
    private void setupPieChart() {
        List<PieEntry> pieEntries = new ArrayList<>();

        for (int i = 0; i < rainfall.length; i++)
            pieEntries.add(new PieEntry((float) rainfall[i], charName[i]));


        PieDataSet dataSet = new PieDataSet(pieEntries, "");
        dataSet.setColors(test_COLORS);
        dataSet.setValueTextSize(30f);
        dataSet.setValueTextColor(Color.DKGRAY);
        PieData data = new PieData(dataSet);

        PieChart chart = fragmentView.findViewById(R.id.chart);

        chart.setData(data);
        if (balance < 0)
            chart.setCenterTextColor(Color.parseColor("#F2546F"));
        else if (balance > 0)
            chart.setCenterTextColor(Color.parseColor("#43C178"));
        else
            chart.setCenterTextColor(Color.parseColor("#404040"));

        chart.setCenterText(balanceString);
        chart.setCenterTextSize(25);
        chart.getDescription().setEnabled(false);
        chart.getLegend().setEnabled(false);
        chart.setDrawHoleEnabled(true);
        chart.setTransparentCircleRadius(95f);
        chart.setHoleRadius(80f);
        chart.animateY(3000, Easing.EasingOption.EaseInOutCubic);
        chart.setExtraOffsets(10f, 10f, 10f, 10f);
        chart.invalidate();
    }

    public interface OnFragmentInteractionListener {
        // TODO: Update argument type and name
        void onFragmentInteraction(Uri uri);
    }


}
