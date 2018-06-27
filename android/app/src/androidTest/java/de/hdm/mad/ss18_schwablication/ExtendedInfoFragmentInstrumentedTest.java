package de.hdm.mad.ss18_schwablication;

import android.content.Intent;
import android.support.test.rule.ActivityTestRule;
import android.support.test.runner.AndroidJUnit4;

import org.junit.Before;
import org.junit.Rule;
import org.junit.Test;
import org.junit.runner.RunWith;

import static android.support.test.espresso.Espresso.onView;
import static android.support.test.espresso.action.ViewActions.closeSoftKeyboard;
import static android.support.test.espresso.action.ViewActions.replaceText;
import static android.support.test.espresso.assertion.ViewAssertions.matches;
import static android.support.test.espresso.matcher.ViewMatchers.isDisplayed;
import static android.support.test.espresso.matcher.ViewMatchers.withId;
import static android.support.test.espresso.matcher.ViewMatchers.withText;


@RunWith(AndroidJUnit4.class)
public class ExtendedInfoFragmentInstrumentedTest {
    @Rule
    public ActivityTestRule<MainActivity> mActivityRule = new ActivityTestRule<>(MainActivity.class, true, true);

    @Before
    public void init() {
        mActivityRule.launchActivity(new Intent());
        mActivityRule.getActivity().db.clearAll();
        fillSampleData();
        mActivityRule.getActivity().openFragment(ExtendedInfoFragment.newInstance("1"));
    }

    @Test
    public void displayFragment() {
        onView(withId(R.id.fragment_extended_info)).check(matches(isDisplayed()));
    }

    @Test
    public void fillForm() {
        onView(withId(R.id.edit_amount)).check(matches(withText("50")));
    }

    @Test
    public void textChanges() {

        //Title text field
        onView(withId(R.id.edit_title)).perform(replaceText("Shopping"), closeSoftKeyboard());
        onView(withId(R.id.edit_title)).check(matches(withText("Shopping")));

        //Amount text field
        onView(withId(R.id.edit_amount)).perform(replaceText("500"), closeSoftKeyboard());
        onView(withId(R.id.edit_amount)).check(matches(withText("500")));

        //Description text field
        onView(withId(R.id.edit_desc)).perform(replaceText("Bought jeans from gucci"), closeSoftKeyboard());
        onView(withId(R.id.edit_desc)).check(matches(withText("Bought jeans from gucci")));

        //Date text field
        onView(withId(R.id.edit_date)).perform(replaceText("05.05.2016"), closeSoftKeyboard());
        onView(withId(R.id.edit_date)).check(matches(withText("05.05.2016")));
    }

    public void fillSampleData() {
        mActivityRule.getActivity().db.addObject("Ausgaben", "50", "Jeans");
    }
}
