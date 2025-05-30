////
////  AppDelegate.swift
////  IterableCoffee
////
////  Created by Nam Ngo on 10/15/21.
////
//
//import UIKit
//import UserNotifications
//import Foundation
//import IterableSDK
//@preconcurrency import WebKit
//var TOKEN: Data?
//let apiKey = TestData.testData
//@main
//
//class AppDelegate: UIResponder, UIApplicationDelegate, IterableURLDelegate {
//    var window: UIWindow?
//    
//    
//
//
//
//    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//        // Override point for customization after application launch.
//        //init ITBL SDK
//        // ITBL: Setup Notification
//        setupNotifications()       
//        
//        let config = IterableConfig()
//        
//        config.inAppDelegate = YourCustomInAppDelegate()
//        config.logDelegate = AllLogDelegate()
//        config.customActionDelegate = self
//        config.urlDelegate = self
//        //config.inAppDisplayInterval = 1
//        config.enableEmbeddedMessaging = true
//        config.allowedProtocols = ["reiterablecoffee"]
////      config.autoPushRegistration = false
//        
//        
//        IterableAPI.initialize(apiKey: apiKey.iterableAPIKey, launchOptions: launchOptions, config: config)
//        return true
//    }
//    
//    private func application(_ application: UIApplication,
//                     continue userActivity: NSUserActivity,
//                     restorationHandler: @escaping ([Any]?) -> Void) -> Bool {
//
//       guard let url = userActivity.webpageURL else {
//          return false
//       }
//        print("here------>", url)
//       // This tracks the click, retrieves the original URL, and uses it to
//       // call handleIterableURL:context:
//       return IterableAPI.handle(universalLink: url)
//    }
//
//    func applicationWillEnterForeground(_ application: UIApplication) {
//        setupNotifications();
//    }
//    // MARK: UISceneSession Lifecycle
//
////    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
////        // Called when a new scene session is being created.
////        // Use this method to select a configuration to create the new scene with.
////        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
////    }
////
////    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
////        // Called when the user discards a scene session.
////        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
////        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
////    }
//
//    // MARK: Silent Push for in-app
//    
//    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
//        
//        IterableAppIntegration.application(application, didReceiveRemoteNotification: userInfo, fetchCompletionHandler: completionHandler)
//        
//    }
//    
//    
//    
//    // MARK: Deep link
//
//    func application(_: UIApplication, continue userActivity: NSUserActivity, restorationHandler _: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
//        guard let url = userActivity.webpageURL else {
//            return false
//        }
//        // ITBL:
//        return IterableAPI.handle(universalLink: url)
//    }
//
//    // MARK: IterableURLDelegate
//    func handle(iterableURL url: URL, inContext context: IterableActionContext) -> Bool {
//        // return true if we handled the url
//        return DeepLinkHandler.handle(url: url)
//    }
//    
//    
//    
//    // MARK: Notification
//    
//    // ITBL:
//    func application(_: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
//        let deviceTokenString = deviceToken.reduce("", { $0 + String(format: "%02X", $1) })
//                print("Device Token: \(deviceTokenString)")
//        IterableAPI.register(token: deviceToken)
//        
//    }
//    
//    func application(_: UIApplication, didFailToRegisterForRemoteNotificationsWithError _: Error) {}
//    // ITBL:
//    // Ask for permission for notifications etc.
//    // setup self as delegate to listen to push notifications.
//    private func setupNotifications() {
//        UNUserNotificationCenter.current().delegate = self
//        UNUserNotificationCenter.current().getNotificationSettings { settings in
//            if settings.authorizationStatus != .authorized {
//                // not authorized, ask for permission
//                UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, _ in
//                    if success {
//                        DispatchQueue.main.async {
//                            UIApplication.shared.registerForRemoteNotifications()
//                        }
//                    }
//                    // TODO: Handle error etc.
//                }
//            } else {
//                // already authorized
//                DispatchQueue.main.async {
//                    UIApplication.shared.registerForRemoteNotifications()
//                }
//            }
//        }
//    }
//}
//
//
//// MARK: UNUserNotificationCenterDelegate
//
//extension AppDelegate: UNUserNotificationCenterDelegate {
//    public func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
//            // Handle the notification presentation while the app is in the foreground
//            completionHandler([.banner, .badge, .sound])
//            let userInfo = notification.request.content.userInfo
//            print("Notification Payload (Foreground): \(userInfo)")
//        print("here2")
//        print(UIApplication.shared.applicationIconBadgeNumber)
//        }
//    
//    // The method will be called on the delegate when the user responded to the notification by opening the application, dismissing the notification or choosing a UNNotificationAction. The delegate must be set before the application returns from applicationDidFinishLaunching:.
//    public func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
//        let userInfo = response.notification.request.content.userInfo
//                print("Notification Response Payload: \(userInfo)")
//        // ITBL:
//        IterableAppIntegration.userNotificationCenter(center, didReceive: response, withCompletionHandler: completionHandler)
//    }
//}
//
//
//// MARK: IterableCustomActionDelegate
//
//extension AppDelegate: IterableCustomActionDelegate {
//    // handle the cutom action from push
//    // return value true/false doesn't matter here, stored for future use
//    func handle(iterableCustomAction action: IterableAction, inContext _: IterableActionContext) -> Bool {
//        if action.type == "handleFindCoffee" {
//            if let query = action.userInput {
//                return DeepLinkHandler.handle(url: URL(string: "https://majumder.me/coffee?q=\(query)")!)
//            }
//        }
//        return false
//    }
//}
//extension UIApplication {
//    func topViewController(base: UIViewController? = nil) -> UIViewController? {
//        // Ensure we're on the main thread
//        if !Thread.isMainThread {
//            print("Warning: topViewController called off the main thread.")
//            return nil
//        }
//
//        let rootVC: UIViewController? = {
//            if let base = base {
//                return base
//            }
//
//            return UIApplication.shared.connectedScenes
//                .compactMap { $0 as? UIWindowScene }
//                .first(where: { $0.activationState == .foregroundActive })?
//                .windows
//                .first(where: \.isKeyWindow)?
//                .rootViewController
//        }()
//
//        if let nav = rootVC as? UINavigationController {
//            return topViewController(base: nav.visibleViewController)
//        }
//
//        if let tab = rootVC as? UITabBarController, let selected = tab.selectedViewController {
//            return topViewController(base: selected)
//        }
//
//        if let presented = rootVC?.presentedViewController {
//            return topViewController(base: presented)
//        }
//
//        return rootVC
//    }
//}
//class YourCustomInAppDelegate: IterableInAppDelegate {
//    
//    func onNew(message: IterableInAppMessage) -> InAppShowResponse {
//        var shouldSkip = false
//        var email: String = TestData.testData.email
//        DispatchQueue.main.sync {
//            if let topVC = UIApplication.shared.topViewController(),
//               topVC is CheckoutViewController,
//               let campaignId = message.campaignId?.intValue {
//                
//                print("User is on CheckoutViewController - skipping and canceling message")
//                cancelMessageOnServer(campaignId: campaignId, email: email)
//                shouldSkip = true
//            }
//        }
//
//        return shouldSkip ? .skip : .show
//    }
//}
//private func cancelMessageOnServer(campaignId: Int, email: String?) {
//    guard let email = email,
//          let url = URL(string: "https://api.iterable.com/api/inApp/cancel") else {
//        print("Missing email or server URL")
//        return
//    }
//
//    var request = URLRequest(url: url)
//    request.httpMethod = "POST"
//    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//
//    let payload: [String: Any] = [
//        "campaignId": campaignId,
//        "email": email
//    ]
//
//    request.httpBody = try? JSONSerialization.data(withJSONObject: payload)
//
//    URLSession.shared.dataTask(with: request) { data, response, error in
//        if let error = error {
//            print("Error canceling in-app message: \(error)")
//        } else {
//            print("Successfully requested cancel for campaignId \(campaignId)")
//        }
//    }.resume()
//}
//
//
////extension AppDelegate: IterableInAppDelegate {
////
////    public func onNew(message: IterableInAppMessage) -> InAppShowResponse {
////
////        // TODO: This never gets called for those custom json payload in-app messages
////
////        if let customPayload = message.customPayload as? [String: Any] {
////
////            print("IterableHelper onNew(message):\n\(message)")
////
////            return .skip
////
////        } else {
////
////            return .show
////
////        }
////
////    }
////
////}
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
@preconcurrency import WebKit

