//
//  CoffeeViewController.swift
//  IterableCoffee
//
//  Created by Nam Ngo on 10/26/21.
//

import UIKit
import IterableSDK

class CoffeeViewController: UIViewController, StoryboardInstantiable {
    static var storyboardName: String  = "Main"
    static var storyboardId: String = "CoffeeViewController"
    
    
    public var coffee : CoffeeType?
    
   

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let coffee = coffee {
            drinkType.text = coffee.name
            drinkPrice.text = coffee.price
            drinkButton.setTitle(coffee.btn, for: .normal)
            
        }
    }
    
    @IBOutlet weak var drinkType: UILabel!
    @IBOutlet weak var drinkPrice: UILabel!
    @IBOutlet weak var drinkButton: UIButton!
    
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
        print(type(of: MyCart.cart))
        IterableAPI.updateCart(items: MyCart.cart)
        
        
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
