import logging.JsLogger;
import netscape.javascript.JSObject;

import javax.xml.transform.ErrorListener;
import java.applet.Applet;
import java.io.PrintWriter;
import java.io.StringWriter;

public class XsltApplet extends Applet {

    static JSObject window;

    @Override
    public void init() {
        window = JSObject.getWindow(this);
        Xslt2.init(new JsLogger(window, "log"));
        window.eval("version(" + version() + ")");
        System.out.println("XsltApplet-" + version() + " started.");
    }

    public String transform(String xml, String xsl){
        try {
            return Xslt2.transform(xml, xsl);
        } catch (Throwable t){
            StringWriter sw = new StringWriter();
            PrintWriter pw = new PrintWriter(sw);
            t.printStackTrace(pw);
            return sw.toString();
        }
    }

    public String version() {
        return "1.1";
    }

}