let apiKey = TestData.testData

@main
class AppDelegate: UIResponder, UIApplicationDelegate, IterableURLDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        setupNotifications()

        let config = IterableConfig()
        config.inAppDisplayInterval = 10.0
        config.inAppDelegate = YourCustomInAppDelegate()
        config.logDelegate = AllLogDelegate()
        //config.customActionDelegate = self
        config.urlDelegate = self
        config.enableEmbeddedMessaging = true
        config.allowedProtocols = ["reiterablecoffee", "https", "tel", "custom", "action"]

        IterableAPI.initialize(apiKey: apiKey.iterableAPIKey,
                               launchOptions: launchOptions,
                               config: config)

        return true
    }
    
    // MARK: Deep Links (Universal Links)
    func application(_ application: UIApplication,
                     continue userActivity: NSUserActivity,
                     restorationHandler: @escaping ([Any]?) -> Void) -> Bool {
        guard let url = userActivity.webpageURL else {
            return false
        }
        return IterableAPI.handle(universalLink: url)
    }

    // MARK: URL Delegate (In-App/Inbox Clicks)
    func handle(iterableURL url: URL, inContext context: IterableActionContext) -> Bool {
        if let topVC = UIApplication.shared.topViewController(),
           NSStringFromClass(type(of: topVC)).contains("IterableHtmlMessageViewController") {
            DispatchQueue.main.async {
                topVC.dismiss(animated: true) {
                    _ = DeepLinkHandler.handle(url: url)
                }
            }
            return true
        }
        return DeepLinkHandler.handle(url: url)
    }

    // MARK: Silent Push for In-App Sync
    func application(_ application: UIApplication,
                     didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        IterableAppIntegration.application(application,
                                           didReceiveRemoteNotification: userInfo,
                                           fetchCompletionHandler: completionHandler)
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        setupNotifications()
    }

    // MARK: Remote Notifications
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let deviceTokenString = deviceToken.reduce("") { $0 + String(format: "%02X", $1) }
        print("Device Token: \(deviceTokenString)")
        IterableAPI.register(token: deviceToken)
    }

    func application(_ application: UIApplication,
                     didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register for remote notifications: \(error)")
    }

    // MARK: Ask for Notification Permissions
    private func setupNotifications() {
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            if settings.authorizationStatus != .authorized {
                UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, _ in
                    if success {
                        DispatchQueue.main.async {
                            UIApplication.shared.registerForRemoteNotifications()
                        }
                    }
                }
            } else {
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
        }
    }
}

