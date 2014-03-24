import logging.JsLogger;
import org.junit.Test;

import static org.junit.Assert.assertEquals;

public class JsParseTest {

    @Test
    public void testXmlNL() {
        assertEquals("ab", JsLogger.parse("a&xa0;b"));
    }

    @Test
    public void testXmlNL2() {
        assertEquals("ab", JsLogger.parse("a&#10;b"));
    }

    @Test
    public void testNewline() {
        assertEquals("ab", JsLogger.parse("a\nb\n"));
    }

    @Test
    public void testCarriageReturn() {
        assertEquals("ab", JsLogger.parse("a\rb\r"));
    }

    @Test
    public void testSingleQuoteEscape() {
        assertEquals("a\\'b", JsLogger.parse("a'b"));
    }

    @Test
    public void testSingleQuoteEscape2() {
        assertEquals("a\\'b", JsLogger.parse("a\'b"));
    }

//    @Test
//    public void testSingleQuoteEscape3() {
//        assertEquals("a\\'b", JsLogger.parse("a\\'b"));
//    }
}
