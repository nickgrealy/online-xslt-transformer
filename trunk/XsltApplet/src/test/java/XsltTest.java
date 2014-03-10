import org.junit.After;
import org.junit.Before;
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

    String errMesg1 = "FATAL: No character data is allowed between top-level elements; SystemID: file:/C:/devtools/Workspace/XsltApplet/src/test/resources/source1.xsl; Line#: 2; Column#: -1\n" +
            "TRANSFORM_ERROR: Failed to compile stylesheet. 1 error detected.\n";
    String errMesg2 = "FATAL: Element must have a \"version\" attribute; SystemID: ; Line#: 1; Column#: -1\n" +
            "TRANSFORM_ERROR: Failed to compile stylesheet. 1 error detected.\n";
    String errMesg3 = "FATAL: No character data is allowed between top-level elements; SystemID: ; Line#: 1; Column#: -1\n" +
            "TRANSFORM_ERROR: Failed to compile stylesheet. 1 error detected.\n";
    String errMesg4 = "FATAL: Error reported by XML parser; Line#: 1; Column#: 13\n" +
            "TRANSFORM_ERROR: org.xml.sax.SAXParseException; lineNumber: 1; columnNumber: 13; The element type \"b\" must be terminated by the matching end-tag \"</b>\".\n";

    private XsltApplet applet;

    @Before
    public void setUp() {
        applet = new XsltApplet();
        applet.init();
    }

    @After
    public void tearDown() {
        applet.destroy();
    }

    @Test
    public void testValidXslTransform() {
        assertEquals(expected1, applet.transform(xml, xsl));
    }

    @Test
    public void testNonBreakingWhitespace() {
        assertEquals(expected1, applet.transform(xml, xslNonBreakingWhitespace));
        assertEquals("", applet.getErrorMessages()); // was errMesg3
    }

    @Test
    public void testInvalidXslTransform() {
        assertEquals("", applet.transform(xml, xslInvalid));
        assertEquals(errMesg2, applet.getErrorMessages());
    }

    @Test
    public void testInvalidXmlTransform() {
        assertEquals("", applet.transform(xmlInvalid, xsl));
        assertEquals(errMesg4, applet.getErrorMessages());
    }

//    @Test
//    public void testFileTransform1() {
//        assertEquals(expected2, applet.transform(new File("src/test/resources/source1.xml"),
//                new File("src/test/resources/source1.xsl")));
//        assertEquals("", applet.getErrorMessages()); // was errMesg1
//    }
}
