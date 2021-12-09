//
//  ProfileServices.swift
//  Amore
//
//  Created by Piyush Garg on 01/10/21.
//

import Foundation
import Firebase

class FirestoreServices {
    public static let db = Firestore.firestore()
    
    public static func storeLikesDislikes(swipedUserId: String?, swipeInfo: AllCardsView.LikeDislike) {
        var ref: DocumentReference? = nil
        var subCollection: String? {
            switch swipeInfo{
            case .like: return "Likes"
            case .dislike: return "Dislikes"
            case .none: return nil
            }
        }
        let collectionName = "LikesDislikes"
        if let swipedUserId = swipedUserId {
            if let subCollection = subCollection {
                let collectionRef = db.collection(collectionName).document(String(Auth.auth().currentUser?.uid ?? "testUser")).collection(subCollection)
                print("Document: ", collectionRef)
                ref = collectionRef.addDocument(data: ["id": swipedUserId,
                                                       "timestamp": (NSDate().timeIntervalSince1970 * 1000)
                ]) { err in
                    if let err = err {
                        print("Error adding document: \(err)")
                    } else {
                        print("Count: Document added with ID: \(ref!.documentID)")
                    }
                }
            }
        }
    }
}
