package id.flutter.flutter_background_service;

import android.app.AlarmManager;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.app.Service;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.os.Build;
import android.os.IBinder;
import android.util.Log;

import androidx.core.app.AlarmManagerCompat;
import androidx.core.app.NotificationCompat;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;
import java.util.concurrent.atomic.AtomicBoolean;

import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.embedding.engine.FlutterJNI;
import io.flutter.embedding.engine.dart.DartExecutor;
import io.flutter.view.FlutterCallbackInformation;
import io.flutter.view.FlutterMain;

public class BackgroundService extends Service {
    private static final String TAG = "BackgroundService";

    @Override
    public IBinder onBind(Intent intent) {
        return null;
    }

    public static void enqueue(Context context){
        Intent intent = new Intent(context, WatchdogReceiver.class);
        AlarmManager manager = (AlarmManager) context.getSystemService(Context.ALARM_SERVICE);

        PendingIntent pIntent = PendingIntent.getBroadcast(context, 111, intent, PendingIntent.FLAG_UPDATE_CURRENT);
        AlarmManagerCompat.setAndAllowWhileIdle(manager, AlarmManager.RTC_WAKEUP, System.currentTimeMillis() + 5000, pIntent);
    }

    public static void setCallbackDispatcher(Context context, long callbackHandleId){
        SharedPreferences pref = context.getSharedPreferences("id.flutter.background_service", MODE_PRIVATE);
        pref.edit().putLong("callback_handle", callbackHandleId).apply();
    }

    @Override
    public void onCreate() {
        super.onCreate();
        createNotificationChannel();
    }

    private void createNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            CharSequence name = "Background Service";
            String description = "Executing process in background";

            int importance = NotificationManager.IMPORTANCE_LOW;
            NotificationChannel channel = new NotificationChannel("DEFAULT", name, importance);
            channel.setDescription(description);
            channel.setShowBadge(false);
            NotificationManager notificationManager = getSystemService(NotificationManager.class);
            notificationManager.createNotificationChannel(channel);
        }
    }

    protected void setForegroundText(String content) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            Intent intent = new Intent();
            intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
            intent.setPackage(getApplicationContext().getPackageName());

            PendingIntent pendingIntent = PendingIntent.getActivity(this, 999, intent, PendingIntent.FLAG_UPDATE_CURRENT);
            NotificationCompat.Builder mBuilder = new NotificationCompat.Builder(this, "DEFAULT");
            mBuilder.setContentTitle("Service");
            mBuilder.setContentText(content);
            mBuilder.setAutoCancel(true);
            mBuilder.setContentIntent(pendingIntent);
            mBuilder.setSmallIcon(R.mipmap.ic_launcher);
            mBuilder.setPriority(NotificationManager.IMPORTANCE_LOW);

            startForeground(1, mBuilder.build());
        }
    }

    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        enqueue(this);
        runService();

        return START_STICKY;
    }

    AtomicBoolean isRunning = new AtomicBoolean(false);
    private void runService(){
        if (isRunning.get()) return;

        final SimpleDateFormat sdf = new SimpleDateFormat("HH:mm:ss", Locale.getDefault());
        setForegroundText("Running since " + sdf.format(new Date()));

        SharedPreferences pref = getSharedPreferences("id.flutter.background_service", MODE_PRIVATE);
        long callbackHandle = pref.getLong("callback_handle", 0);

        FlutterCallbackInformation callback =  FlutterCallbackInformation.lookupCallbackInformation(callbackHandle);
        if (callback == null){
            Log.e(TAG, "callback handle not found");
            return;
        }

        isRunning.set(true);
        FlutterEngine backgroundEngine = new FlutterEngine(this);
        DartExecutor.DartCallback dartCallback = new DartExecutor.DartCallback(getAssets(), FlutterMain.findAppBundlePath(), callback);
        backgroundEngine.getDartExecutor().executeDartCallback(dartCallback);
    }
}
