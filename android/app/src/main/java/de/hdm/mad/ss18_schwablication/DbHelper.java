package de.hdm.mad.ss18_schwablication;


import android.content.ContentValues;
import android.content.Context;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteOpenHelper;
import android.util.Log;

import java.text.SimpleDateFormat;
import java.util.Date;

public class DbHelper extends SQLiteOpenHelper {

    public static final String DB_NAME = "schwablication_list";
    public static final int DB_VERSION = 1;
    public static final String TABLE_SCHWABLICATION_LIST = "schwablication_list";
    public static final String COLUMN_ID = "_id";
    public static final String COLUMN_NAME = "name";
    public static final String COLUMN_COMENTARY = "comentary";
    public static final String COLUMN_AMOUNT = "amount";
    public static final String COLUMN_CATEGORIES = "categories";
    public static final String CATEGORY_IN = "Einkommen";
    public static final String CATEGORY_OUT = "Ausgaben";
    public static final String SQL_CREATE =
            "CREATE TABLE " + TABLE_SCHWABLICATION_LIST +
                    "(" + COLUMN_ID + " INTEGER PRIMARY KEY AUTOINCREMENT, " +
                    COLUMN_NAME + " TEXT , " +
                    COLUMN_COMENTARY + " TEXT , " +
                    COLUMN_AMOUNT + " DECIMAL(10,2) , " +
                    COLUMN_CATEGORIES + " TEXT , " +
                    "date_created date default current_timestamp , " +
                    "photo blob);";
    private static final String LOG_TAG = DbHelper.class.getSimpleName();
    public static String arr[];

    public DbHelper(Context context) {
        // super(context, "PLATZHALTER_DATENBANKNAME", null, 1);
        super(context, DB_NAME, null, DB_VERSION);
        Log.d(LOG_TAG, "DbHelper hat die Datenbank: " + getDatabaseName() + " erzeugt.");
    }

    /**
     * This method will only execute if the database doesn't exist already.
     *
     * @param db db object
     */
    @Override
    public void onCreate(SQLiteDatabase db) {
        try {
            Log.d(LOG_TAG, "Die Tabelle wird mit SQL-Befehl: " + SQL_CREATE + " angelegt.");
            db.execSQL(SQL_CREATE);
        } catch (Exception ex) {
            Log.e(LOG_TAG, "Fehler beim Anlegen der Tabelle: " + ex.getMessage());
        }
    }

    @Override
    public void onUpgrade(SQLiteDatabase db, int oldVersion, int newVersion) {

    }

    /**
     * This method is executing a query for the db.
     *
     * @param txt query for the db.
     * @return Dataset as a cursor object
     */
    public Cursor getData(String txt) {
        SQLiteDatabase db = this.getReadableDatabase();
        Cursor res = db.rawQuery(txt, null);
        return res;
    }

    /**
     * This method is retrieving all data from the db.
     *
     * @return cursor with content of the query.
     */

    public Cursor getAllData() {
        SQLiteDatabase db = this.getReadableDatabase();
        Cursor cur = db.rawQuery("SELECT * FROM " + TABLE_SCHWABLICATION_LIST, null);
        return cur;
    }

    /**
     * This methods inserts the params to the db.
     *
     * @param cate   category value
     * @param betrag amount value
     */
    public void addObject(String cate, String betrag, String title) {
        SQLiteDatabase db = this.getReadableDatabase();
        ContentValues cv = new ContentValues();
        cv.put(COLUMN_CATEGORIES, cate);
        cv.put(COLUMN_AMOUNT, betrag);
        cv.put(COLUMN_NAME, title);
        cv.put("date_created", getNowDate());
        db.insert(TABLE_SCHWABLICATION_LIST, null, cv);
    }

    /**
     * This methods updates an entry of the database.
     *
     * @param id     id of the column
     * @param value  value of the input
     * @param column column to insert
     */
    public void editObject(Integer id, String value, String column) {
        SQLiteDatabase db = this.getReadableDatabase();
        ContentValues cv = new ContentValues();
        cv.put(column, value);
        db.update(TABLE_SCHWABLICATION_LIST, cv, "_id like '" + id + "'", null);
    }

    public void editObject(Integer id, byte[] pic) {
        SQLiteDatabase db = this.getReadableDatabase();
        ContentValues cv = new ContentValues();
        cv.put("photo", pic);
        db.update(TABLE_SCHWABLICATION_LIST, cv, "_id like '" + id + "'", null);
    }

    /**
     * This methods finds a specific entry based on the id.
     *
     * @param id id of the column
     * @return Dataset as a cursor object
     */
    public Cursor load(Integer id) {
        SQLiteDatabase db = this.getReadableDatabase();
        String txt = "";
        Cursor cursor = db.rawQuery("Select * from " + TABLE_SCHWABLICATION_LIST + " where _id like '" + id + "'", null);
        return cursor;
    }

    /**
     * This method clears the database.
     */
    public void clearAll() {
        SQLiteDatabase db = this.getReadableDatabase();
        db.execSQL("delete from " + TABLE_SCHWABLICATION_LIST);
        db.execSQL("delete from sqlite_sequence where name='" + TABLE_SCHWABLICATION_LIST + "'");
    }

    /**
     * This methods retrieves the current datetime.
     *
     * @return formatted datetime
     */
    public String getNowDate() {
        // set the format to sql date time
        SimpleDateFormat dateFormat = new SimpleDateFormat("dd MMM");
        Date date = new Date();
        return dateFormat.format(date);
    }

    /**
     * This method sums the total amount.
     *
     * @return total amount value as a string
     */
    public String getTotalAmount() {
        SQLiteDatabase db = this.getReadableDatabase();
        Cursor c = db.rawQuery("SELECT SUM(" + COLUMN_AMOUNT + ") as TotalAmount FROM " + TABLE_SCHWABLICATION_LIST, null);
        String s = "";
        if (c.moveToFirst()) {
            s = c.getString(c.getColumnIndex("TotalAmount"));
        }
        return s;
    }

    /**
     * This method sums the outgoing total amount.
     *
     * @return outgoing total value as a string
     */
    public String getOutgoingAmount() {
        SQLiteDatabase db = this.getReadableDatabase();
        Cursor c = db.rawQuery("SELECT SUM(" + COLUMN_AMOUNT + ") as TotalOut FROM " + TABLE_SCHWABLICATION_LIST + " GROUP BY " + COLUMN_CATEGORIES + " HAVING " + COLUMN_CATEGORIES + "=" + String.format("'%s'", CATEGORY_OUT), null);
        String s = "";
        if (c.moveToFirst()) {
            s = c.getString(c.getColumnIndex("TotalOut"));
        }
        return s;
    }

    /**
     * This method sums the incoming total amount.
     *
     * @return incoming total value as a string
     */
    public String getIncomingAmount() {
        SQLiteDatabase db = this.getReadableDatabase();
        Cursor c = db.rawQuery("SELECT SUM(" + COLUMN_AMOUNT + ") as TotalIn FROM " + TABLE_SCHWABLICATION_LIST + " GROUP BY " + COLUMN_CATEGORIES + " HAVING " + COLUMN_CATEGORIES + " =" + String.format("'%s'", CATEGORY_IN), null);
        String s = "";
        if (c.moveToFirst()) {
            s = c.getString(c.getColumnIndex("TotalIn"));
        }
        return s;
    }
}
