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

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.service.ServiceAware;
import io.flutter.embedding.engine.plugins.service.ServicePluginBinding;
import io.flutter.plugin.common.JSONMethodCodec;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/**
 * FlutterBackgroundServicePlugin
 */
public class FlutterBackgroundServicePlugin implements FlutterPlugin, MethodCallHandler, ServiceAware {
    private static final String TAG = "BackgroundServicePlugin";
    private final int binderId = (int) (System.currentTimeMillis() / 1000);
    private Handler mainHandler;
    private Config config;
    private MethodChannel channel;
    private Context context;
    private IBackgroundServiceBinder serviceBinder;
    private boolean mShouldUnbind = false;

    @SuppressWarnings("deprecation")
    public static void registerWith(Registrar registrar) {
        final FlutterBackgroundServicePlugin plugin = new FlutterBackgroundServicePlugin();
        final MethodChannel channel = new MethodChannel(registrar.messenger(), "id.flutter/background_service_android", JSONMethodCodec.INSTANCE);
        channel.setMethodCallHandler(plugin);
        plugin.channel = channel;
    }

    private final ServiceConnection serviceConnection = new ServiceConnection() {
        @Override
        public void onServiceConnected(ComponentName name, IBinder service) {
            serviceBinder = IBackgroundServiceBinder.Stub.asInterface(service);

            try {
                IBackgroundService listener = new IBackgroundService.Stub() {
                    @Override
                    public void invoke(String data) {
                        try {
                            JSONObject call = new JSONObject(data);
                            receiveData(call);
                        } catch (Exception e) {
                            e.printStackTrace();
                        }
                    }

                    @Override
                    public void stop() {
                        if (context != null && serviceBinder != null) {
                            context.unbindService(serviceConnection);
                        }
                    }
                };

                serviceBinder.bind(binderId, listener);
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        @Override
        public void onServiceDisconnected(ComponentName name) {
            try {
                mShouldUnbind = false;
                serviceBinder.unbind(binderId);
                serviceBinder = null;
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    };

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        this.context = flutterPluginBinding.getApplicationContext();
        this.config = new Config(this.context);
        mShouldUnbind = false;

        mainHandler = new Handler(context.getMainLooper());

        channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "id.flutter/background_service_android", JSONMethodCodec.INSTANCE);
        channel.setMethodCallHandler(this);
    }

    private void start() {
        WatchdogReceiver.enqueue(context);
        boolean isForeground = config.isForeground();
        Intent intent = new Intent(context, BackgroundService.class);
        intent.putExtra("binder_id", binderId);

        if (isForeground) {
            ContextCompat.startForegroundService(context, intent);
        } else {
            context.startService(intent);
        }

        mShouldUnbind = context.bindService(intent, serviceConnection, Context.BIND_AUTO_CREATE);
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

                config.setBackgroundHandle(backgroundHandle);
                config.setIsForeground(isForeground);
                config.setAutoStartOnBoot(autoStartOnBoot);
                config.setInitialNotificationTitle(initialNotificationTitle);
                config.setInitialNotificationContent(initialNotificationContent);
                config.setNotificationChannelId(notificationChannelId);
                config.setForegroundNotificationId(foregroundNotificationId);

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
                if (serviceBinder != null) {
                    serviceBinder.invoke(call.arguments.toString());
                    result.success(true);
                    return;
                }

                result.success(false);
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
        channel.setMethodCallHandler(null);
        channel = null;

        if (mShouldUnbind && serviceBinder != null) {
            binding.getApplicationContext().unbindService(serviceConnection);
            mShouldUnbind = false;
        }
    }

    private void receiveData(JSONObject data) {
        final JSONObject arg = data;
        mainHandler.post(new Runnable() {
            @Override
            public void run() {
                if (channel != null) {
                    channel.invokeMethod("onReceiveData", arg);
                }
            }
        });
    }

    @Override
    public void onAttachedToService(@NonNull ServicePluginBinding binding) {
        Log.d(TAG, "onAttachedToService");
    }

    @Override
    public void onDetachedFromService() {
        Log.d(TAG, "onDetachedFromService");
    }


}
