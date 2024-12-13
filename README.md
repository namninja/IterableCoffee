# Sample iOS App

Welcome to the **Sample iOS App** repository! This app demonstrates basic functionality and integration with Iterable SDK. Follow the instructions below to get started.

---

## **Getting Started**

### 1. Clone the Repository
Clone this repository to your local machine:

```bash
git clone <repository-url>
```

### 2. Create the `User.swift` File

Once you have cloned the repository, you need to manually create a `User.swift` file. This file contains test data required for the app to function.

#### Steps to Create `User.swift`

1. Navigate to the `IterableCoffee` folder in the project directory.
2. Create a new file named `User.swift`.
3. Copy and paste the following content into the `User.swift` file:

```swift
import Foundation
import UIKit

import IterableSDK

// This is dummy data for testing
public struct TestData {
    let email: String
    let phoneNumber: String
    let password: String
    let favoriteBeverage: String
    let firstName: String
    let lastName: String
    let iterableAPIKey: String

    static let testData = TestData(
        email: "<Replace with Test Email>",
        phoneNumber: "<Replace with SMS Test Number>",
        password: "demo",
        favoriteBeverage: "mocha",
        firstName: "Thor",
        lastName: "Odinson",
        iterableAPIKey: "<Iterable API Key>"
    )
}
```

4. Update the `testData` values with your own test data:
   - Replace `<Replace with Test Email>` with your test email address.
   - Replace `<Replace with SMS Test Number>` with your test SMS number.
   - Replace `<Iterable API Key>` with your Iterable API Key.

### 3. Apple Developer Account Setup

To enable push notifications for this app, you need an **Apple Developer Account**. Follow the steps below:

1. Sign up for or log in to your [Apple Developer Account](https://developer.apple.com/).
2. Create an **App Identifier** for your project in the Apple Developer portal.
3. Enable **Push Notifications** for the App Identifier.
4. Create a Push Notification certificate and upload it to your Iterable project.
5. Update the app's provisioning profile with the Push Notification capability if it is not already configured.

### 4. Build and Run the Project

1. Open the project in Xcode.
2. Ensure the correct Bundle Identifier and Team are selected in the project settings.
3. Build and run the project on a simulator or physical device.

---

## **Key Features**

- **Iterable SDK Integration**: Demonstrates how to use Iterable SDK for sending and tracking in-app events.
- **Push Notifications**: Includes basic setup for push notification integration.

---

## **Troubleshooting**

- Ensure that the `User.swift` file is correctly created and populated with your test values.
- Verify that your Apple Developer account is active and properly configured.
- Check for any missing dependencies or incorrect API keys in the project.

---

## **License**

This project is provided as-is for demonstration purposes only and is not intended for production use.

