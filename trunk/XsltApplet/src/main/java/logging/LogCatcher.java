package logging;

public class LogCatcher extends SystemLogger {

    private StringBuffer messages;

    public LogCatcher(StringBuffer messages) {
        super(false);
        this.messages = messages;
    }

    public String log(Level level, String message) {
        String tmp = super.log(level, message);
        messages.append(tmp + "\n");
        return tmp;
    }
}
