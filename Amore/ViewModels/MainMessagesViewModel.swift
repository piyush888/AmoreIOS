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
        print("Chat: Init called at \(Date())")
        fetchCurrentUser()
        fetchRecentChats()
    }
    
    func updateRecentChatsFirestore(chat: ChatConversation) {
        guard let fromId = chat.fromId else {return}
        guard let toId = chat.toId else {return}
        
        db.collection("RecentChats")
            .document(fromId)
            .collection("Messages")
            .document(toId).updateData(["msgRead": chat.msgRead])
        
        db.collection("RecentChats")
            .document(toId)
            .collection("Messages")
            .document(fromId).updateData(["msgRead": chat.msgRead])
    }
    
    func markMessageRead(chat: ChatConversation) {
        if let index = recentChats.firstIndex(where: {$0.id == chat.id}) {
            recentChats[index].msgRead = true
            updateRecentChatsFirestore(chat: recentChats[index])
        }
    }

    private func fetchCurrentUser() {

        guard let uid = Auth.auth().currentUser?.uid else {
            self.errorMessage = "Could not find firebase uid"
            return
        }

        db.collection("Profiles").document(uid).getDocument { [self] snapshot, error in
            if let error = error {
                self.errorMessage = "Failed to fetch current user: \(error)"
                print("Chat: Failed to fetch current user:", error)
                return
            }
            
            if let snapshot = snapshot {
                do {
                    self.fromUser = try snapshot.data(as: ChatUser.self) ?? ChatUser()
                    self.fromUser.id = Auth.auth().currentUser?.uid
                }
                catch {
                    print("Chat: Error in decoding: \(error)")
                }
            }
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
                    
                    DispatchQueue.main.async {
                        if let index = self.recentChats.firstIndex(where: { rm in
                            return rm.id == docId
                        }) {
                            print("Chat: Checkpoint 1")
                            self.recentChats.remove(at: index)
                        }
                        
                        do {
                            if let rm = try change.document.data(as: ChatConversation.self) {
                                print("Chat: Checkpoint 2")
                                self.recentChats.insert(rm, at: 0)
                            }
                        } catch {
                            print("Chat: \(error)")
                        }
                    }
                })
            }
    }
    

}
