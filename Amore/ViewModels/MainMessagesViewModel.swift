//
//  MainMessagesViewModel.swift
//  Amore
//
//  Created by Piyush Garg on 03/02/22.
//

import Foundation
import SwiftUI
import Firebase
import FirebaseFirestoreSwift
import SDWebImageSwiftUI

class MainMessagesViewModel: ObservableObject {
    let db = Firestore.firestore()
    @Published var errorMessage = ""
    @Published var fromUser: ChatUser = ChatUser()
    @Published var recentChats = [ChatConversation]()
    private var firestoreListener: ListenerRegistration?
    var fetchDataObj = FetchDataModel()
    
    // All Chat Profiles
    @Published var allChatPhotos = [CardProfileWithPhotos]()
    @Published var allChatPhotos_Dict: [String: CardProfileWithPhotos] = [:]

    init() {
//        print("Chat: Init called at \(Date())")
        fetchCurrentUser()
        fetchRecentChats()
    }
    
    func updateRecentChatsFirestore(chat: ChatConversation) {
        guard let fromId = chat.fromId else {return}
        guard let toId = chat.toId else {return}
        
        if let currentUserId = Auth.auth().currentUser?.uid {
            
            let otherUserId = fromId == currentUserId ? toId : fromId
            db.collection("RecentChats")
                .document(currentUserId)
                .collection("Messages")
                .document(otherUserId).updateData(["msgRead": chat.msgRead])
        }
    }
    
    func markMessageRead(chat: ChatConversation) {
        if let index = recentChats.firstIndex(where: {$0.id == chat.id}) {
            recentChats[index].msgRead = true
            updateRecentChatsFirestore(chat: recentChats[index])
        }
    }
    
    func markMessageRead(index: Int) {
        recentChats[index].msgRead = true
        updateRecentChatsFirestore(chat: recentChats[index])
    }
    
    func returnSelectedChatIndex(chat: ChatConversation) -> Int {
        if let index = recentChats.firstIndex(where: {$0.id == chat.id}) {
            return index
        }
        else {
            return -1
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
                    
                    if (change.type == .removed) {
                        let docId = change.document.documentID
                        DispatchQueue.main.async {
                            if let index = self.recentChats.firstIndex(where: { rm in
                                return rm.id == docId
                            }) {
//                                print("Chat: Checkpoint 0.1")
                                self.recentChats.remove(at: index)
                            }
                            // Remove profile of the removed chat
                            if let index = self.allChatPhotos.firstIndex(where: { rm in
                                return rm.id == docId
                            }) {
//                                print("Chat: Checkpoint 0.2")
                                self.allChatPhotos.remove(at: index)
                                self.allChatPhotos_Dict.removeValue(forKey: docId)
                            }
                        }
                    }
                    
                    else {
                        let docId = change.document.documentID
                        DispatchQueue.main.async {
                            if let index = self.recentChats.firstIndex(where: { rm in
                                return rm.id == docId
                            }) {
//                                print("Chat: Checkpoint 1")
                                self.recentChats.remove(at: index)
                            }
                            
                            do {
                                let rm = try change.document.data(as: ChatConversation.self)
//                                print("Chat: Checkpoint 2")
                                self.recentChats.insert(rm, at: 0)
                            } catch {
                                print("Chat: Error Decoding Recent Message: \(error)")
                            }
                            // Load all chats profiles
                            self.loadAllChatProfiles(allChatUserIds: self.getAllChatProfileIds())
                        }
                    }
                    
                })
            }
    }
    
    func getAllChatProfileIds() -> [String] {
        var userIds: [String] = []
        for chat in recentChats {
            if let userId = chat.user?.id {
                userIds.append(userId)
            }
        }
        return userIds
    }
    
    func getProfile(profileId: String) -> CardProfileWithPhotos {
        return self.allChatPhotos_Dict[profileId] ?? CardProfileWithPhotos()
    }
    
    func loadAllChatProfiles(allChatUserIds: [String]) {
//        print("Chat: Fetching Chat Profiles")
        self.fetchDataObj.fetchData(apiToBeUsed: "/loadallchatprofiles",requestBody:["allChatUserIds": allChatUserIds]) {
            print("Error while loading matches profiles")
        } onSuccess: { tempData in
            _ = tempData.map{ card in
                ImageService.prefetchNextCardPhotos(card: card)
            }
            let tempResponse = self.fetchDataObj.updateCardProfilesWithPhotos(tempData:tempData)
            self.allChatPhotos = tempResponse.cardsWithPhotos
            self.allChatPhotos_Dict = tempResponse.cardsDict
        }
    }
}
