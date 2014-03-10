import javax.xml.transform.ErrorListener;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.stream.StreamSource;
import java.applet.Applet;
import java.io.File;
import java.io.StringReader;
import java.io.StringWriter;
import java.net.URI;
import java.net.URL;

public class Xslt2 {

    private Xslt2(){}

    public static final String NONBREAKING_WHITESPACE = " ";// this IS NOT your average whitespace!
    public static final String NORMAL_WHITESPACE = " ";     // this IS your average whitespace!

    private static TransformerFactory factory;
    private static Listener errorListener;
    private static StringBuffer errorMessages = new StringBuffer();

    public static void main(String[] args) throws Throwable {
        init();
        String result = transform(new File(args[0]), new File(args[1]));
        System.out.println(result);
    }

    public static void init() {
        if (factory == null){
            factory = new net.sf.saxon.TransformerFactoryImpl();
            errorListener = new Listener(errorMessages);
            factory.setErrorListener(errorListener);
        }
    }

    public static String transform(String xml, String xsl){
        String xmlString = stripNonBreakingWhitespaces(xml);
        String xslString = stripNonBreakingWhitespaces(xsl);
        return transform(new StreamSource(new StringReader(xmlString)),
                new StreamSource(new StringReader(xslString)));
    }

    public static String transform(URI xml, URI xsl){
        return transform(new File(xml), new File(xsl));
    }

    public static String transform(URL xml, URL xsl){
        try {
            return transform(xml.toURI(), xsl.toURI());
        } catch (Throwable t){
            throw new RuntimeException(t);
        }
    }

    public static String transform(File xml, File xsl){
        return transform(FileSlurper.read(xml), FileSlurper.read(xsl));
    }

    private static String stripNonBreakingWhitespaces(String input){
        return input.replaceAll(NONBREAKING_WHITESPACE, NORMAL_WHITESPACE);
    }

    private static String transform(StreamSource xml, StreamSource xsl){
        init();
        String result = "";
        try {
            // do transform
            StringWriter writer = new StringWriter();
            Transformer transformer = factory.newTransformer(xsl);
            transformer.transform(xml, new javax.xml.transform.stream.StreamResult(writer));
            result = writer.toString();
        } catch (Exception e) {
            // handle errors gracefully
            errorMessages.append("TRANSFORM_ERROR: " + e.getMessage() + "\n");
        }
        return result;
    }

    public static String getErrorMessages() {
        String tmp = errorMessages.toString();
        errorMessages = new StringBuffer();
        return tmp;
    }

    public static class Listener implements ErrorListener {

        private StringBuffer messages;

        Listener(StringBuffer messages) {
            this.messages = messages;
        }

        public void warning(TransformerException exception) throws TransformerException {
            messages.append("WARN: " + exception.getMessageAndLocation() + "\n");
        }

        public void error(TransformerException exception) throws TransformerException {
            messages.append("ERROR: " + exception.getMessageAndLocation() + "\n");
        }

        public void fatalError(TransformerException exception) throws TransformerException {
            messages.append("FATAL: " + exception.getMessageAndLocation() + "\n");
        }

    }
}
