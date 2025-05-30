 //
//  HomeViewController.swift
//  IterableCoffee
//
//  Created by Nam Ngo on 10/15/21.
//

import UIKit
import IterableSDK

// MARK: Home Page
class HomeViewController: UIViewController, IterableEmbeddedUpdateDelegate {

    @IBOutlet weak var coffeeBtn: UIButton!
    @IBOutlet weak var cappiccinoBtn: UIButton!
    @IBOutlet weak var latteBtn: UIButton!
    @IBOutlet weak var mochaBtn: UIButton!
    @IBOutlet weak var checkoutBtn: UIButton!
    @IBOutlet weak var logoutBtn: UIButton!
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var containerView: UIView! // Container for the embedded message view
    
    
    // MARK: Mobile Inbox
    @IBAction func showInbox(_ sender: UIButton) {
        // Fetch inbox messages
        let inboxMessages = IterableAPI.inAppManager.getInboxMessages()
            
            // Log the number of messages for debugging
            print("Number of inbox messages: \(inboxMessages.count)")
            
            // Initialize and present the inbox view controller
            let inboxViewController = IterableInboxNavigationViewController()
            inboxViewController.navTitle = "Your Inbox"
            inboxViewController.noMessagesTitle = "No Messages"
            inboxViewController.noMessagesBody = "You have no new messages. Check back later!"
           

            present(inboxViewController, animated: true, completion: nil)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        refreshEmbeddedMessages()
        // Add the button press effect here
        setupButtonEffects()
        self.containerView.isHidden = true
        self.logo.isHidden = false
    }
    
    // MARK: Embedded Messaging
    // This placement is tied to a Journey that triggers on an updateCart event and sends an embedded message
    // The Embedded Messages replace the Home Screen Image and rotate on a timer, like a Carousel.
    // For demoing purposes, you can reset the placement by Updating the user profile with "resetPlacements": false
    // Then to start showing embedded messages again, set "resetPlacements": true
    let placementId: Int = 952
    var embeddedMessageView: EmbeddedMessageView?
    var currentIndex = 0
    var timer: Timer?
    
    // Function to refresh embedded messages
    func refreshEmbeddedMessages() {
        IterableAPI.embeddedManager.syncMessages {
            print("Successfully refreshed embedded messages.")
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        IterableAPI.embeddedManager.addUpdateListener(self)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        IterableAPI.embeddedManager.removeUpdateListener(self)
        timer?.invalidate() // Stop the timer when the view disappears
    }
    func onMessagesUpdated() {
        let embeddedMessages = IterableAPI.embeddedManager.getMessages(for: placementId)
        DispatchQueue.main.async {
            self.updateEmbeddedMessageView(with: embeddedMessages)
        }
    }
    private func updateEmbeddedMessageView(with messages: [IterableEmbeddedMessage]) {
        // Clear existing views
        containerView.subviews.forEach { $0.removeFromSuperview() }

        if messages.isEmpty {
            containerView.isHidden = true
            logo.isHidden = false
            return
        }

        // Show the container view
        containerView.isHidden = false
        logo.isHidden = true

        // Add the first message view
        let messageView = EmbeddedMessageView()
        messageView.message = messages[currentIndex]
        messageView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(messageView)

        // Add constraints for the messageView
        NSLayoutConstraint.activate([
            messageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            messageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            messageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            messageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])

        // Start cycling messages
        timer = Timer.scheduledTimer(withTimeInterval: 7.0, repeats: true) { [weak self] _ in
            self?.cycleToNextMessage(messages: messages)
        }
    }

    private func cycleToNextMessage(messages: [IterableEmbeddedMessage]) {
        if messages.isEmpty { return }

        currentIndex = (currentIndex + 1) % messages.count
        let nextMessage = messages[currentIndex]

        // Update the message view
        if let messageView = self.containerView.subviews.first as? EmbeddedMessageView {
            messageView.message = nextMessage
        }
    }

    func onEmbeddedMessagingDisabled() {
        // Handle the case when embedded messaging is disabled
        print("Embedded messaging is disabled. Update UI accordingly.")
        // Hide messages or show default content
        DispatchQueue.main.async {
            self.containerView.isHidden = true
            self.logo.isHidden = false // Optionally show the logo if no messages
        }
    }
    
    // MARK: Menu
    // Selecting a Drink will show the CoffeeViewController
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
        
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CoffeeViewController") as? CoffeeViewController {
            viewController.coffee = coffeeType
            self.present(viewController, animated: true, completion: nil)
            
        }
    }
    
    private let coffees: [CoffeeType] = [
        .cappuccino,
        .latte,
        .mocha,
        .coffee,
    ]
  
    
    // MARK: Logout
    // This will set endpointEnabled = false for this device in the devices object on the User profile
    @IBAction func logout(_ sender: UIButton) {
     IterableAPI.disableDeviceForCurrentUser()
       
//        if let link = URL(string: "https://youtube.com") {
//          UIApplication.shared.open(link)
//        }
    }
    
    // MARK: Logout
    @IBAction func checkout(_ sender: UIButton) {
        // All cart data is stored in App memory.  Clicking this button will switch to the CheckoutViewController
    }
    
    
    // MARK: Button Effects
    // Button press effect: Scale down when pressed
    func setupButtonEffects() {
        coffeeBtn.addTarget(self, action: #selector(buttonTouchDown), for: .touchDown)
        coffeeBtn.addTarget(self, action: #selector(buttonTouchUp), for: [.touchUpInside, .touchUpOutside])
        cappiccinoBtn.addTarget(self, action: #selector(buttonTouchDown), for: .touchDown)
        cappiccinoBtn.addTarget(self, action: #selector(buttonTouchUp), for: [.touchUpInside, .touchUpOutside])
        latteBtn.addTarget(self, action: #selector(buttonTouchDown), for: .touchDown)
        latteBtn.addTarget(self, action: #selector(buttonTouchUp), for: [.touchUpInside, .touchUpOutside])
        mochaBtn.addTarget(self, action: #selector(buttonTouchDown), for: .touchDown)
        mochaBtn.addTarget(self, action: #selector(buttonTouchUp), for: [.touchUpInside, .touchUpOutside])
        checkoutBtn.addTarget(self, action: #selector(buttonTouchDown), for: .touchDown)
        checkoutBtn.addTarget(self, action: #selector(buttonTouchUp), for: [.touchUpInside, .touchUpOutside])
        logoutBtn.addTarget(self, action: #selector(buttonTouchDown), for: .touchDown)
        logoutBtn.addTarget(self, action: #selector(buttonTouchUp), for: [.touchUpInside, .touchUpOutside])
    }
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
