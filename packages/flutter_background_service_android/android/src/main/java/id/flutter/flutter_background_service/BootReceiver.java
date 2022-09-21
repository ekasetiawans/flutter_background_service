package id.flutter.flutter_background_service;

import android.annotation.SuppressLint;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;

import androidx.core.content.ContextCompat;


public class BootReceiver extends BroadcastReceiver {
    @SuppressLint("WakelockTimeout")
    @Override
    public void onReceive(Context context, Intent intent) {
        if (intent.getAction().equals(Intent.ACTION_BOOT_COMPLETED) || intent.getAction().equals("android.intent.action.QUICKBOOT_POWERON")) {
            final Config config = new Config(context);
            boolean autoStart = config.isAutoStartOnBoot();
            if (autoStart) {
                if (BackgroundService.lockStatic == null) {
                    BackgroundService.getLock(context).acquire();
                }

                if (config.isForeground()) {
                    ContextCompat.startForegroundService(context, new Intent(context, BackgroundService.class));
                } else {
                    context.startService(new Intent(context, BackgroundService.class));
                }
            }
        }
    }
}
