//
//  AmoreApp.swift
//  Amore
//
//  Created by Kshitiz Sharma on 9/20/21.
//

import SwiftUI
import Firebase
import FirebaseMessaging
import JWTKit

@main
struct AmoreApp: App {
//    
    // Makes SwiftUI aware of the newly created app delegate(AppDelegate)
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        
        WindowGroup {
            
            /* Starts the application with Onboarding View*/
            ContentView()
        }
    }
}


class AppDelegate: NSObject, UIApplicationDelegate {
    
    func application(_ application: UIApplication,
                       didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        // 1 - Configures app to work with Firebase.
        FirebaseApp.configure()
        // 2 - Sets how much Firebase will log. Setting this to min reduces the amount of data you’ll see in your debugger.
        FirebaseConfiguration.shared.setLoggerLevel(.min)
        
        // APNs(Apple Push Notification) will generate and register a token when a user grants permission for push notifications. This token identifies the individual device so you can send notifications to it. You’ll use Firebase to distribute your notifications, and this code makes that token available in Firebase. Which is further pushed to Apple's Push Notification used to push a notification to iOS device
        // 3 - Sets AppDelegate as the delegate for UNUserNotificationCenter. The necessary delegate methods is implemented on step 3.2
        UNUserNotificationCenter.current().delegate = self
        // 4 - Creates options related to what kind of push notification permissions your app will request. In this case, you’re asking for alerts, badges and sound.
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
          options: authOptions) { _, _ in }
        // 5 - Registers your app for remote notifications.
        application.registerForRemoteNotifications()
        
        // 7 - sets AppDelegate as the delegate for Messaging
        Messaging.messaging().delegate = self
        
        UINavigationBar.appearance().scrollEdgeAppearance = UINavigationBarAppearance()
        return true
    }
    
    // Silent Push Notification
    func application(_ application: UIApplication, didReceiveRemoteNotification notification: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print("\(#function)")
        if Auth.auth().canHandleNotification(notification) {
          completionHandler(.noData)
          return
        }
    }
      
    func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
        print("\(#function)")
        if Auth.auth().canHandle(url) {
          return true
        }
        return false
    }
}

// Since you’re not letting Firebase automatically handle notification code through swizzling(FirebaseAppDelegateProxyEnabled is set to 0 in Info config), you’ll need to conform to UNUserNotificationCenterDelegate.
extension AppDelegate: UNUserNotificationCenterDelegate {
    
    // User notification setting are in the Amore > Signing & Capabilities
    
      func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler:
        @escaping (UNNotificationPresentationOptions) -> Void
      ) {
          // This method is called when a notification is about to be displayed to the user.
          // You can use this method to customize the way the notification is displayed, or to prevent it from being shown at all.
//          UNUserNotificationCenter.setBadgeCount(1)
          completionHandler([.badge, .sound])
      }

    // Function overloading for userNotificationCenter
      func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
      ) {
          // This method is called when a notification has been received and the app is running in the foreground.
          // You can use this method to take appropriate action based on the notification's content.
          
          switch response.actionIdentifier {
            case UNNotificationDefaultActionIdentifier:
              // Handle the user tapping on the notification
              let userInfo = response.notification.request.content.userInfo
              let notificationCategory = response.notification.request.content.categoryIdentifier
              
              // Use the userInfo dictionary to update your app's UI or perform some other action
              if notificationCategory == "Match" {
                    print(userInfo["analytics_label"])
              } else if notificationCategory == "Message" {
                  print(userInfo["analytics_label"])
              }
              break
              
            case UNNotificationDismissActionIdentifier:
                // Handle the user dismissing the notification
                break
                      
            default:
              break
          }
          
        completionHandler()
      }
     
      // Once firebase is configured, we can start registering to receive notifications
      // step 3.2
      func application(
        _ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
        ) {
            print("\(#function)")
            
            Auth.auth().setAPNSToken(deviceToken, type: .sandbox)
            Messaging.messaging().apnsToken = deviceToken
        }
    
        func application(_ application: UIApplication,
                         didFailToRegisterForRemoteNotificationsWithError error: Error) {
          print("Unable to register for remote notifications: \(error.localizedDescription)")
        }

}


// 6 - Messaging is Firebase’s class that manages everything related to push notifications. Like a lot of iOS APIs, it features a delegate called MessagingDelegate, which you implement in the code above. Whenever your app starts up or Firebase updates your token, Firebase will call the method you just added to keep the app in sync with it.
extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        let tokenDict = ["token": fcmToken ?? ""]
        NotificationCenter.default.post(
          name: Notification.Name("FCMToken"),
          object: nil,
          userInfo: tokenDict)
        
        UserDefaults.standard.set(fcmToken ?? "", forKey: "FCMToken")
    }
}

extension UINavigationController {

  open override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    navigationBar.topItem?.backButtonDisplayMode = .minimal
  }

}
