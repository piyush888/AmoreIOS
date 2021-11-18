//
//  AmoreApp.swift
//  Amore
//
//  Created by Kshitiz Sharma on 9/20/21.
//

import SwiftUI
import Firebase
import StreamChat
import JWTKit

@main
struct AmoreApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        
        WindowGroup {
            
            MoreInfoForBetterMatch()
            /* Starts the application with Onboarding View*/
//            ContentView()
//                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}


class AppDelegate: NSObject, UIApplicationDelegate {
    
    @AppStorage("log_Status") var logStatus = false
    
    func application(_ application: UIApplication,
                       didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        
        // Stream Chat SDK
        // if user already logged in...
        if logStatus {
            // Reloading user if logged in...
            // Verifying if user is already in stream SDk or Not...
            // for that we need to intialize the stream sdk with JWT Tokens...
            // AKA known as Authenticatiog with stream SDK....
            // generating JWT Token...
            let signers = JWTSigners()
            signers.use(.hs256(key: streamSecretKey.data(using: .utf8)!))
            
            // Creating Payload and inserting Userd ID to generate Token..
            // Here User ID will be Firebase UID....
            // Since its Unique...
            guard let uid = Auth.auth().currentUser?.uid else{
                return true
            }
            let payload = PayLoad(user_id: uid)
            // generating Token...
            do{
                let jwt = try signers.sign(payload)
                let config = ChatClientConfig(apiKeyString: streamAPIKey)
                let tokenProvider = TokenProvider.closure { client, completion in
                    guard let token = try? Token(rawValue: jwt) else{
                        return
                    }
                    completion(.success(token))
                }
                ChatClient.shared = ChatClient(config: config, tokenProvider: tokenProvider)
                ChatClient.shared.currentUserController().reloadUserIfNeeded()
            }
            catch{
                print(error.localizedDescription)
            }
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
