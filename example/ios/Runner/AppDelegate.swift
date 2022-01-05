import UIKit
import Flutter
import flutter_background_service

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    /// Registers all pubspec-referenced Flutter plugins in the given registry.
//    static func registerPlugins(with registry: FlutterPluginRegistry) {
//            GeneratedPluginRegistrant.register(with: registry)
//       }
    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        GeneratedPluginRegistrant.register(with: self)
//        AppDelegate.registerPlugins(with: self)
//        SwiftFlutterBackgroundServicePlugin.setPluginRegistrantCallback { registry in
//            AppDelegate.registerPlugins(with: registry)
//        }
        
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}
