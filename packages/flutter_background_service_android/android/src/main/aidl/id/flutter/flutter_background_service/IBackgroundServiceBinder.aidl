// IBackgroundServiceBinder.aidl
package id.flutter.flutter_background_service;

import id.flutter.flutter_background_service.IBackgroundService;
// Declare any non-default types here with import statements

interface IBackgroundServiceBinder {
    void bind(int id, IBackgroundService service);
    void unbind(int id);
    void invoke(String data);
}