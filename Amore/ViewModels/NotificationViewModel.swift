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
                    
                    let docref = db.collection("FCMTokens").document(profileId)
                    let fcmPayLoad:[String:Any] = ["fcmToken":UserDefaults.standard.string(forKey: "FCMToken"),
                                                   "deviceType":"iOS",
                                                   "timestamp":Date()]
                    
                    _ = try docref.collection("Devices").document(deviceToken).setData(fcmPayLoad, merge: true) { error in
                        if let error = error {
                            print("\(error)")
                        } else {
                            docref.setData(["wasUpdated": true])
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
    
    
    func deleteFCMTokenFromFirestore() {
        if let profileId = Auth.auth().currentUser?.uid {
            do {
                if let deviceToken = UIDevice.current.identifierForVendor?.uuidString {
                    let docRef = db.collection("FCMTokens").document(profileId)
                    docRef.collection("Devices").document(deviceToken).delete { error in
                        if let error = error {
                            print("Error deleting FCM token: \(error)")
                        } else {
                            print("FCMtoken deleted successfully")
                            docRef.setData(["wasUpdated": true])
                        }
                    }
                }
            } catch let error {
                print("Error deleting FCM token: \(error.localizedDescription)")
            }
        }
    }
    
}



