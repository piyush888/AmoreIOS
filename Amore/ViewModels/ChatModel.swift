//
//  ChatModel.swift
//  Amore
//
//  Created by Piyush Garg on 04/02/22.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

class ChatModel: ObservableObject {
    let db = Firestore.firestore()
    var errorMessage = ""
    @Published var chatText = ""
    @Published var chatMessages = [ChatText]()
    @Published var count = 0
    var firestoreListener: ListenerRegistration?

    func handleSend(fromUser: ChatUser, toUser: ChatUser) {
        if chatText.isEmpty {
            return
        }
        chatText = chatText.trimmingCharacters(in: .whitespacesAndNewlines)
        print("Chat: Checkpoint 3")
        print("Chat: "+chatText)
        guard let fromId = Auth.auth().currentUser?.uid else { return }

        guard let toId = toUser.id else { return }
        
        // Save the text message with Sender's ID

        let messageData = ChatText(fromId: fromId, toId: toId, text: chatText, timestamp: Date())

        do {
            _ = try db.collection("Messages")
                .document(fromId)
                .collection(toId)
                .document().setData(from: messageData) { error in
                        if let error = error {
                            print("Chat: \(error)")
                            self.errorMessage = "Failed to save message into Firestore: \(error)"
                            return
                        }
                            
                        self.persistRecentMessage(fromUser: fromUser, toUser: toUser)
                        print("Chat: Successfully saved current user sending message")
                        self.chatText = ""
                        self.count += 1
                    print("Chat: Checkpoint 6")
                }
        }
        catch {
            print("Chat: \(error)")
        }
        
        // Save the same text message with Receiver's ID also
        
        do {
            _ = try db.collection("Messages")
                .document(toId)
                .collection(fromId)
                .document().setData(from: messageData) { error in
                    if let error = error {
                        print("Chat: \(error)")
                        self.errorMessage = "Failed to save message into Firestore: \(error)"
                        return
                    }

                    print("Chat: Recipient saved message as well")
                }
        }
        catch {
            print("Chat: \(error)")
        }
        
    }
    
    func fetchMessages(toUser: ChatUser) {
        guard let fromId = Auth.auth().currentUser?.uid else { return }
        guard let toId = toUser.id else { return }
        firestoreListener?.remove()
        chatMessages.removeAll()
        firestoreListener = db.collection("Messages")
            .document(fromId)
            .collection(toId)
            .order(by: "timestamp")
            .addSnapshotListener { querySnapshot, error in
                if let error = error {
                    self.errorMessage = "Failed to listen for messages: \(error)"
                    print("Chat: \(error)")
                    return
                }

                querySnapshot?.documentChanges.forEach({ change in
                    if change.type == .added {
                        do {
                            if let data = try change.document.data(as: ChatText.self) {
                                DispatchQueue.main.async {
                                    self.chatMessages.append(data)
                                    print("Chat: Appending chatMessage in ChatLogView: \(Date())")
                                    print("Chat: Checkpoint 4")
                                }
//                                self.chatMessages.append(data)
//                                print("Appending chatMessage in ChatLogView: \(Date())")
                            }
                        }
                        catch {
                            print("Chat: Error parsing fetched messages.")
                            print("Chat: \(error)")
                        }
                    }
                })
                DispatchQueue.main.async {
                    self.count += 1
                    print("Chat: Checkpoint 5")
                }
            }
    }
    
    private func persistRecentMessage(fromUser: ChatUser, toUser: ChatUser) {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let toId = toUser.id else { return }

        let senderData = ChatConversation(fromId: uid, toId: toId, user: toUser, lastText: self.chatText, timestamp: Date())
        
        do {
            _ = try db.collection("RecentChats")
                .document(uid)
                .collection("Messages")
                .document(toId).setData(from: senderData) { error in
                if let error = error {
                    self.errorMessage = "Failed to save recent message: \(error)"
                    print("Chat: Failed to save recent message: \(error)")
                    return
                }
            }
        }
        catch {
            print("Chat: \(error)")
        }
        
        let recipientData = ChatConversation(fromId: uid, toId: toId, user: fromUser, lastText: self.chatText, timestamp: Date())
        
        do {
            _ = try db.collection("RecentChats")
                .document(toId)
                .collection("Messages")
                .document(uid)
                .setData(from: recipientData) { error in
                    if let error = error {
                        print("Chat: Failed to save recipient recent message: \(error)")
                        return
                    }
                }
        }
        catch {
            print("Chat: \(error)")
        }
        
    }
    
}