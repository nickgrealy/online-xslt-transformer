import javax.xml.transform.ErrorListener;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.stream.StreamSource;
import java.applet.Applet;
import java.io.File;
import java.io.StringReader;
import java.io.StringWriter;

public class XsltApplet extends Applet {

    @Override
    public void init() {
        Xslt2.init();
    }

    public String transform(String xml, String xsl){
        return Xslt2.transform(xml, xsl);
    }

    public String getErrorMessages() {
        return Xslt2.getErrorMessages();
    }

    public String version() {
        return "1.0";
    }

}
