package de.hdm.mad.ss18_schwablication;

import android.test.suitebuilder.TestSuiteBuilder;

import junit.framework.Test;

public class FullTestSuite {

    public FullTestSuite() {
        super();
    }

    public static Test suite() {
        return new TestSuiteBuilder(FullTestSuite.class)
                .includeAllPackagesUnderHere().build();

    }
}
