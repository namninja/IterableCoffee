//
//  HomeViewController.swift
//  IterableCoffee
//
//  Created by Nam Ngo on 10/15/21.
//

import UIKit
import IterableSDK

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func drinkSelect(_ sender: UIButton) {
        changeDrink(sender)
        
    }
 
    func changeDrink(_ sender: UIButton) {
        var coffeeType: CoffeeType?
        
        switch sender.currentTitle {
        case "Coffee":
            coffeeType = CoffeeType.coffee
        case "Cappuccino":
            coffeeType = CoffeeType.cappuccino
        case "Latte":
            coffeeType = CoffeeType.latte
        case "Mocha":
            coffeeType = CoffeeType.mocha
        default:
            coffeeType = CoffeeType.coffee
        }
        
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "coffee") as? CoffeeViewController {
            viewController.coffee = coffeeType
            self.present(viewController, animated: true, completion: nil)
            
        }
    }
    // MARK: Private
    
    private let coffees: [CoffeeType] = [
        .cappuccino,
        .latte,
        .mocha,
        .coffee,
    ]
  
    
    
    @IBAction func checkout(_ sender: UIButton) {
        
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
