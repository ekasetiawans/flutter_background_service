package id.flutter.flutter_background_service;

import android.app.Service;
import android.content.pm.ServiceInfo;
import java.util.HashMap;
import java.util.Map;

public class ForegroundTypeMapper {

    private static final Map<String, Integer> foregroundTypeMap = new HashMap<>();

    static {
        foregroundTypeMap.put("camera", ServiceInfo.FOREGROUND_SERVICE_TYPE_CAMERA);
        foregroundTypeMap.put("connectedDevice", ServiceInfo.FOREGROUND_SERVICE_TYPE_CONNECTED_DEVICE);
        foregroundTypeMap.put("dataSync", ServiceInfo.FOREGROUND_SERVICE_TYPE_DATA_SYNC);
        foregroundTypeMap.put("health", ServiceInfo.FOREGROUND_SERVICE_TYPE_HEALTH);
        foregroundTypeMap.put("location", ServiceInfo.FOREGROUND_SERVICE_TYPE_LOCATION);
        foregroundTypeMap.put("mediaPlayback", ServiceInfo.FOREGROUND_SERVICE_TYPE_MEDIA_PLAYBACK);
        foregroundTypeMap.put("mediaProjection", ServiceInfo.FOREGROUND_SERVICE_TYPE_MEDIA_PROJECTION);
        foregroundTypeMap.put("microphone", ServiceInfo.FOREGROUND_SERVICE_TYPE_MICROPHONE);
        foregroundTypeMap.put("phoneCall", ServiceInfo.FOREGROUND_SERVICE_TYPE_PHONE_CALL);
        foregroundTypeMap.put("remoteMessaging", ServiceInfo.FOREGROUND_SERVICE_TYPE_REMOTE_MESSAGING);
        foregroundTypeMap.put("shortService", ServiceInfo.FOREGROUND_SERVICE_TYPE_SHORT_SERVICE);
        foregroundTypeMap.put("specialUse", ServiceInfo.FOREGROUND_SERVICE_TYPE_SPECIAL_USE);
        foregroundTypeMap.put("systemExempted", ServiceInfo.FOREGROUND_SERVICE_TYPE_SYSTEM_EXEMPTED);
    }

    public static Integer getForegroundServiceType(String[] foregroundTypes) {
        Integer foregroundServiceType = ServiceInfo.FOREGROUND_SERVICE_TYPE_MANIFEST;
        if (foregroundTypes != null && foregroundTypes.length > 0) {
            foregroundServiceType = 0;
            for (String foregroundType : foregroundTypes) {
                foregroundServiceType |= foregroundTypeMap.get(foregroundType);
            }
        }
        return foregroundServiceType;
    }
}