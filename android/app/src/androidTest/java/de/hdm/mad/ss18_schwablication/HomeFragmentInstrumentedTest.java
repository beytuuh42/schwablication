
package de.hdm.mad.ss18_schwablication;

import android.content.Intent;
import android.support.test.filters.LargeTest;
import android.support.test.rule.ActivityTestRule;
import android.support.test.runner.AndroidJUnit4;

import org.junit.Before;
import org.junit.Rule;
import org.junit.Test;
import org.junit.runner.RunWith;

import static android.support.test.espresso.Espresso.onView;
import static android.support.test.espresso.action.ViewActions.click;
import static android.support.test.espresso.assertion.ViewAssertions.matches;
import static android.support.test.espresso.matcher.ViewMatchers.isClickable;
import static android.support.test.espresso.matcher.ViewMatchers.isCompletelyDisplayed;
import static android.support.test.espresso.matcher.ViewMatchers.isDescendantOfA;
import static android.support.test.espresso.matcher.ViewMatchers.withId;
import static org.hamcrest.core.AllOf.allOf;

@RunWith(AndroidJUnit4.class)
@LargeTest
public class HomeFragmentInstrumentedTest {
    @Rule
    public ActivityTestRule<MainActivity> mActivityRule = new ActivityTestRule<>(MainActivity.class, true, true);

    @Before
    public void init() {
        mActivityRule.launchActivity(new Intent());
    }

    @Test
    public void clickMinusButton() {
        //locate and click on the minus button
        onView(withId(R.id.minus)).perform(click());

        //check that the minus button is worked
        onView(withId(R.id.minus)).check(matches(allOf(isDescendantOfA(withId(R.id.fragment_home)), isClickable())));
    }

    @Test
    public void clickPlusButton() {
        //locate and click on the plus button
        onView(withId(R.id.plus)).perform(click());

        //check that the plus button is worked
        onView(withId(R.id.plus)).check(matches(allOf(isDescendantOfA(withId(R.id.fragment_home)), isClickable())));
    }

    @Test
    public void chekPieChart() {
        //check that the chart is displayed by start fragment home
        onView(withId(R.id.chart)).check(matches(allOf(isDescendantOfA(withId(R.id.fragment_home)), isCompletelyDisplayed())));
    }


}
