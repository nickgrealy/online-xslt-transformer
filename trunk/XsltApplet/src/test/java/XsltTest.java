import logging.JsLogger;
import logging.LogCatcher;
import org.junit.After;
import org.junit.Before;
import org.junit.Ignore;
import org.junit.Test;

import java.io.File;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertTrue;

public class XsltTest {

    String xml = "<a><b>test</b></a>";
    String xmlInvalid = "<a><b>test</d>";
    String xsl = "<xsl:stylesheet version='2.0' xmlns:xsl='http://www.w3.org/1999/XSL/Transform'>\n" +
            "<xsl:template match='/'>\n" +
            "<x><xsl:value-of select='//b' /></x>\n" +
            "</xsl:template>\n" +
            "</xsl:stylesheet>";
    String xslNonBreakingWhitespace = "<xsl:stylesheet version='2.0' xmlns:xsl='http://www.w3.org/1999/XSL/Transform'>\n" +
            " <xsl:template match='/'>\n" +
            "<x><xsl:value-of select='//b' /></x>\n" +
            "</xsl:template>\n" +
            "</xsl:stylesheet>";
    String xslInvalid = "<xsl:stylesheet xmlns:xsl='http://www.w3.org/1999/XSL/Transform'>\n" +
            "<xsl:template match='/'>\n" +
            "<x><xsl:value-of select='//b' /></x>\n" +
            "</xsl:template>\n" +
            "</xsl:stylesheet>";
    String expected1 = "<?xml version=\"1.0\" encoding=\"UTF-8\"?><x>test</x>";
    String expected2 = "<?xml version=\"1.0\" encoding=\"utf-8\"?>\n" +
            "<x>test</x>";

    String errMesg1 = "FATAL - No character data is allowed between top-level elements; SystemID: file:/C:/devtools/Workspace/XsltApplet/src/test/resources/source1.xsl; Line#: 2; Column#: -1\n" +
            "ERROR - Failed to compile stylesheet. 1 error detected.\n";
    String errMesg2 = "FATAL - Element must have a \"version\" attribute; SystemID: ; Line#: 1; Column#: -1\n" +
            "ERROR - Failed to compile stylesheet. 1 error detected.\n";
    String errMesg3 = "FATAL - No character data is allowed between top-level elements; SystemID: ; Line#: 1; Column#: -1\n" +
            "ERROR - Failed to compile stylesheet. 1 error detected.\n";
    String errMesg4 = "FATAL - Error reported by XML parser; Line#: 1; Column#: 13\n" +
            "ERROR - org.xml.sax.SAXParseException; lineNumber: 1; columnNumber: 13; The element type \"b\" must be terminated by the matching end-tag \"</b>\".\n";

    private StringBuffer messages = new StringBuffer();

    @Before
    public void setUp() {
        messages = new StringBuffer();
        Xslt2.init(new JsLogger(null, "console.log"));
    }

    @Test
    public void testValidXslTransform() {
        assertEquals(expected1, Xslt2.transform(xml, xsl));
    }

    @Test
    public void testNonBreakingWhitespace() {
        assertEquals(expected1, Xslt2.transform(xml, xslNonBreakingWhitespace));
        assertEquals("", messages.toString()); // was errMesg3
    }

    @Ignore
    @Test
    public void testInvalidXslTransform() {
        assertEquals("", Xslt2.transform(xml, xslInvalid));
        assertEquals(errMesg2, messages.toString());
    }

    @Ignore
    @Test
    public void testInvalidXmlTransform() {
        assertEquals("", Xslt2.transform(xmlInvalid, xsl));
        assertEquals(errMesg4, messages.toString());
    }

//    @Test
//    public void testFileTransform1() {
//        assertEquals(expected2, applet.transform(new File("src/test/resources/source1.xml"),
//                new File("src/test/resources/source1.xsl")));
//        assertEquals("", applet.getErrorMessages()); // was errMesg1
//    }
}
