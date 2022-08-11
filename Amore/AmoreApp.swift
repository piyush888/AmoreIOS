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
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        
        WindowGroup {
            
            /* Starts the application with Onboarding View*/
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
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
        
        // APNs(Apple Push Notification) will generate and register a token when a user grants permission for push notifications. This token identifies the individual device so you can send notifications to it. You’ll use Firebase to distribute your notifications, and this code makes that token available in Firebase.
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

    // NOTE - duplicate function is commented & added to 'extension AppDelegate'
//    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
//        print("\(#function)")
//        Auth.auth().setAPNSToken(deviceToken, type: .sandbox)
//    }
      
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
    // The user notification center will call these methods when notifications arrive or when the user interacts with them. You’ll be working with them a little later.
      func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler:
        @escaping (UNNotificationPresentationOptions) -> Void
      ) {
        completionHandler([[.banner, .sound]])
      }

    // function overloading for userNotificationCenter
      func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
      ) {
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
  func messaging(
    _ messaging: Messaging,
    didReceiveRegistrationToken fcmToken: String?
  ) {
    let tokenDict = ["token": fcmToken ?? ""]
    NotificationCenter.default.post(
      name: Notification.Name("FCMToken"),
      object: nil,
      userInfo: tokenDict)
  }
}

extension UINavigationController {

  open override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    navigationBar.topItem?.backButtonDisplayMode = .minimal
  }

}
