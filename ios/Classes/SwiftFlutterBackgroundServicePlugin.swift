import Flutter
import UIKit
import AVKit

public class SwiftFlutterBackgroundServicePlugin: FlutterPluginAppLifeCycleDelegate, FlutterPlugin  {
    
    private static var flutterPluginRegistrantCallback: FlutterPluginRegistrantCallback?
    
    var backgroundEngine: FlutterEngine? = nil
    var mainChannel: FlutterMethodChannel? = nil
    var backgroundChannel: FlutterMethodChannel? = nil
    
    public override func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) -> Bool {
        return true
    }
    
    public override func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [AnyHashable : Any] = [:]) -> Bool {
        return true
    }
    
    public override func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [AnyHashable : Any] = [:]) -> Bool {
        return true
    }
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "id.flutter/background_service", binaryMessenger: registrar.messenger(), codec: FlutterJSONMethodCodec())
        
        let instance = SwiftFlutterBackgroundServicePlugin()
        instance.mainChannel = channel
        
        registrar.addMethodCallDelegate(instance, channel: instance.mainChannel!)
        registrar.addApplicationDelegate(instance)
    }
    
    public static func setPluginRegistrantCallback(_ callback: @escaping FlutterPluginRegistrantCallback) {
        flutterPluginRegistrantCallback = callback
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if (call.method == "BackgroundService.start"){
            let callbackHandleID = call.arguments as? NSNumber
            
            let defaults = UserDefaults.standard
            defaults.set(callbackHandleID?.int64Value, forKey: "callback_handle")
            
            self.beginFetch()
            result(true)
            return
        }
        
        if (call.method == "sendData"){
            if (self.backgroundChannel != nil){
                self.backgroundChannel?.invokeMethod("onReceiveData", arguments: call.arguments)
            }
            
            result(true);
        }
    }
    
    public func beginFetch(){
        if (self.backgroundEngine != nil){
            return
        }
        
        let defaults = UserDefaults.standard
        if let callbackHandleID = defaults.object(forKey: "callback_handle") as? Int64 {
            let callbackHandle = FlutterCallbackCache.lookupCallbackInformation(callbackHandleID)
            
            let callbackName = callbackHandle?.callbackName
            let uri = callbackHandle?.callbackLibraryPath
            
            self.backgroundEngine = FlutterEngine(name: "FlutterService", project: nil, allowHeadlessExecution: true)
            self.backgroundEngine?.run(withEntrypoint: callbackName, libraryURI: uri)
            SwiftFlutterBackgroundServicePlugin.flutterPluginRegistrantCallback?(self.backgroundEngine!)
            
            let binaryMessenger = self.backgroundEngine?.binaryMessenger
            self.backgroundChannel = FlutterMethodChannel(name: "id.flutter/background_service_bg", binaryMessenger: binaryMessenger!, codec: FlutterJSONMethodCodec())
            
            self.backgroundChannel!.setMethodCallHandler({
                (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
                if (call.method == "sendData"){
                    if (self.mainChannel != nil){
                        self.mainChannel?.invokeMethod("onReceiveData", arguments: call.arguments)
                    }
                    
                    result(true);
                    return;
                }
                
                if (call.method == "setNotificationInfo"){
                    result(true);
                    return;
                }
            })
            
            
        }
    }
}
