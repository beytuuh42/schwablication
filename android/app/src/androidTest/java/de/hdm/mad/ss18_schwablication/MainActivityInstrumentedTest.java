package de.hdm.mad.ss18_schwablication;

import android.content.Intent;
import android.support.test.rule.ActivityTestRule;
import android.support.test.runner.AndroidJUnit4;

import org.junit.Before;
import org.junit.Rule;
import org.junit.Test;
import org.junit.runner.RunWith;

import static android.support.test.espresso.Espresso.onView;
import static android.support.test.espresso.action.ViewActions.click;
import static android.support.test.espresso.assertion.ViewAssertions.matches;
import static android.support.test.espresso.matcher.ViewMatchers.isDisplayed;
import static android.support.test.espresso.matcher.ViewMatchers.withId;
import static android.support.test.espresso.matcher.ViewMatchers.withParent;
import static android.support.test.espresso.matcher.ViewMatchers.withText;

@RunWith(AndroidJUnit4.class)
public class MainActivityInstrumentedTest {

    @Rule
    public ActivityTestRule<MainActivity> mActivityRule = new ActivityTestRule<>(MainActivity.class, true, true);
    String appName;

    @Before
    public void init() {
        mActivityRule.launchActivity(new Intent());
        appName = mActivityRule.getActivity().getResources().getString(R.string.app_name);
        fillSampleData();
    }

    @Test
    public void toolbar() {
        onView(withId(R.id.my_toolbar)).check(matches(isDisplayed()));
        //testing toolbarname
        onView(withText(R.string.app_name)).check(matches(withParent(withId(R.id.my_toolbar))));
    }

    @Test
    public void selectedNavBarItem() {
        onView(withId(R.id.action_list)).perform(click());
        displayListFragment();

        onView(withId(R.id.action_home)).perform(click());
        displayHomeFragment();
    }

    @Test
    public void openFragment() {
        mActivityRule.getActivity().openFragment(HomeFragment.newInstance());
        displayHomeFragment();

        mActivityRule.getActivity().openFragment(ListViewFragment.newInstance());
        displayListFragment();

        mActivityRule.getActivity().openFragment(ExtendedInfoFragment.newInstance("1"));
        displayExtendedFragment();
    }

    public void displayHomeFragment() {
        onView(withId(R.id.fragment_home)).check(matches(isDisplayed()));
    }

    public void displayListFragment() {
        onView(withId(R.id.fragment_list_view)).check(matches(isDisplayed()));
    }

    public void displayExtendedFragment() {
        onView(withId(R.id.fragment_extended_info)).check(matches(isDisplayed()));
    }

    public void fillSampleData() {
        mActivityRule.getActivity().db.addObject("Ausgaben", "50", "Jeans");
    }
}
