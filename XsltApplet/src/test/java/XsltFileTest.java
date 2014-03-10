import org.junit.BeforeClass;
import org.junit.Test;

import java.io.File;

import static org.junit.Assert.assertEquals;

public class XsltFileTest {

    public static final String RESOURCES = "src/test/resources";

    @BeforeClass
    public static void init(){
        Xslt2.init();
    }

    @Test
    public void testRequestSummary(){
        String result = Xslt2.transform(new File(RESOURCES, "requestSummary.xml"),
                new File(RESOURCES, "requestSummary.xsl"));
        assertEquals("", result);
    }
}
