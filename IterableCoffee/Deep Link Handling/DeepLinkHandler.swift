//
//  DeepLinkHandler.swift
//  IterableCoffee
//
//  Created by Nam Ngo on 10/15/21.
//

import UIKit

struct DeepLinkHandler {
    static func handle(url: URL) -> Bool {
        print("📲 Handling deep link: \(url.absoluteString)")
        print("📲 URL host: \(url.host ?? "nil")")
        print("📲 URL path: \(url.path)")

        let path = url.path.lowercased()
        let topVC = UIApplication.shared.topViewController()

        // More flexible URL matching - handles various URL patterns
        let coffeeType = extractCoffeeType(from: path)
        
        if let coffee = coffeeType {
            print("📲 Found coffee type: \(coffee.name)")
            open(coffee, from: topVC)
            return true
        }

        print("❌ Unknown deep link: \(url.absoluteString)")
        print("❌ Path components: \(path.components(separatedBy: "/"))")
        return false
    }
    
    // MARK: - URL Parsing
    private static func extractCoffeeType(from path: String) -> CoffeeType? {
        print("🔍 Extracting coffee type from path: '\(path)'")
        
        // Handle various URL patterns:
        // - /publicmenu/mocha
        // - /mocha
        // - /coffee/mocha
        // - /menu/mocha
        // - /drink/mocha
        // - /product/mocha
        
        let pathComponents = path.components(separatedBy: "/")
        print("🔍 Path components: \(pathComponents)")
        
        // Look for coffee type in the last component or second to last
        let lastComponent = pathComponents.last?.lowercased() ?? ""
        let secondLastComponent = pathComponents.count > 1 ? pathComponents[pathComponents.count - 2].lowercased() : ""
        
        print("🔍 Last component: '\(lastComponent)'")
        print("🔍 Second last component: '\(secondLastComponent)'")
        
        // Check if any component matches a coffee type
        for (index, component) in pathComponents.enumerated() {
            let cleanComponent = component.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
            print("🔍 Checking component \(index): '\(cleanComponent)'")
            
            switch cleanComponent {
            case "mocha":
                print("🔍 ✅ Found mocha")
                return .mocha
            case "latte":
                print("🔍 ✅ Found latte")
                return .latte
            case "cappuccino":
                print("🔍 ✅ Found cappuccino")
                return .cappuccino
            case "coffee":
                print("🔍 ✅ Found coffee")
                return .coffee
            default:
                print("🔍 ❌ No match for '\(cleanComponent)'")
                continue
            }
        }
        
        print("🔍 ❌ No coffee type found in path")
        return nil
    }

    private static func open(_ coffee: CoffeeType, from topVC: UIViewController?) {
        DispatchQueue.main.async {
            guard let topVC = topVC else {
                print("⚠️ No top view controller found for deep link navigation")
                return
            }
            
            guard let coffeeVC = UIStoryboard(name: "Main", bundle: nil)
                    .instantiateViewController(withIdentifier: "CoffeeViewController") as? CoffeeViewController else {
                print("⚠️ Could not load CoffeeViewController from storyboard.")
                return
            }

            coffeeVC.coffee = coffee
            
            // Try to use navigation controller if available, otherwise present modally
            if let navController = topVC.navigationController {
                print("📱 Navigating to \(coffee.name) via navigation controller")
                navController.pushViewController(coffeeVC, animated: true)
            } else {
                print("📱 Presenting \(coffee.name) modally")
                topVC.present(coffeeVC, animated: true)
            }
        }
    }
}
