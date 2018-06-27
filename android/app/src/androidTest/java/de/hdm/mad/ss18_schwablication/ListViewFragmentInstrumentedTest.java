package de.hdm.mad.ss18_schwablication;

import android.content.Intent;
import android.support.test.espresso.assertion.ViewAssertions;
import android.support.test.rule.ActivityTestRule;
import android.support.test.runner.AndroidJUnit4;
import android.view.View;
import android.widget.ListView;

import org.hamcrest.Description;
import org.hamcrest.Matcher;
import org.hamcrest.TypeSafeMatcher;
import org.junit.Before;
import org.junit.Rule;
import org.junit.Test;
import org.junit.runner.RunWith;

import java.text.SimpleDateFormat;
import java.util.Date;

import static android.support.test.espresso.Espresso.onData;
import static android.support.test.espresso.Espresso.onView;
import static android.support.test.espresso.action.ViewActions.click;
import static android.support.test.espresso.assertion.ViewAssertions.matches;
import static android.support.test.espresso.matcher.ViewMatchers.isDisplayed;
import static android.support.test.espresso.matcher.ViewMatchers.withId;
import static android.support.test.espresso.matcher.ViewMatchers.withText;
import static org.hamcrest.CoreMatchers.anything;
import static org.hamcrest.CoreMatchers.endsWith;

@RunWith(AndroidJUnit4.class)
public class ListViewFragmentInstrumentedTest {
    @Rule
    public ActivityTestRule<MainActivity> mActivityRule = new ActivityTestRule<>(MainActivity.class, true, true);
    SimpleDateFormat dateFormat;
    Date date;

    @Before
    public void init() {
        mActivityRule.launchActivity(new Intent());
        MainActivity.db.clearAll();
        fillSampleData();
        mActivityRule.getActivity().openFragment(ListViewFragment.newInstance());
    }

    @Test
    public void displayFragment() {
        onView(withId(R.id.fragment_list_view)).check(matches(isDisplayed()));
    }

    @Test
    public void displayExtendedInfoFragment() {
        onData(anything()).inAdapterView(withId(R.id.itemsListView)).atPosition(0).perform(click());
        onView(withId(R.id.fragment_extended_info)).check(matches(isDisplayed()));
    }

    @Test
    public void expectedSize() {
        onView(withId(R.id.itemsListView)).check(ViewAssertions.matches(Matchers.withListSize(1)));
    }

    @Test
    public void expectedValues() {
        dateFormat = new SimpleDateFormat("dd MMM");
        date = new Date();
        onData(anything()).inAdapterView(withId(R.id.itemsListView)).atPosition(0).perform(click());
        onView(withId(R.id.edit_date)).check(matches(withText(endsWith(dateFormat.format(date)))));
    }

    public void fillSampleData() {
        MainActivity.db.addObject("Ausgaben", "10", "Jeans");
    }
}

class Matchers {
    public static Matcher<View> withListSize(final int size) {
        return new TypeSafeMatcher<View>() {
            @Override
            public boolean matchesSafely(final View view) {
                return ((ListView) view).getCount() == size;
            }

            @Override
            public void describeTo(final Description description) {
                description.appendText("ListView should have " + size + " items");
            }
        };
    }
}