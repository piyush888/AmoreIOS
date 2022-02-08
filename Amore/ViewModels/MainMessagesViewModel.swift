//
//  MainMessagesViewModel.swift
//  Amore
//
//  Created by Piyush Garg on 03/02/22.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift
import SDWebImageSwiftUI

class MainMessagesViewModel: ObservableObject {
    let db = Firestore.firestore()
    @Published var errorMessage = ""
    @Published var fromUser: ChatUser = ChatUser()
    @Published var recentChats = [ChatConversation]()
    private var firestoreListener: ListenerRegistration?

    init() {
        fetchCurrentUser()
        fetchRecentChats()
    }

    private func fetchCurrentUser() {

        guard let uid = Auth.auth().currentUser?.uid else {
            self.errorMessage = "Could not find firebase uid"
            return
        }

        db.collection("Profiles").document(uid).getDocument { snapshot, error in
            if let error = error {
                self.errorMessage = "Failed to fetch current user: \(error)"
                print("Chat: Failed to fetch current user:", error)
                return
            }

            guard let data = snapshot?.data() else {
                self.errorMessage = "No data found"
                return

            }
            let id = Auth.auth().currentUser?.uid
            let fname = data["firstName"] as? String ?? ""
            let lname = data["lastName"] as? String ?? ""
            let profileImage = data["image1"] as? ProfileImage ?? ProfileImage()
            self.fromUser = ChatUser(id: id, firstName: fname, lastName: lname, image1: profileImage)
        }
    }
    
    func fetchRecentChats() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        firestoreListener?.remove()
        self.recentChats.removeAll()
        firestoreListener = db
            .collection("RecentChats")
            .document(uid)
            .collection("Messages")
            .order(by: "timestamp")
            .addSnapshotListener { querySnapshot, error in
                if let error = error {
                    self.errorMessage = "Failed to listen for recent messages: \(error)"
                    print("Chat: \(error)")
                    return
                }
                
                querySnapshot?.documentChanges.forEach({ change in
                    let docId = change.document.documentID
                    
                    if let index = self.recentChats.firstIndex(where: { rm in
                        return rm.id == docId
                    }) {
                        DispatchQueue.main.async {
                            self.recentChats.remove(at: index)
                        }
                        print("Chat: Checkpoint 1")
//                        self.recentChats.remove(at: index)
                    }
                    
                    do {
                        if let rm = try change.document.data(as: ChatConversation.self) {
                            DispatchQueue.main.async {
                                self.recentChats.insert(rm, at: 0)
                            }
                            print("Chat: Checkpoint 2")
//                            self.recentChats.insert(rm, at: 0)
                        }
                    } catch {
                        print("Chat: \(error)")
                    }
                })
            }
    }
    

}
