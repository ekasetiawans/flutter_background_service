import Flutter
import UIKit
import AVKit

public class SwiftFlutterBackgroundServicePlugin: FlutterPluginAppLifeCycleDelegate, FlutterPlugin  {
    
    var backgroundEngine: FlutterEngine? = nil
    var mainChannel: FlutterMethodChannel? = nil
    var backgroundChannel: FlutterMethodChannel? = nil
    
    public override func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) -> Bool {
        
        // execute callback handle
        self.beginFetch(isForeground: false)
        completionHandler(.newData)
        return true
    }
        
    public override func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [AnyHashable : Any] = [:]) -> Bool {
        UIApplication.shared.setMinimumBackgroundFetchInterval(UIApplication.backgroundFetchIntervalMinimum)
        return true
    }
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "id.flutter/background_service", binaryMessenger: registrar.messenger(), codec: FlutterJSONMethodCodec())
        
        let instance = SwiftFlutterBackgroundServicePlugin()
        instance.mainChannel = channel
        
        registrar.addMethodCallDelegate(instance, channel: instance.mainChannel!)
        registrar.addApplicationDelegate(instance)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if (call.method == "configure"){
            let args = call.arguments as? Dictionary<String, Any>
            let foregroundCallbackHandleID = args?["foreground_handle"] as? NSNumber
            let backgroundCallbackHandleID = args?["background_handle"] as? NSNumber
            
            let defaults = UserDefaults.standard
            defaults.set(foregroundCallbackHandleID?.int64Value, forKey: "foreground_callback_handle")
            defaults.set(backgroundCallbackHandleID?.int64Value, forKey: "background_callback_handle")
            
            result(true)
            return
        }
        
        if (call.method == "start") {
            self.beginFetch(isForeground: true)
            result(true)
        }
        
        if (call.method == "sendData"){
            if (self.backgroundChannel != nil){
                self.backgroundChannel?.invokeMethod("onReceiveData", arguments: call.arguments)
            }
            
            result(true);
        }
                
        if (call.method == "isServiceRunning"){
            let value = self.backgroundEngine != nil;
            result(value);
            return;
        }
    }
    
    // isForeground will be false if this method is executed by background fetch.
    private func beginFetch(isForeground: Bool){
        if (isForeground && self.backgroundEngine != nil){
            return
        }
        
        let defaults = UserDefaults.standard
        let callbackHandle = isForeground ? defaults.object(forKey: "foreground_callback_handle") : defaults.object(forKey: "background_callback_handle")
        
        if let callbackHandleID = callbackHandle as? Int64 {
            let callbackHandle = FlutterCallbackCache.lookupCallbackInformation(callbackHandleID)
            
            let callbackName = callbackHandle?.callbackName
            let uri = callbackHandle?.callbackLibraryPath
            
            let backgroundEngine = FlutterEngine(name: "FlutterService", project: nil, allowHeadlessExecution: true)
            let isRunning = backgroundEngine.run(withEntrypoint: callbackName, libraryURI: uri)
            if (isRunning){
                let binaryMessenger = backgroundEngine.binaryMessenger
                let backgroundChannel = FlutterMethodChannel(name: "id.flutter/background_service_bg", binaryMessenger: binaryMessenger, codec: FlutterJSONMethodCodec())
                
                backgroundChannel.setMethodCallHandler({
                    (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
                    if (call.method == "sendData"){
                        if (self.mainChannel != nil){
                            self.mainChannel?.invokeMethod("onReceiveData", arguments: call.arguments)
                        }
                        
                        result(true);
                        return;
                    }
                    
                    if (call.method == "setForegroundMode"){
                        result(true);
                        return;
                    }
                    
                    if (call.method == "setNotificationInfo"){
                        result(true);
                        return;
                    }
                    
                    if (call.method == "stopService"){
                        self.backgroundEngine?.destroyContext();
                        self.backgroundEngine = nil;
                        result(true);
                        return;
                    }
                })
                
                if (isForeground){
                    self.backgroundEngine = backgroundEngine
                    self.backgroundChannel = backgroundChannel
                }
            }
        }
    }
}
