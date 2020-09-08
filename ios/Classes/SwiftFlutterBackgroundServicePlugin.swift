import Flutter
import UIKit

public class SwiftFlutterBackgroundServicePlugin: NSObject, FlutterPlugin {
    var backgroundEngine: FlutterEngine? = nil
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "id.flutter/background_service", binaryMessenger: registrar.messenger())
        let instance = SwiftFlutterBackgroundServicePlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
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
        }
    }
}
