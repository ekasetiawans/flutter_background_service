package id.flutter.flutter_background_service;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;

import androidx.core.content.ContextCompat;

public class WatchdogReceiver extends BroadcastReceiver {
    @Override
    public void onReceive(Context context, Intent intent) {
        if(!BackgroundService.isManuallyStopped(context)) {
            if (BackgroundService.isForegroundService(context)) {
                ContextCompat.startForegroundService(context, new Intent(context, BackgroundService.class));
            } else {
                context.startService(new Intent(context, BackgroundService.class));
            }
        }
    }
}
