package id.flutter.flutter_background_service;

import android.app.ActivityManager;
import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.content.ServiceConnection;
import android.os.Handler;
import android.os.IBinder;
import android.util.Log;

import androidx.annotation.NonNull;
import androidx.core.content.ContextCompat;

import org.json.JSONObject;
import org.json.JSONArray;

import java.util.HashMap;
import java.util.Map;

import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.service.ServiceAware;
import io.flutter.embedding.engine.plugins.service.ServicePluginBinding;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.JSONMethodCodec;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/**
 * FlutterBackgroundServicePlugin
 */
public class FlutterBackgroundServicePlugin implements FlutterPlugin, MethodCallHandler, EventChannel.StreamHandler {
    private static final String TAG = "BackgroundServicePlugin";
    private Handler mainHandler;
    private Config config;
    private MethodChannel channel;
    private EventChannel eventChannel;
    private final Map<Object, EventChannel.EventSink> eventSinks = new HashMap<>();

    private Context context;

    public static final Pipe servicePipe = new Pipe();
    public static final Pipe mainPipe = new Pipe();

    public static void registerWith(FlutterEngine engine){
        Log.d(TAG, "registering with FlutterEngine");
    }

    private final Pipe.PipeListener listener = new Pipe.PipeListener() {
        @Override
        public void onReceived(JSONObject object) {
            receiveData(object);
        }
    };


    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        this.context = flutterPluginBinding.getApplicationContext();
        this.config = new Config(this.context);

        mainHandler = new Handler(context.getMainLooper());

        channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "id.flutter/background_service/android/method", JSONMethodCodec.INSTANCE);
        channel.setMethodCallHandler(this);

        eventChannel = new EventChannel(flutterPluginBinding.getBinaryMessenger(), "id.flutter/background_service/android/event", JSONMethodCodec.INSTANCE);
        eventChannel.setStreamHandler(this);

        mainPipe.addListener(listener);
    }

    private void start() {
        WatchdogReceiver.enqueue(context);
        boolean isForeground = config.isForeground();
        Intent intent = new Intent(context, BackgroundService.class);

        if (isForeground) {
            ContextCompat.startForegroundService(context, intent);
        } else {
            context.startService(intent);
        }
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
        String method = call.method;
        JSONObject arg = (JSONObject) call.arguments;

        try {
            if ("configure".equals(method)) {
                long backgroundHandle = arg.getLong("background_handle");
                boolean isForeground = arg.getBoolean("is_foreground_mode");
                boolean autoStartOnBoot = arg.getBoolean("auto_start_on_boot");
                boolean autoStart = arg.getBoolean("auto_start");
                String initialNotificationTitle = arg.isNull("initial_notification_title") ? null : arg.getString("initial_notification_title");
                String initialNotificationContent = arg.isNull("initial_notification_content") ? null : arg.getString("initial_notification_content");
                String notificationChannelId = arg.isNull("notification_channel_id") ? null : arg.getString("notification_channel_id");
                int foregroundNotificationId = arg.isNull("foreground_notification_id") ? null : arg.getInt("foreground_notification_id");
                JSONArray foregroundServiceTypes = arg.isNull("foreground_service_types") ? null : arg.getJSONArray("foreground_service_types");
                String foregroundServiceTypesStr = null;
                if (foregroundServiceTypes != null) {
                    StringBuilder resultForegroundServiceType = new StringBuilder();
                    for (int i = 0; i < foregroundServiceTypes.length(); i++) {
                        resultForegroundServiceType.append(foregroundServiceTypes.getString(i));
                        if (i < foregroundServiceTypes.length() - 1) {
                            resultForegroundServiceType.append(",");
                        }
                    }
                    foregroundServiceTypesStr = resultForegroundServiceType.toString();
                }

                config.setBackgroundHandle(backgroundHandle);
                config.setIsForeground(isForeground);
                config.setAutoStartOnBoot(autoStartOnBoot);
                config.setInitialNotificationTitle(initialNotificationTitle);
                config.setInitialNotificationContent(initialNotificationContent);
                config.setNotificationChannelId(notificationChannelId);
                config.setForegroundNotificationId(foregroundNotificationId);
                config.setForegroundServiceTypes(foregroundServiceTypesStr);

                if (autoStart) {
                    start();
                }

                result.success(true);
                return;
            }

            if ("start".equals(method)) {
                start();
                result.success(true);
                return;
            }

            if (method.equalsIgnoreCase("sendData")) {
                synchronized (servicePipe){
                    if (servicePipe.hasListener()){
                        servicePipe.invoke((JSONObject) call.arguments);
                        result.success(true);
                        return;
                    }

                    result.success(false);
                }
                return;
            }

            if (method.equalsIgnoreCase("isServiceRunning")) {
                result.success(isServiceRunning());
                return;
            }

            result.notImplemented();
        } catch (Exception e) {
            result.error("100", "Failed while read arguments", e.getMessage());
        }
    }

    private boolean isServiceRunning() {
        ActivityManager manager = (ActivityManager) context.getSystemService(Context.ACTIVITY_SERVICE);
        for (ActivityManager.RunningServiceInfo service : manager.getRunningServices(Integer.MAX_VALUE)) {
            if (BackgroundService.class.getName().equals(service.service.getClassName())) {
                return true;
            }
        }
        return false;
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        mainPipe.removeListener(listener);

        channel.setMethodCallHandler(null);
        channel = null;

        synchronized (eventSinks){
            eventSinks.clear();
        }
        eventChannel.setStreamHandler(null);
        eventChannel = null;
    }

    private void receiveData(JSONObject data) {
        final JSONObject arg = data;
        synchronized (this){
            for (EventChannel.EventSink sink :
                    eventSinks.values()) {
                mainHandler.post(new Runnable() {
                    @Override
                    public void run() {
                        sink.success(arg);
                    }
                });
            }
        }
    }

    @Override
    public void onListen(Object arguments, EventChannel.EventSink events) {
        synchronized (this){
            eventSinks.put(arguments, events);
        }
    }

    @Override
    public void onCancel(Object arguments) {
        synchronized (this){
            eventSinks.remove(arguments);
        }
    }
}
