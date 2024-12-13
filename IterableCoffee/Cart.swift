//
//  Cart.swift
//  IterableCoffee
//
//  Created by Nam Ngo on 10/25/21.
//

import Foundation
import UIKit

import IterableSDK


//Where items added to the Cart are held
struct MyCart {
    static var cart: [CommerceItem] = []
}

//Definitions of Products
struct CartCoffeeType {
    static var coffee = CommerceItem(id: "IC001", name: "Coffee", price: 5.00, quantity: 1, sku: "COF01", description: "Plain Coffee", categories: ["hot","coffee","plain"])
    static var cappuccino = CommerceItem(id: "IC002", name: "Cappucino", price: 8.50, quantity: 1, sku: "CAP01", description: "Cappucino", categories: ["hot","espresso","foam","milk"])
    static var latte = CommerceItem(id: "IC003", name: "Latte", price: 8.50, quantity: 1, sku: "LAT01", description: "Cafe Latte", categories: ["hot","espresso","milk"])
    static var mocha = CommerceItem(id: "IC004", name: "Mocha", price: 9.00, quantity: 1, sku: "MOC01", description: "Mocha Latte", categories: ["hot","coffee","milk","mocha"])
}

let coffee = CommerceItem(id: "IC001", name: "Coffee", price: 5.00, quantity: 1, sku: "COF01", description: "Plain Coffee", categories: ["hot","coffee","plain"])
let cappuccino = CommerceItem(id: "IC002", name: "Cappucino", price: 8.50, quantity: 1, sku: "CAP01", description: "Cappucino", categories: ["hot","espresso","foam","milk"])
let latte = CommerceItem(id: "IC003", name: "Latte", price: 8.50, quantity: 1, sku: "LAT01", description: "Cafe Latte", categories: ["hot","espresso","milk"])
let mocha = CommerceItem(id: "IC004", name: "Mocha", price: 9.00, quantity: 1, sku: "MOC01", description: "Mocha Latte", categories: ["hot","coffee","milk","mocha"])

// Used for Menu to Populate CoffeeViewController
struct CoffeeType {
    let name: String
    let price: String
    let btn: String
    
    static let cappuccino = CoffeeType(name: "Cappuccino", price: "Price: $8.50", btn : "Add Cappuccino")
    static let latte = CoffeeType(name: "Latte", price: "Price: $8.50", btn : "Add Latte")
    static let mocha = CoffeeType(name: "Mocha", price: "Price: $9.00", btn : "Add Mocha")
    static let coffee = CoffeeType(name: "Coffee", price: "Price: $5.00", btn : "Add Coffee")
}

