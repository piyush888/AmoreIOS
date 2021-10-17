//
//  AmoreApp.swift
//  Amore
//
//  Created by Kshitiz Sharma on 9/20/21.
//

import SwiftUI
import Firebase
import StreamChat

@main
struct AmoreApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        
        WindowGroup {
            
            /* Starts the application with Onboarding View*/
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)

            /* View to upload photos after add school view */
//            AddPhotosView()

            /* Just see how cards will look like when swipping */
//            AllCardsView()
            
            /* Shows Location View After Pic Images Views in Onboading*/
//            LocationView()
//                .environmentObject(LocationModel())
            
            /* Home View For Integrating */
//            HomeView()
            
        }
    }
}


class AppDelegate: NSObject, UIApplicationDelegate {
    
    @AppStorage("log_Status") var logStatus = false
    @StateObject var streamObj = StreamViewModel()
    
    func application(_ application: UIApplication,
                       didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        print("SwiftUI_2_Lifecycle_PhoneNumber_AuthApp application is starting up. ApplicationDelegate didFinishLaunchingWithOptions.")
        
        if logStatus {
            guard let uid = Auth.auth().currentUser?.uid else{
                return true
            }
            self.streamObj.streamLogin(uid:uid)
        }
        
        return true
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("\(#function)")
        Auth.auth().setAPNSToken(deviceToken, type: .sandbox)
    }
      
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

// stream API...
extension ChatClient{
    static var shared: ChatClient!
}
