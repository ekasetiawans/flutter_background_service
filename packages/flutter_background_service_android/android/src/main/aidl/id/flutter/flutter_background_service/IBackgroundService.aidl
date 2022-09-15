// IBackgroundService.aidl
package id.flutter.flutter_background_service;

// Declare any non-default types here with import statements

interface IBackgroundService {
    void invoke(String data);
    void stop();
}