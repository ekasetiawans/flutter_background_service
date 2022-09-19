package id.flutter.flutter_background_service;

import android.content.Context;
import android.content.SharedPreferences;

public class Config {
    final SharedPreferences pref;

    public Config(Context context) {
        this.pref = context.getSharedPreferences("id.flutter.background_service", Context.MODE_PRIVATE);
    }

    public boolean isAutoStartOnBoot() {
        return pref.getBoolean("auto_start_on_boot", true);
    }

    public void setAutoStartOnBoot(boolean value) {
        pref.edit()
                .putBoolean("auto_start_on_boot", value)
                .apply();
    }

    public boolean isForeground() {
        return pref.getBoolean("is_foreground", true);
    }

    public void setIsForeground(boolean value) {
        pref.edit()
                .putBoolean("is_foreground", value)
                .apply();
    }

    public boolean isManuallyStopped() {
        return pref.getBoolean("is_manually_stopped", false);
    }

    public void setManuallyStopped(boolean value) {
        pref.edit().putBoolean("is_manually_stopped", value).apply();
    }

    public long getBackgroundHandle() {
        return pref.getLong("background_handle", 0);
    }

    public void setBackgroundHandle(long value) {
        pref.edit().putLong("background_handle", value).apply();
    }

    public String getInitialNotificationTitle() {
        return pref.getString("initial_notification_title", "Background Service");
    }

    public void setInitialNotificationTitle(String value) {
        pref.edit().putString("initial_notification_title", value).apply();
    }

    public String getInitialNotificationContent() {
        return pref.getString("initial_notification_content", "Preparing");
    }

    public void setInitialNotificationContent(String value) {
        pref.edit().putString("initial_notification_content", value).apply();
    }

    public String getNotificationChannelId() {
        return pref.getString("notification_channel_id", null);
    }

    public void setNotificationChannelId(String value) {
        pref.edit().putString("notification_channel_id", value).apply();
    }

    public int getForegroundNotificationId() {
        return pref.getInt("foreground_notification_id", 112233);
    }

    public void setForegroundNotificationId(int value) {
        pref.edit().putInt("foreground_notification_id", value).apply();
    }
}
