import logging.JsLogger;
import logging.SystemLogger;
import org.junit.BeforeClass;
import org.junit.Test;

import java.io.File;

import static org.junit.Assert.assertEquals;

public class XsltFileTest {

    public static final String RESOURCES = "src/test/resources";

    @BeforeClass
    public static void init(){
        Xslt2.init(new JsLogger(null, "log"));
    }

    @Test
    public void testRequestSummary(){
        String result = Xslt2.transform(new File(RESOURCES, "source1.xml"),
                new File(RESOURCES, "source3.xsl"));
        assertEquals("", result);
    }
}
