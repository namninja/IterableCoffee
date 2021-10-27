//
//  AppDelegate.swift
//  IterableCoffee
//
//  Created by Nam Ngo on 10/15/21.
//

import UIKit
import Foundation
import IterableSDK

@main
class AppDelegate: UIResponder, UIApplicationDelegate, IterableURLDelegate {
    
    // MARK: IterableURLDelegate
    func handle(iterableURL url: URL, inContext context: IterableActionContext) -> Bool {
        // return true if we handled the url
        DeepLinkHandler.handle(url: url)
    }
    
    
    



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        //init ITBL SDK
        let config = IterableConfig()
        IterableAPI.initialize(apiKey: "96ffdb17e4fd4f9f8de53edba8516b0c", launchOptions: launchOptions, config: config)
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

    
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    


}

