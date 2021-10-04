//
//  ProfileViewModel.swift
//  Amore
//
//  Created by Piyush Garg on 01/10/21.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

class ProfileViewModel: ObservableObject {
    var userProfile = Profile()
    let db = Firestore.firestore()
    
    func createUserProfile() -> Bool {
        // Example implementation, Firestore Write Implementation
        let collectionRef = db.collection("Profiles")
        if let id = userProfile.id {
            do {
                let newDocReference = try collectionRef.document(id).setData(from: userProfile)
                print("Profile stored with new document reference: \(newDocReference)")
                return true
            }
            catch let error {
                print("Error writing document to Firestore: \(error)")
            }
        }
        else{
            print("No user uid")
        }
        return false
    }
    
    func getUserProfile() {
        // Example function, Firestore Read Implementation
        let collectionRef = db.collection("Profiles")
        if let documentId = UserDefaults.standard.string(forKey: "userUID") {
            let docRef = collectionRef.document(documentId)
            
            docRef.getDocument { document, error in
                if let error = error as NSError? {
                    print("Error getting document: \(error.localizedDescription)")
                }
                else {
                    if let document = document {
                        do {
                            self.userProfile = try document.data(as: Profile.self) ?? Profile()
                        }
                        catch {
                            print(error)
                        }
                    }
                }
                
            }
        }
    }
}
