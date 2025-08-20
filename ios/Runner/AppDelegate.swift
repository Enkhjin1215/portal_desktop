import UIKit
import Flutter
import Firebase

@main
@objc class AppDelegate: FlutterAppDelegate, MessagingDelegate {
    private let applePayHandler = ApplePayHandler()
     
     override func application(
         _ application: UIApplication,
         didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
     ) -> Bool {
            if #available(iOS 12.1, *) {
                UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
            }
         FirebaseApp.configure()
         let controller = window?.rootViewController as! FlutterViewController
         let channel = FlutterMethodChannel(
             name: "apple_pay_channel",
             binaryMessenger: controller.binaryMessenger
         )
         
         channel.setMethodCallHandler { [weak self] (call, result) in
             self?.applePayHandler.handleMethodCall(call, result: result)
         }
 
         GeneratedPluginRegistrant.register(with: self)
         return super.application(application, didFinishLaunchingWithOptions: launchOptions)
     }
 }
