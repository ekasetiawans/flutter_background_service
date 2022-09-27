package id.flutter.flutter_background_service;

import static android.content.Context.ALARM_SERVICE;
import static android.os.Build.VERSION.SDK_INT;

import android.app.AlarmManager;
import android.app.PendingIntent;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.os.Build;

import androidx.core.app.AlarmManagerCompat;
import androidx.core.content.ContextCompat;

public class WatchdogReceiver extends BroadcastReceiver {
    private static final int QUEUE_REQUEST_ID = 111;
    private static final String ACTION_RESPAWN = "id.flutter.background_service.RESPAWN";

    public static void enqueue(Context context) {
        enqueue(context, 5000);
    }

    public static void enqueue(Context context, int millis) {
        Intent intent = new Intent(context, WatchdogReceiver.class);
        intent.setAction(ACTION_RESPAWN);
        AlarmManager manager = (AlarmManager) context.getSystemService(ALARM_SERVICE);

        int flags = PendingIntent.FLAG_UPDATE_CURRENT;
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            flags |= PendingIntent.FLAG_MUTABLE;
        }

        PendingIntent pIntent = PendingIntent.getBroadcast(context, QUEUE_REQUEST_ID, intent, flags);

        // Check is background service every 5 seconds
        AlarmManagerCompat.setExact(manager, AlarmManager.RTC_WAKEUP, System.currentTimeMillis() + millis, pIntent);
    }

    public static void remove(Context context) {
        Intent intent = new Intent(context, WatchdogReceiver.class);
        intent.setAction(ACTION_RESPAWN);

        int flags = PendingIntent.FLAG_CANCEL_CURRENT;
        if (SDK_INT >= Build.VERSION_CODES.S) {
            flags |= PendingIntent.FLAG_MUTABLE;
        }

        PendingIntent pi = PendingIntent.getBroadcast(context, WatchdogReceiver.QUEUE_REQUEST_ID, intent, flags);
        AlarmManager alarmManager = (AlarmManager) context.getSystemService(ALARM_SERVICE);
        alarmManager.cancel(pi);
    }

    @Override
    public void onReceive(Context context, Intent intent) {
        if (intent.getAction().equals(ACTION_RESPAWN)){
            final Config config = new Config(context);
            if (!config.isManuallyStopped()) {
                if (config.isForeground()) {
                    ContextCompat.startForegroundService(context, new Intent(context, BackgroundService.class));
                } else {
                    context.startService(new Intent(context, BackgroundService.class));
                }
            }
        }
    }
}
