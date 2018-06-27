package de.hdm.mad.ss18_schwablication;

import android.app.Fragment;
import android.app.FragmentManager;
import android.app.FragmentTransaction;
import android.content.Context;
import android.graphics.Rect;
import android.net.Uri;
import android.os.Bundle;
import android.support.annotation.NonNull;
import android.support.design.widget.BottomNavigationView;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.Toolbar;
import android.view.MenuItem;
import android.view.MotionEvent;
import android.view.View;
import android.view.inputmethod.InputMethodManager;
import android.widget.EditText;
import android.widget.Toast;

public class MainActivity extends AppCompatActivity
        implements ExtendedInfoFragment.OnFragmentInteractionListener,
        HomeFragment.OnFragmentInteractionListener, ListViewFragment.OnFragmentInteractionListener {
    public static DbHelper db;
    private BottomNavigationView navbar;

    /**
     * Handler for the bottom navigation bar.
     * When selecting the home icon it'll open the HomeFragment.
     * When selecting the list icon it'' open the ListFragment.
     * The note fragment is not done yet. In this fragment you'll be able to add random notes for
     * yourself later on.
     */
    private BottomNavigationView.OnNavigationItemSelectedListener navbarhandler = new BottomNavigationView.OnNavigationItemSelectedListener() {
        @Override
        public boolean onNavigationItemSelected(@NonNull MenuItem item) {
            switch (item.getItemId()){
                case R.id.action_notes:
                    Toast.makeText(getApplicationContext(), "To be implemented!", Toast.LENGTH_LONG).show();
                    break;
                case R.id.action_home:
                    openFragment(HomeFragment.newInstance());
                    break;
                case R.id.action_list:
                    openFragment(ListViewFragment.newInstance());
                    break;
            }
            return true;
        }
    };

    /**
     * Changes the current view of the app.
     * Will call the transaction handler for fragments and replace the current layout with the one
     * from the passed fragment..
     *
     * @param frag new fragment to open
     */
    public void openFragment(Fragment frag) {
        FragmentTransaction transaction = getFragmentManager().beginTransaction();
        transaction.replace(R.id.frag_container, frag).commit();
    }

    /**
     * When starting the app we initialize the database helper class
     * and also set our bottom navigation and top toolbar.
     * @param savedInstanceState
     */
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        db = new DbHelper(this);

        navbar = findViewById(R.id.bottom_navigation);

        navbar.setOnNavigationItemSelectedListener(navbarhandler);
        Toolbar myToolbar = findViewById(R.id.my_toolbar);
        setSupportActionBar(myToolbar);
        openFragment(HomeFragment.newInstance());
    }

    @Override
    public boolean dispatchTouchEvent(MotionEvent event) {
        if (event.getAction() == MotionEvent.ACTION_DOWN) {
            View v = getCurrentFocus();
            if (v instanceof EditText) {
                Rect outRect = new Rect();
                v.getGlobalVisibleRect(outRect);
                if (!outRect.contains((int) event.getRawX(), (int) event.getRawY())) {
                    v.clearFocus();
                    InputMethodManager imm = (InputMethodManager) getSystemService(Context.INPUT_METHOD_SERVICE);
                    imm.hideSoftInputFromWindow(v.getWindowToken(), 0);
                }
            }
        }
        return super.dispatchTouchEvent(event);
    }




    @Override
    public void onBackPressed() {
        closeExtended();
    }

    public void closeExtended() {
        if (getFragmentManager().getBackStackEntryCount() > 0) {
            getFragmentManager().popBackStack("extended", FragmentManager.POP_BACK_STACK_INCLUSIVE);
        } else {
            super.onBackPressed();
        }
    }

    @Override
    public void onFragmentInteraction(Uri uri) {

    }
}
