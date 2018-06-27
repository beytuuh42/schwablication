package de.hdm.mad.ss18_schwablication;

import android.content.ContentValues;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.support.test.runner.AndroidJUnit4;
import android.test.AndroidTestCase;
import android.test.RenamingDelegatingContext;
import android.test.suitebuilder.annotation.LargeTest;
import android.util.Log;

import org.junit.After;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;

import java.util.Map;
import java.util.Set;

@RunWith(AndroidJUnit4.class)
@LargeTest

public class DbHelperUnitTest extends AndroidTestCase {
    public static final String LOG_TAG = DbHelperUnitTest.class.getSimpleName();
    private DbHelper dataSource;

    static void validateCursor(Cursor valueCursor, ContentValues expectedValues) {
        assertTrue(valueCursor.moveToFirst());
        Set<Map.Entry<String, Object>> valueSet = expectedValues.valueSet();
        for (Map.Entry<String, Object> entry : valueSet) {
            String columnName = entry.getKey();
            int idx = valueCursor.getColumnIndex(columnName);
            assertFalse(idx == -1);
            String expectedValue = entry.getValue().toString();
            assertEquals(expectedValue, valueCursor.getString(idx));
        }
        valueCursor.close();
    }

    public void testCreateDb() {
        mContext.deleteDatabase(DbHelper.DB_NAME);
        SQLiteDatabase db = new DbHelper(
                this.mContext).getWritableDatabase();
        assertEquals(true, db.isOpen());
        db.close();
    }

    @Before
    public void setUp() throws Exception {

        super.setUp();
        RenamingDelegatingContext context = new RenamingDelegatingContext(getContext(), "test_");
        dataSource = new DbHelper(context);

    }

    @After
    public void tearDown() throws Exception {
        dataSource.close();
        super.tearDown();
    }

    @Test
    public void testPreConditions() {
        assertNotNull(dataSource);
    }

    public void testInsertReadDb() {
        // Test data we're going to insert into the DB to see if it works.
        String testId = "17005";
        String testName = "Adidas Shoe";
        String testComment = "Those white shoes I bought in Metzingen.";
        String testAmount = "49";
        String testCate = "Ausgaben";

        // If there's an error in those massive SQL table creation Strings,
        // errors will be thrown here when you try to get a writable database.
        DbHelper dbHelper = new DbHelper(mContext);
        SQLiteDatabase db = dbHelper.getWritableDatabase();
        // Create a new map of values, where column names are the keys
        ContentValues values = new ContentValues();

        values.put(DbHelper.COLUMN_ID, testId);
        values.put(DbHelper.COLUMN_NAME, testName);
        values.put(DbHelper.COLUMN_COMENTARY, testComment);
        values.put(DbHelper.COLUMN_AMOUNT, testAmount);
        values.put(DbHelper.COLUMN_CATEGORIES, testCate);

        long locationRowId;
        locationRowId = db.insert(DbHelper.DB_NAME, null, values);
        // Verify we got a row back.
        assertTrue(locationRowId != -1);
        Log.d(LOG_TAG, "New row id: " + locationRowId);
        // Data's inserted.  IN THEORY.  Now pull some out to stare at it and verify it made
        // the round trip.
        // Specify which columns you want.
        String[] columns = {
                DbHelper.COLUMN_ID,
                DbHelper.COLUMN_NAME,
                DbHelper.COLUMN_COMENTARY,
                DbHelper.COLUMN_AMOUNT,
                DbHelper.COLUMN_CATEGORIES,

        };
        // A cursor is your primary interface to the query results.
        Cursor cursor = db.query(
                DbHelper.DB_NAME,  // Table to Query
                columns,
                null, // Columns for the "where" clause
                null, // Values for the "where" clause
                null, // columns to group by
                null, // columns to filter by row groups
                null // sort order
        );

    }
}
