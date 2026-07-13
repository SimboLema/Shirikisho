import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    let controller = window?.rootViewController as! FlutterViewController
    let devModeChannel = FlutterMethodChannel(
      name: "com.humtech.shirikisho3/dev_mode",
      binaryMessenger: controller.binaryMessenger
    )

    devModeChannel.setMethodCallHandler { (call: FlutterMethodCall, result: @escaping FlutterResult) in
      if call.method == "isSimulator" {
        #if targetEnvironment(simulator)
          result(true)
        #else
          result(false)
        #endif
      } else {
        result(FlutterMethodNotImplemented)
      }
    }

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}