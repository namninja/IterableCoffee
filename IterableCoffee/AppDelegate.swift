

import UIKit
import UserNotifications
import Foundation
import IterableSDK
@preconcurrency import WebKit

let apiKey = TestData.testData

@main
class AppDelegate: UIResponder, UIApplicationDelegate, IterableURLDelegate {
    var window: UIWindow?
    var pendingLaunchOptions: [UIApplication.LaunchOptionsKey: Any]?
    private var isIterableInitialized = false

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        setupNotifications()
        
        // Store launch options for later use
        pendingLaunchOptions = launchOptions

        // Check if project has been selected
        if UserDefaults.standard.string(forKey: "selectedIterableProject") == nil {
            // Show prompt to select project
            showProjectSelectionPrompt()
        } else {
            // Initialize Iterable with saved preference
            initializeIterable(with: launchOptions)
        }

        return true
    }
    
    // MARK: - Project Selection Prompt
    private func showProjectSelectionPrompt() {
        // Wait for the window to be ready
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            guard let self = self else { return }
            
            // Try multiple ways to get the root view controller
            var rootViewController: UIViewController?
            
            if let window = self.window {
                rootViewController = window.rootViewController
            } else if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                      let window = windowScene.windows.first(where: { $0.isKeyWindow }) {
                rootViewController = window.rootViewController
            } else if let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) {
                rootViewController = window.rootViewController
            }
            
            guard let rootVC = rootViewController else {
                // If window not ready, try again shortly
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.showProjectSelectionPrompt()
                }
                return
            }
            
            let alert = UIAlertController(
                title: "Select Iterable Project",
                message: "Choose which Iterable project to use:",
                preferredStyle: .alert
            )
            
            alert.addAction(UIAlertAction(title: "Email", style: .default) { [weak self] _ in
                UserDefaults.standard.set("Email", forKey: "selectedIterableProject")
                self?.initializeIterable(with: self?.pendingLaunchOptions)
            })
            
            alert.addAction(UIAlertAction(title: "Hybrid", style: .default) { [weak self] _ in
                UserDefaults.standard.set("Hybrid", forKey: "selectedIterableProject")
                self?.initializeIterable(with: self?.pendingLaunchOptions)
            })
            
            rootVC.present(alert, animated: true)
        }
    }
    
    // MARK: - Initialize Iterable SDK
    private func initializeIterable(with launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        guard !isIterableInitialized else {
            print("⚠️ Iterable already initialized, skipping...")
            return
        }
        
        let config = IterableConfig()
        config.inAppDisplayInterval = 10.0
        config.inAppDelegate = YourCustomInAppDelegate()
        config.logDelegate = AllLogDelegate()
        config.customActionDelegate = self
        config.urlDelegate = self
        config.enableEmbeddedMessaging = true
        config.allowedProtocols = ["reiterablecoffee", "https", "tel", "custom", "action"]
        
        let selectedProject = UserDefaults.standard.string(forKey: "selectedIterableProject") ?? "Email"
        let apiKeyValue = selectedProject == "Hybrid" ? TestData.testData.iterableAPIKeyHybrid : TestData.testData.iterableAPIKeyEmail
        
        print("📱 Initializing Iterable with \(selectedProject) project API key")
        
        IterableAPI.initialize(apiKey: apiKeyValue,
                               launchOptions: launchOptions,
                               config: config)
        
        isIterableInitialized = true
    }
    
    // MARK: Deep Links (Universal Links)
    func application(_: UIApplication, continue userActivity: NSUserActivity, restorationHandler _: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
            guard let url = userActivity.webpageURL else {
                return false
            }
            // ITBL:
            return IterableAPI.handle(universalLink: url)
        }

    // MARK: URL Delegate (In-App/Inbox Clicks)
    func handle(iterableURL url: URL, inContext context: IterableActionContext) -> Bool {
        print("🔗 Handling Iterable URL: \(url.absoluteString) in context: \(context.source)")
        
        // Simple approach like the working version
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
    
    // MARK: URL Scheme Handling (Fallback)
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        print("🔗 Handling URL scheme: \(url.absoluteString)")
        print("🔗 URL scheme: \(url.scheme ?? "nil")")
        print("🔗 URL host: \(url.host ?? "nil")")
        print("🔗 URL path: \(url.path)")
        
        // Handle reiterablecoffee:// scheme
        if url.scheme == "reiterablecoffee" {
            return DeepLinkHandler.handle(url: url)
        }
        
        // Handle https://www.reiterablecoffee.com URLs as fallback
        if url.scheme == "https" && url.host == "www.reiterablecoffee.com" {
            return DeepLinkHandler.handle(url: url)
        }
        
        return false
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

// MARK: - IterableCustomActionDelegate
extension AppDelegate: IterableCustomActionDelegate {
    func handle(iterableCustomAction action: IterableAction, inContext context: IterableActionContext) -> Bool {
        print("📱 Handling custom action: \(action.type)")
        
        // Handle custom actions from push notifications
        if action.type == "handleFindCoffee" {
            if let query = action.userInput {
                // Use the correct URL format for your domain
                let url = URL(string: "https://www.reiterablecoffee.com/publicmenu/\(query.lowercased())")!
                return DeepLinkHandler.handle(url: url)
            }
        }
        
        // Handle any URL-based actions
        if let urlString = action.userInput, let url = URL(string: urlString) {
            return DeepLinkHandler.handle(url: url)
        }
        
        return false
    }
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
