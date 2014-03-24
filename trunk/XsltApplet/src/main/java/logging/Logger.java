package logging;

import javax.xml.transform.ErrorListener;

public interface Logger extends ErrorListener {

    public enum Level { WARN, ERROR, INFO, DEBUG, FATAL };

    public String log(Level level, String message);
}
