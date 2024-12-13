//
//  CoffeeViewController.swift
//  IterableCoffee
//
//  Created by Nam Ngo on 10/26/21.
//

import UIKit
import IterableSDK

//This is a dynamic component that poplates based on the drink selected from the home menu
class CoffeeViewController: UIViewController, StoryboardInstantiable {
    
  
    @IBOutlet weak var backToMenuBtn: UIButton!
    @IBOutlet weak var drinkType: UILabel!
    @IBOutlet weak var drinkPrice: UILabel!
    @IBOutlet weak var drinkButton: UIButton!
    
    static var storyboardName: String  = "Main"
    static var storyboardId: String = "CoffeeViewController"
    public var coffee : CoffeeType?
    override func viewDidLoad() {
        super.viewDidLoad()
        //Add Button effects
        setupButtonEffects()
        // Do any additional setup after loading the view.
        if let coffee = coffee {
            drinkType.text = coffee.name
            drinkPrice.text = coffee.price
            drinkButton.setTitle(coffee.btn, for: .normal)
            
        }
    }
    // MARK: Add to Cart
    // Add a coffee to the cart based on the Drink Chosen on the Home Menu
    // We use the Cart.swift class to store our test product data
    @IBAction func addCart(_ sender: UIButton) {
        let drink = sender.currentTitle!
        print(drink)
        
        switch drink {
        case "Add Coffee":
            MyCart.cart.append(CartCoffeeType.coffee)
        case "Add Cappuccino":
            MyCart.cart.append(CartCoffeeType.cappuccino)
        case "Add Latte":
            MyCart.cart.append(CartCoffeeType.latte)
        case "Add Mocha":
            MyCart.cart.append(CartCoffeeType.mocha)
        default:
            print("error")
        }
        
        print(MyCart.cart)
        IterableAPI.updateCart(items: MyCart.cart)
        
        
    }
    // MARK: Button Effects
    func setupButtonEffects() {
        drinkButton.addTarget(self, action: #selector(buttonTouchDown), for: .touchDown)
        drinkButton.addTarget(self, action: #selector(buttonTouchUp), for: [.touchUpInside, .touchUpOutside])
        backToMenuBtn.addTarget(self, action: #selector(buttonTouchDown), for: .touchDown)
        backToMenuBtn.addTarget(self, action: #selector(buttonTouchUp), for: [.touchUpInside, .touchUpOutside])
    }
    // Button press effect: Scale down when pressed
    @objc func buttonTouchDown(sender: UIButton) {
        UIView.animate(withDuration: 0.1, animations: {
            sender.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        })
    }
    
    // Button press effect: Scale back to normal when released
    @objc func buttonTouchUp(sender: UIButton) {
        UIView.animate(withDuration: 0.1, animations: {
            sender.transform = CGAffineTransform.identity
        })
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