// MARK: - Notification Center Delegate
extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .badge, .sound])
        print("Foreground notification: \(notification.request.content.userInfo)")
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        print("Notification tapped: \(response.notification.request.content.userInfo)")
        IterableAppIntegration.userNotificationCenter(center,
                                                      didReceive: response,
                                                      withCompletionHandler: completionHandler)
    }
}



// MARK: - In-App Display Delegate
class YourCustomInAppDelegate: IterableInAppDelegate {
    func onNew(message: IterableInAppMessage) -> InAppShowResponse {
        var shouldSkip = false
        let email = TestData.testData.email

        DispatchQueue.main.sync {
            if let topVC = UIApplication.shared.topViewController(),
               topVC is CheckoutViewController,
               let campaignId = message.campaignId?.intValue {
                print("Skipping message on CheckoutViewController")
                cancelMessageOnServer(campaignId: campaignId, email: email)
                shouldSkip = true
            }
        }

        return shouldSkip ? .skip : .show
    }
}

private func cancelMessageOnServer(campaignId: Int, email: String?) {
    guard let email = email,
          let url = URL(string: "https://api.iterable.com/api/inApp/cancel") else {
        print("Missing email or URL for cancel")
        return
    }

    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")

    let payload: [String: Any] = [
        "campaignId": campaignId,
        "email": email
    ]

    request.httpBody = try? JSONSerialization.data(withJSONObject: payload)

    URLSession.shared.dataTask(with: request) { data, response, error in
        if let error = error {
            print("Error cancelling message: \(error)")
        } else {
            print("Cancelled message for campaign \(campaignId)")
        }
    }.resume()
}

// MARK: - UIApplication Extension
extension UIApplication {
    func topViewController(base: UIViewController? = nil) -> UIViewController? {
        let base = base ?? self.connectedScenes
            .compactMap { ($0 as? UIWindowScene)?.keyWindow }
            .first?.rootViewController

        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        } else if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
            return topViewController(base: selected)
        } else if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        } else {
            return base
        }
    }
}
