package logging;

import javax.xml.transform.TransformerException;
import java.text.SimpleDateFormat;
import java.util.Date;

public class SystemLogger implements Logger {

    protected boolean showDate = true;
    protected SimpleDateFormat format = new SimpleDateFormat("HH:mm:ss");

    public SystemLogger() {
        this.showDate = true;
    }

    public SystemLogger(boolean showDate) {
        this.showDate = showDate;
    }

    public void warning(TransformerException exception) throws TransformerException {
        log(Level.WARN, exception.getMessageAndLocation());
    }

    public void error(TransformerException exception) throws TransformerException {
        log(Level.ERROR, exception.getMessageAndLocation());
    }

    public void fatalError(TransformerException exception) throws TransformerException {
        log(Level.FATAL, exception.getMessageAndLocation());
    }

    public String log(Level level, String param){
        String tmp = showDate ? String.format("%s - %s - %s", format.format(new Date()), level, param)
                : String.format("%s - %s", level, param);
        System.out.println(tmp);
        return tmp;
    }

}
