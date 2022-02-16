import Flutter
import UIKit
import AVKit
import BackgroundTasks

public class SwiftFlutterBackgroundServicePlugin: FlutterPluginAppLifeCycleDelegate, FlutterPlugin  {
    
    private static var flutterPluginRegistrantCallback: FlutterPluginRegistrantCallback?
    
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
        
        if #available(iOS 13.0, *) {
            registerBackgroundTasks()
        }
        return true
    }
    
    @available(iOS 13.0, *)
    func registerBackgroundTasks(){
        BGTaskScheduler.shared.register(forTaskWithIdentifier: "dev.flutter.background.refresh", using: nil) { task in
            self.handleAppRefresh(task: task as! BGAppRefreshTask)
        }
        
        scheduleAppRefresh()
    }
    
    @available(iOS 13.0, *)
    func scheduleAppRefresh() {
       let request = BGAppRefreshTaskRequest(identifier: "dev.flutter.background.refresh")
       request.earliestBeginDate = Date(timeIntervalSinceNow: 15 * 60)
            
       do {
          try BGTaskScheduler.shared.submit(request)
       } catch {
          print("Could not schedule app refresh: \(error)")
       }
    }
    
    @available(iOS 13.0, *)
    func handleAppRefresh(task: BGAppRefreshTask){
        scheduleAppRefresh()
        
        var engine: FlutterEngine? = nil
        let defaults = UserDefaults.standard
        let callbackHandle = defaults.object(forKey: "background_callback_handle")
        if callbackHandle == nil {
            task.setTaskCompleted(success: false)
            return
        }
        
        if let callbackHandleID = callbackHandle as? Int64 {
            let callbackHandleInfo = FlutterCallbackCache.lookupCallbackInformation(callbackHandleID)
            let callbackName = callbackHandleInfo?.callbackName
            let uri = callbackHandleInfo?.callbackLibraryPath
            
            let backgroundEngine = FlutterEngine(name: "FlutterBackgroundFetch")
            let isRunning = backgroundEngine.run(withEntrypoint: callbackName, libraryURI: uri)
            if (isRunning){
                
                let registrantCallback = SwiftFlutterBackgroundServicePlugin.flutterPluginRegistrantCallback
                registrantCallback?(backgroundEngine)
                
                let binaryMessenger = backgroundEngine.binaryMessenger
                let backgroundChannel = FlutterMethodChannel(name: "id.flutter/background_service_bg", binaryMessenger: binaryMessenger, codec: FlutterJSONMethodCodec())
                backgroundChannel.setMethodCallHandler(self.handleBackgroundMethodCall)
            }
            
            engine = backgroundEngine
            task.setTaskCompleted(success: isRunning)
        }
        
        task.expirationHandler = {
            engine?.destroyContext()
        }
    }
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(
            name: "id.flutter/background_service",
            binaryMessenger: registrar.messenger(),
            codec: FlutterJSONMethodCodec())
        
        let instance = SwiftFlutterBackgroundServicePlugin()
        instance.mainChannel = channel
        
        registrar.addMethodCallDelegate(instance, channel: channel)
        registrar.addApplicationDelegate(instance)
    }
    
    public static func setPluginRegistrantCallback(_ callback: @escaping FlutterPluginRegistrantCallback) {
        flutterPluginRegistrantCallback = callback
    }
    
    private func autoStart(isForeground: Bool) {
        let defaults = UserDefaults.standard
        let autoStart = defaults.bool(forKey: "auto_start")
        if (autoStart){
            self.beginFetch(isForeground: isForeground)
        }
    }
    
    private func handleBackgroundMethodCall(_ call: FlutterMethodCall, result: @escaping FlutterResult){
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
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if (call.method == "configure"){
            let args = call.arguments as? Dictionary<String, Any>
            let foregroundCallbackHandleID = args?["foreground_handle"] as? NSNumber
            let backgroundCallbackHandleID = args?["background_handle"] as? NSNumber
            let autoStart = args?["auto_start"] as? Bool
            
            let defaults = UserDefaults.standard
            defaults.set(foregroundCallbackHandleID?.int64Value, forKey: "foreground_callback_handle")
            defaults.set(backgroundCallbackHandleID?.int64Value, forKey: "background_callback_handle")
            defaults.set(autoStart, forKey: "auto_start")
            
            self.autoStart(isForeground: true)
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
            
            let backgroundEngine = FlutterEngine(name: "FlutterService")
            let isRunning = backgroundEngine.run(withEntrypoint: callbackName, libraryURI: uri)
            
            if (isRunning){
                let registrantCallback = SwiftFlutterBackgroundServicePlugin.flutterPluginRegistrantCallback
                registrantCallback?(backgroundEngine)
                
                let binaryMessenger = backgroundEngine.binaryMessenger
                let backgroundChannel = FlutterMethodChannel(name: "id.flutter/background_service_bg", binaryMessenger: binaryMessenger, codec: FlutterJSONMethodCodec())
                
                backgroundChannel.setMethodCallHandler(self.handleBackgroundMethodCall)
                if (isForeground){
                    self.backgroundEngine = backgroundEngine
                    self.backgroundChannel = backgroundChannel
                }
            }
        }
    }
}
