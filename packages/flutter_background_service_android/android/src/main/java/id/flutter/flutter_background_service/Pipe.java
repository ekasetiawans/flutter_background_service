package id.flutter.flutter_background_service;

import org.json.JSONObject;

import java.util.ArrayList;
import java.util.List;

public class Pipe {
    public interface  PipeListener {
        public void onReceived(JSONObject object);
    }

    private final List<PipeListener> listeners = new ArrayList<>();
    public boolean hasListener() {
        return !listeners.isEmpty();
    }

    public void addListener(PipeListener listener){
        synchronized (this){
            this.listeners.add(listener);
        }
    }

    public void removeListener(PipeListener listener){
        synchronized (this){
            this.listeners.remove(listener);
        }
    }

    public void invoke(JSONObject object){
        synchronized (this) {
            if (!listeners.isEmpty()) {
                for (PipeListener listener :
                        this.listeners) {
                    listener.onReceived(object);
                }
            }
        }
    }
}
