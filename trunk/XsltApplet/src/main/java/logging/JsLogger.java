package logging;

import netscape.javascript.JSObject;

import java.util.Date;

public class JsLogger extends SystemLogger {

    private JSObject window; // = JSObject.getWindow(this);
    private String jsCallbackMethod = "alert('%s')";

    public JsLogger(JSObject window, String jsCallbackMethod) {
        this.jsCallbackMethod = jsCallbackMethod + "('%s')";
        this.window = window;
    }

    public String log(Level level, String param) {
        String tmp = super.log(level, param);
        tmp = parse(tmp);
        tmp = String.format(jsCallbackMethod, tmp);
        System.out.println(String.format("window.eval(%s)", tmp));
        if (window != null) {
            window.eval(tmp);
        }
        return tmp;
    }

    public static String parse(String message) {
        return message.replaceAll("&xa0;", "")
                .replaceAll("&#10;", "")
                .replaceAll("\n", "")
                .replaceAll("\r", "")
                .replaceAll("'", "\\\\'")
        ;
    }
}
