package id.flutter.flutter_background_service;

import static android.content.Context.MODE_PRIVATE;

import android.app.ActivityManager;
import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.content.ServiceConnection;
import android.content.SharedPreferences;
import android.os.Handler;
import android.os.IBinder;
import android.os.RemoteException;
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

/** FlutterBackgroundServicePlugin */
public class FlutterBackgroundServicePlugin implements FlutterPlugin, MethodCallHandler, ServiceAware {
  private static final String TAG = "BackgroundServicePlugin";
  private Handler mainHandler;
  public FlutterBackgroundServicePlugin() {

  }

  private MethodChannel channel;
  private Context context;

  private IBackgroundServiceBinder serviceBinder;
  private final int binderId = (int) (System.currentTimeMillis()/1000);
  private final ServiceConnection serviceConnection = new ServiceConnection() {
    @Override
    public void onServiceConnected(ComponentName name, IBinder service) {
      serviceBinder = IBackgroundServiceBinder.Stub.asInterface(service);

      try {
        IBackgroundService listener = new IBackgroundService.Stub() {
          @Override
          public void invoke(String data) throws RemoteException {
            try {
              JSONObject call = new JSONObject(data);
              receiveData(call);
            }catch (Exception e){
              e.printStackTrace();
            }
          }

          @Override
          public void stop() throws  RemoteException {
            if (context != null && serviceBinder != null){
              context.unbindService(serviceConnection);
            }
          }
        };

        serviceBinder.bind(binderId, listener);
      }catch (Exception e){
        e.printStackTrace();
      }
    }

    @Override
    public void onServiceDisconnected(ComponentName name) {
      try {
        serviceBinder.unbind(binderId);
        serviceBinder = null;
      }catch (Exception e){
        e.printStackTrace();
      }
    }
  };

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    this.context = flutterPluginBinding.getApplicationContext();
    mainHandler = new Handler(context.getMainLooper());

    channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "id.flutter/background_service_android", JSONMethodCodec.INSTANCE);
    channel.setMethodCallHandler(this);
  }

  @SuppressWarnings("deprecation")
  public static void registerWith(Registrar registrar) {
    final FlutterBackgroundServicePlugin plugin = new FlutterBackgroundServicePlugin();
    final MethodChannel channel = new MethodChannel(registrar.messenger(), "id.flutter/background_service_android", JSONMethodCodec.INSTANCE);
    channel.setMethodCallHandler(plugin);
    plugin.channel = channel;
  }

  private static void configure(Context context, long backgroundHandle, boolean isForeground, boolean autoStartOnBoot, String initialNotificationContent, String initialNotificationTitle, String notificationChannelId, int foregroundNotificationId) {
    SharedPreferences pref = context.getSharedPreferences("id.flutter.background_service", MODE_PRIVATE);
    pref.edit()
            .putLong("background_handle", backgroundHandle)
            .putBoolean("is_foreground", isForeground)
            .putBoolean("auto_start_on_boot", autoStartOnBoot)
            .putString("initial_notification_content", initialNotificationContent)
            .putString("initial_notification_title", initialNotificationTitle)
            .putString("notification_channel_id", notificationChannelId)
            .putInt("foreground_notification_id", foregroundNotificationId)
            .apply();
  }

  private void start() {
    BackgroundService.enqueue(context);
    boolean isForeground = BackgroundService.isForegroundService(context);
    Intent intent = new Intent(context, BackgroundService.class);
    intent.putExtra("binder_id", binderId);

    if (isForeground) {
      ContextCompat.startForegroundService(context, intent);
    } else {
      context.startService(intent);
    }

    context.bindService(intent, serviceConnection, Context.BIND_AUTO_CREATE);
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
        String initialNotificationTitle = arg.getString("initial_notification_title");
        String initialNotificationContent = arg.getString("initial_notification_content");
        String notificationChannelId = arg.isNull("notification_channel_id") ? null : arg.getString("notification_channel_id");
        int foregroundNotificationId = arg.getInt("foreground_notification_id");

        configure(context, backgroundHandle, isForeground, autoStartOnBoot, initialNotificationContent, initialNotificationTitle, notificationChannelId, foregroundNotificationId);
        if (autoStartOnBoot) {
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
      result.error("100", "Failed read arguments", null);
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

    if (serviceBinder != null){
      binding.getApplicationContext().unbindService(serviceConnection);
    }
  }

  private void receiveData(JSONObject data){
    final JSONObject arg = data;
    mainHandler.post(new Runnable() {
      @Override
      public void run() {
        if (channel != null){
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
