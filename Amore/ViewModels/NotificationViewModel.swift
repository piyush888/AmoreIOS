//
//  NotificationViewModel.swift
//  Amore
//
//  Created by Kshitiz Sharma on 11/26/22.
//

import SwiftUI
import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift



class NotificatonViewModel: ObservableObject {
        
    // Alert....
    @Published var showAlert = false
    @Published var errorMsg = ""
    
    let db = Firestore.firestore()
        
    func storeFCMTokenFirestore(completion: (() -> Void)? = nil) {
        // Get the fcm token from firestore
        // Get the FCM Token for
        // Compare the fcm token with the current generated token
        if let profileId = Auth.auth().currentUser?.uid {
            do {
                if let deviceToken =  UIDevice.current.identifierForVendor?.uuidString {
                    let docref = db.collection("FCMTokens").document(deviceToken)
                    let fcmPayLoad:[String:Any] = ["userId":profileId,
                                                   "fcmToken":UserDefaults.standard.string(forKey: "FCMToken"),
                                                   "deviceType":"iOS",
                                                   "timestamp":Date()]
                    
                    _ = try docref.setData(fcmPayLoad, merge: true) { error in
                        if let error = error {
                            print("FCMToken Storage:\(error)")
                        } else {
                            print("FCMToken was updated in firestore")
                        }
                    }
                }
            }
            catch let error {
                print("Not able to store the FCM token in firestore")
                print(error.localizedDescription)
            }
        }
    }
    
    
    func deleteFCMTokenFromFirestore(completion: (() -> Void)? = nil) {
        if let deviceId = UIDevice.current.identifierForVendor?.uuidString {
            let docRef = db.collection("FCMTokens").document(deviceId)
            docRef.getDocument { (document, error) in
                if let document = document, document.exists, let userId = document.get("userId") as? String, userId == Auth.auth().currentUser?.uid {
                    docRef.delete { error in
                        if let error = error {
                            print("Error deleting FCMToken: \(error.localizedDescription)")
                        } else {
                            print("FCMToken deleted successfully")
                            // Call the completion handler if it exists
                            completion?()
                        }
                    }
                } else if let error = error {
                    print("Error deleting FCMToken: \(error.localizedDescription)")
                    completion?()
                } else {
                    print("No matching FCMToken found")
                    completion?()
                }
            }
        }
    }
    
}



