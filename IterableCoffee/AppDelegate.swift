//
//  AppDelegate.swift
//  IterableCoffee
//
//  Created by Nam Ngo on 10/15/21.
//

import UIKit
import UserNotifications
import Foundation
import IterableSDK
var TOKEN: Data?
let apiKey = TestData.testData
@main

class AppDelegate: UIResponder, UIApplicationDelegate, IterableURLDelegate {
    var window: UIWindow?
    
    



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        //init ITBL SDK
        // ITBL: Setup Notification
        setupNotifications()       
        
        let config = IterableConfig()
        //config.inAppDelegate = YourCustomInAppDelegate()
        config.logDelegate = AllLogDelegate()
        config.customActionDelegate = self
        config.urlDelegate = self
        //config.inAppDisplayInterval = 1
        config.enableEmbeddedMessaging = true
        config.allowedProtocols = ["reiterablecoffee"]
//      config.autoPushRegistration = false
        
        
        IterableAPI.initialize(apiKey: apiKey.iterableAPIKey, launchOptions: launchOptions, config: config)
        return true
    }
    
    private func application(_ application: UIApplication,
                     continue userActivity: NSUserActivity,
                     restorationHandler: @escaping ([Any]?) -> Void) -> Bool {

       guard let url = userActivity.webpageURL else {
          return false
       }
        print("here------>", url)
       // This tracks the click, retrieves the original URL, and uses it to
       // call handleIterableURL:context:
       return IterableAPI.handle(universalLink: url)
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        setupNotifications();
    }
    // MARK: UISceneSession Lifecycle

//    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
//        // Called when a new scene session is being created.
//        // Use this method to select a configuration to create the new scene with.
//        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
//    }
//
//    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
//        // Called when the user discards a scene session.
//        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
//        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
//    }

    // MARK: Silent Push for in-app
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        IterableAppIntegration.application(application, didReceiveRemoteNotification: userInfo, fetchCompletionHandler: completionHandler)
        
    }
    
    
    
    // MARK: Deep link

    func application(_: UIApplication, continue userActivity: NSUserActivity, restorationHandler _: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        guard let url = userActivity.webpageURL else {
            return false
        }
        // ITBL:
        return IterableAPI.handle(universalLink: url)
    }

    // MARK: IterableURLDelegate
    func handle(iterableURL url: URL, inContext context: IterableActionContext) -> Bool {
        // return true if we handled the url
        return DeepLinkHandler.handle(url: url)
    }
    
    
    
    // MARK: Notification
    
    // ITBL:
    func application(_: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let deviceTokenString = deviceToken.reduce("", { $0 + String(format: "%02X", $1) })
                print("Device Token: \(deviceTokenString)")
        IterableAPI.register(token: deviceToken)
        
    }
    
    func application(_: UIApplication, didFailToRegisterForRemoteNotificationsWithError _: Error) {}
    // ITBL:
    // Ask for permission for notifications etc.
    // setup self as delegate to listen to push notifications.
    private func setupNotifications() {
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            if settings.authorizationStatus != .authorized {
                // not authorized, ask for permission
                UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, _ in
                    if success {
                        DispatchQueue.main.async {
                            UIApplication.shared.registerForRemoteNotifications()
                        }
                    }
                    // TODO: Handle error etc.
                }
            } else {
                // already authorized
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
        }
    }
}


// MARK: UNUserNotificationCenterDelegate

extension AppDelegate: UNUserNotificationCenterDelegate {
    public func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
            // Handle the notification presentation while the app is in the foreground
            completionHandler([.banner, .badge, .sound])
            let userInfo = notification.request.content.userInfo
            print("Notification Payload (Foreground): \(userInfo)")
        print("here2")
        print(UIApplication.shared.applicationIconBadgeNumber)
        }
    
    // The method will be called on the delegate when the user responded to the notification by opening the application, dismissing the notification or choosing a UNNotificationAction. The delegate must be set before the application returns from applicationDidFinishLaunching:.
    public func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
                print("Notification Response Payload: \(userInfo)")
        // ITBL:
        IterableAppIntegration.userNotificationCenter(center, didReceive: response, withCompletionHandler: completionHandler)
    }
}


// MARK: IterableCustomActionDelegate

extension AppDelegate: IterableCustomActionDelegate {
    // handle the cutom action from push
    // return value true/false doesn't matter here, stored for future use
    func handle(iterableCustomAction action: IterableAction, inContext _: IterableActionContext) -> Bool {
        if action.type == "handleFindCoffee" {
            if let query = action.userInput {
                return DeepLinkHandler.handle(url: URL(string: "https://majumder.me/coffee?q=\(query)")!)
            }
        }
        return false
    }
}
class YourCustomInAppDelegate: IterableInAppDelegate {
    func onNew(message: IterableInAppMessage) -> InAppShowResponse {
        print("IterableHelper")
        let messages = IterableAPI.inAppManager.getMessages()
        
        if messages.isEmpty {
            print("there are no messages")
            return .skip
        } else {
            print("perform logic")
            // Show an in-app message
            return .show
        }
    }
}


//extension AppDelegate: IterableInAppDelegate {
//
//    public func onNew(message: IterableInAppMessage) -> InAppShowResponse {
//
//        // TODO: This never gets called for those custom json payload in-app messages
//
//        if let customPayload = message.customPayload as? [String: Any] {
//
//            print("IterableHelper onNew(message):\n\(message)")
//
//            return .skip
//
//        } else {
//
//            return .show
//
//        }
//
//    }
//
//}
