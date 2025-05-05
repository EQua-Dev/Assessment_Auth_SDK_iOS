# 🚀 AuthSDK

**AuthSDK** is a Swift-based authentication SDK that offers a customizable UI for user registration and login. It supports seamless integration into **native iOS** and **Flutter** applications.

---

## ✨ Features

- ✅ Customizable UI colors and labels  
- ✅ Supports showing/hiding username input  
- ✅ Returns user data (email, password, first/last name, username)  
- ✅ Works with both Swift and Flutter  
- ✅ Easy integration via method channels for Flutter

---

## 📱 Native iOS Integration (SwiftUI)

### ✅ Requirements

- iOS 13+
- Swift 5.5+
- SwiftUI enabled project

---

### 🛠 Installation

1. **Add SDK to your Xcode project**  
   - Drag the [.xcframework file](https://github.com/EQua-Dev/Assessment_Auth_SDK_iOS/tree/main/AuthSDK.xcframework) into your iOS project folder (preferably under a Frameworks folder)
   - Go to the Project Navigator and under General -> Targets, locate 'Frameworks, Libraries and Embedded Content' and add the framework file there. Then select 'Sign & Embed'

2. **Import the SDK**

```swift
import AuthSDK
```
3. **Within your SwiftUI body view, utilise the SDK**
```swift
  // Show Auth SDK when showAuth is true
                AuthSDKClass.launch(
                    config: AuthConfig() // Use default AuthConfig if you don't want to modify it
                ) { userData in
                    self.user = userData
                    self.showAuth = false  // Hide auth view after successful login
                    print("User logged in: \(userData)")
                }
```
4. **(Optional) Modify theme and colors of the SDK**
Create an AuthConfig and pass into the SDK call
```swift
   let config = AuthConfig(
    primaryColorHex: "#6200EE",
    backgroundColorHex: "#FFFFFF",
    textColorHex: "#000000",
    submitButtonText: "Register",
    showUsername: true
)

let authView = AuthSDKClass.launch(config: config) { userData in
    print("Received User: \(userData)")
}
```
5. **Use the result from the SDK as you please**
---

### 📤 Returned UserData Model

   ```swift
   public struct UserData: Codable {
    public let email: String
    public let password: String
    public let username: String?
    public let firstName: String
    public let lastName: String
   }
```
---

### 📦 Native iOS Demo App
👉🏽 You can view its implementation [here](https://github.com/EQua-Dev/AuthSDK_iOS_Demo_App) 


## 💙 Flutter Integration

### ✅ Requirements

- Flutter 3.0+
- iOS Swift support enabled in your Flutter project
- Method channel support for native communication

---

### 🛠 Setup Instructions

1. **Add SDK to your Flutter project**  
   - Drag the [.xcframework file](https://github.com/EQua-Dev/Assessment_Auth_SDK_iOS/tree/main/AuthSDK.xcframework) into the ios folder within your Flutter project (preferably under a Frameworks folder)
   - Open your Runner(or any customised name).xcworkspace in your XCode for easier integration
   - Go to the Project Navigator and under General -> Targets, locate 'Frameworks, Libraries and Embedded Content' and add the framework file there. Then select 'Sign & Embed'

2. **Configure iOS Platform Code (AppDelegate.swift or SceneDelegate.swift)**

***Import the SDK as well as SwiftUI***
```swift
import Flutter
import AuthSDK
import SwiftUI
```

***Modify your class function***
Create the channel variable
```swift
@objc class AppDelegate: FlutterAppDelegate {
    private var authChannel: FlutterMethodChannel!  //<-- Add this line at the top
```
***Setup and call the SDK class***
```swift
  authChannel = FlutterMethodChannel(name: "auth_sdk_channel", binaryMessenger: controller.binaryMessenger)

        authChannel.setMethodCallHandler { [weak self] (call, result) in
            guard let self = self else { return }

            if call.method == "launchAuthSDK" {
                guard let args = call.arguments as? [String: Any],
                      let config = args["config"] as? [String: Any] else {
                    result(FlutterError(code: "INVALID_ARGUMENTS", message: "Invalid configuration arguments", details: nil))
                    return
                }

                // Extract configuration values
                let primaryColor = config["primaryColor"] as? String ?? "#6200EE"
                let backgroundColor = config["backgroundColor"] as? String ?? "#FFFFFF"
                let textColor = config["textColor"] as? String ?? "#000000"
                let submitButtonText = config["submitButtonText"] as? String ?? "Submit"
                let showUsername = config["showUsername"] as? Bool ?? true

                // Initialize AuthConfig
                let authConfig = AuthConfig(
                    primaryColorHex: primaryColor,
                    backgroundColorHex: backgroundColor,
                    textColorHex: textColor,
                    submitButtonText: submitButtonText,
                    showUsername: showUsername
                )

                // Launch SDK with config
                let authView = AuthSDKClass.launch(config: authConfig) { userData in
                    let userMap: [String: Any] = [
                        "email": userData.email,
                        "password": userData.password,
                        "username": userData.username ?? "",
                        "firstName": userData.firstName,
                        "lastName": userData.lastName
                    ]

                    result(userMap)
                    DispatchQueue.main.async {
                          controller.presentedViewController?.dismiss(animated: true, completion: nil)
                      }
                }
```
***Present the UI View for the SDK***
```swift
  if #available(iOS 13.0, *) {
                    let hostingController = UIHostingController(rootView: authView)
                    DispatchQueue.main.async {
                        if let rootViewController = self.window?.rootViewController {
                            rootViewController.present(hostingController, animated: true, completion: nil)
                        }
                    }
                } else {
                    result(FlutterError(code: "UNSUPPORTED_IOS_VERSION", message: "iOS 13 or newer is required", details: nil))
                }
```

***Your full AppDelegate file should look like this***
```swift
import Flutter
import UIKit
import AuthSDK
import SwiftUI

@main
@objc class AppDelegate: FlutterAppDelegate {
    private var authChannel: FlutterMethodChannel!

    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        GeneratedPluginRegistrant.register(with: self)
        
        // Ensure rootViewController is a FlutterViewController
        guard let controller = window?.rootViewController as? FlutterViewController else {
            print("RootViewController is not FlutterViewController")
            return super.application(application, didFinishLaunchingWithOptions: launchOptions)
        }

        authChannel = FlutterMethodChannel(name: "auth_sdk_channel", binaryMessenger: controller.binaryMessenger)

        authChannel.setMethodCallHandler { [weak self] (call, result) in
            guard let self = self else { return }

            if call.method == "launchAuthSDK" {
                guard let args = call.arguments as? [String: Any],
                      let config = args["config"] as? [String: Any] else {
                    result(FlutterError(code: "INVALID_ARGUMENTS", message: "Invalid configuration arguments", details: nil))
                    return
                }

                // Extract configuration values
                let primaryColor = config["primaryColor"] as? String ?? "#6200EE"
                let backgroundColor = config["backgroundColor"] as? String ?? "#FFFFFF"
                let textColor = config["textColor"] as? String ?? "#000000"
                let submitButtonText = config["submitButtonText"] as? String ?? "Submit"
                let showUsername = config["showUsername"] as? Bool ?? true

                // Initialize AuthConfig
                let authConfig = AuthConfig(
                    primaryColorHex: primaryColor,
                    backgroundColorHex: backgroundColor,
                    textColorHex: textColor,
                    submitButtonText: submitButtonText,
                    showUsername: showUsername
                )

                // Launch SDK with config
                let authView = AuthSDKClass.launch(config: authConfig) { userData in

                    let userMap: [String: Any] = [
                        "email": userData.email,
                        "password": userData.password,
                        "username": userData.username ?? "",
                        "firstName": userData.firstName,
                        "lastName": userData.lastName
                    ]

                    result(userMap)
                    DispatchQueue.main.async {
                          controller.presentedViewController?.dismiss(animated: true, completion: nil)
                      }
                }

                // Present the SwiftUI view
                if #available(iOS 13.0, *) {
                    let hostingController = UIHostingController(rootView: authView)
                    DispatchQueue.main.async {
                        if let rootViewController = self.window?.rootViewController {
                            rootViewController.present(hostingController, animated: true, completion: nil)
                        }
                    }
                } else {
                    result(FlutterError(code: "UNSUPPORTED_IOS_VERSION", message: "iOS 13 or newer is required", details: nil))
                }
            } else {
                result(FlutterMethodNotImplemented)
            }
        }

        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}


```
3. **In your Flutter project, create a class to call the SDK**
```dart
import 'package:flutter/services.dart';

class AuthSDK {
  static const MethodChannel _channel = MethodChannel('auth_sdk_channel');

  static Future<Map<String, dynamic>?> launchAuthScreen({
    required String primaryColor,
    required String backgroundColor,
    required String textColor,
    String submitButtonText = 'Submit',
    bool showUsername = true,
  }) async {
    try {
      final result = await _channel.invokeMethod('launchAuthSDK', {
        'config': {
          'primaryColor': primaryColor,
          'backgroundColor': backgroundColor,
          'textColor': textColor,
          'submitButtonText': submitButtonText,
          'showUsername': showUsername,
        }
      });
      return Map<String, dynamic>.from(result);
    } on PlatformException catch (e) {
      print("Auth SDK Error: ${e.message}");
      return null;
    }
  }
}

```
4. **Call the SDK class from your widget to launch the SDK**
```dart
     @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('SDK Demo')),
      body: Center(
        child: ElevatedButton(
          child: Text("Launch Auth SDK"),
          onPressed: () async {
            final userData = await AuthSDK.launchAuthScreen(
              primaryColor: "#6200EE",
              backgroundColor: "#FFFFFF",
              textColor: "#000000",
              submitButtonText: "Register New User",
              showUsername: true,
            );

            if (userData != null) {
              print("User: $userData");
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Welcome, ${userData['firstName']}!")),
              );
            }
          },
        ),
      ),
    );
  }
}

```
---

### 📦 Flutter Demo App
👉🏽 You can view its implementation [here](https://github.com/EQua-Dev/Flutter_AuthSDK_Implementation)


## 🤖 Android Version
For Android developers, the Android version of the SDK can be found [here](https://github.com/EQua-Dev/Assessment_Auth_SDK_Android)
