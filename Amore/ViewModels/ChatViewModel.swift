//
//  ChatModel.swift
//  Amore
//
//  Created by Piyush Garg on 04/02/22.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift
import GiphyUISDK

class ChatViewModel: ObservableObject {
    let db = Firestore.firestore()
    var errorMessage = ""
    @Published var chatText = ""
    @Published var chatMessages = [ChatModel]()
    @Published var sectionedMessages = [[ChatModel]]()
    @Published var count = 0
    @Published var chatDocuments: [DocumentSnapshot] = []
    var giphyId: String = ""
    var lastSnapshot: DocumentSnapshot?
    var firestoreListener: ListenerRegistration?
    var fetchMoreFirestoreListener: ListenerRegistration?
    var chatMessageIndex: [String: ChatModel] = [String: ChatModel]()

    /**
     Function to write each text message from chat to the Messages Collection in firestore for the current user.
     
     Parameters:
        - fromUser: User info for the 'From' user
        - toUser: User info for the 'To' user
        - directMessage: Boolean signifying whether the message is being sent from the Direct Message popup
     
     Returns: None
     */
    func handleSend(fromUser: ChatUser, toUser: ChatUser, directMessage: Bool, type:String) {
        
        guard let fromId = Auth.auth().currentUser?.uid else { return }
        guard let toId = toUser.id else { return }
        var payLoad = ChatModel()
        // Check if message send request is a normal text or a GIF
        switch type {
            
            case "text":
                chatText = chatText.trimmingCharacters(in: .whitespaces)
                chatText = chatText.trimmingCharacters(in: .newlines)
                if chatText.isEmpty {return}
                // Save the text message with Sender's ID
                payLoad = ChatModel(fromId: fromId,
                                        toId: toId,
                                        text: chatText,
                                        timestamp: Date(),
                                        type:type)
            case "giphy":
                if self.giphyId == "" {return}
                // Save the gif id with message with Sender's ID
                payLoad = ChatModel(fromId: fromId,
                                        toId: toId,
                                        timestamp: Date(),
                                        type:type,
                                        giphyId: self.giphyId)
                
            default:
                print("Error in handling a messagae send request \(type)")
        }
        
        // Store payload in firestore
        do {
            _ = try db.collection("Messages")
                .document(fromId)
                .collection(toId)
                .document().setData(from: payLoad) { error in
                        if let error = error {
                            print("Chat: \(error)")
                            self.errorMessage = "Failed to save message into Firestore: \(error)"
                            return
                        }
                            
                    self.persistRecentMessage(fromUser: fromUser, toUser: toUser, directMessage: directMessage, type:type)
                        print("Chat: Successfully saved current user sending message")
                        self.chatText = ""
                        self.count += 1
                    print("Chat: Checkpoint 6")
                }
        }
        catch {
            print("Chat: \(error)")
        }
        
    }
    
    /**
     Check whether pagination is needed.
     If second last message has appeared, fetch next page of messagesr
     - Parameter:
        - message: ChatModel for the current message in view

     - Returns: Boolean indicating pagination needed or not
     */
    func shouldFetchMoreMessages(message: ChatModel) -> Bool {
        guard chatDocuments.count > 2 && message.id == chatDocuments[chatDocuments.index(chatDocuments.endIndex, offsetBy: -2)].documentID else { return false }
        return true
    }
    
    /**
     Fetch next page of chat messages.
     Uses separate firestore listener than initial fetcher.
     Fetches next 25 messages from last document.
     - Parameter:
        - toUser: ChatUser: other user in the conversation
     */
    func fetchMoreMessages(toUser: ChatUser) {
        guard let fromId = Auth.auth().currentUser?.uid else { return }
        guard let toId = toUser.id else { return }
        guard let lastSnapshot = lastSnapshot else {
            return
        }
        let fetchMoreQuery = db.collection("Messages")
            .document(fromId)
            .collection(toId)
            .order(by: "timestamp", descending: true)
            .limit(to: 25)
            .start(afterDocument: lastSnapshot)
        fetchMoreFirestoreListener?.remove()
        fetchMoreFirestoreListener = fetchMoreQuery
            .addSnapshotListener { querySnapshot, error in
                if let error = error {
                    self.errorMessage = "Failed to listen for messages: \(error)"
                    print("Chat: \(error)")
                    return
                }

                querySnapshot?.documentChanges.forEach({ change in
                    if change.type == .added {
                        do {
                            let data = try change.document.data(as: ChatModel.self)
                            DispatchQueue.main.async {
                                
                                if let chatID = data.id {
                                    if self.chatMessageIndex[chatID] == nil {
                                        self.chatMessages.append(data)
                                        self.chatMessageIndex[chatID] = data
                                    }
                                }
//                                self.chatMessages.append(data)
                                print("Chat: Paginating chatMessage in ChatLogView: \(Date())")
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
                    guard let documents = querySnapshot?.documents, error == nil else { return }
                    self.chatDocuments += documents
                    if let lastDoc = querySnapshot?.documents.last {
                        self.lastSnapshot = lastDoc
                    }
                }
            }
    }
    
    /**
     Fetch and listen on first batch of 25 messages.
     Uses separate firestore listener than pagination fetcher.
     - Parameter:
        - toUser: ChatUser: other user in the conversation
     */
    func fetchMessages(toUser: ChatUser) {
        guard let fromId = Auth.auth().currentUser?.uid else { return }
        guard let toId = toUser.id else { return }
        firestoreListener?.remove()
        chatMessages.removeAll()
        chatMessageIndex.removeAll()
        firestoreListener = db.collection("Messages")
            .document(fromId)
            .collection(toId)
            .order(by: "timestamp", descending: true)
            .limit(to: 25)
            .addSnapshotListener { querySnapshot, error in
                if let error = error {
                    self.errorMessage = "Failed to listen for messages: \(error)"
                    print("Chat: \(error)")
                    return
                }
                
                guard let querySnapshot = querySnapshot else {
                    print("Error retreving chats: \(error.debugDescription)")
                    return
                }
                
                querySnapshot.documentChanges.forEach({ change in
                    if change.type == .added {
                        do {
                            let data = try change.document.data(as: ChatModel.self)
                            DispatchQueue.main.async {
                                if let chatID = data.id {
                                    if self.chatMessageIndex[chatID] == nil {
                                        self.chatMessages.append(data)
                                        self.chatMessageIndex[chatID] = data
                                    }
                                }
//                                self.chatMessages.append(data)
                                print("Chat: Appending chatMessage in ChatLogView: \(Date())")
                                print("Chat: Checkpoint 4")
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
                    self.chatDocuments += querySnapshot.documents
                    if let lastDoc = querySnapshot.documents.last {
                        self.lastSnapshot = lastDoc
                    }
                }
            }
    }
    
    /**
     Function to write last text message to Recent Chats collection of the current user.
     
     Parameters:
        - fromUser: User info for the 'From' user
        - toUser: User info for the 'To' user
        - directMessage: Boolean signifying whether the message is being sent from the Direct Message popup
     
     Returns: None
     */
    private func persistRecentMessage(fromUser: ChatUser, toUser: ChatUser, directMessage: Bool, type:String) {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let toId = toUser.id else { return }
        var lastText = ""
        
        switch type {
            case "text":
                lastText = self.chatText
            
            case "giphy":
                lastText = "Media"
            
            default:
                lastText = self.chatText
        }
        
        let senderData = ChatConversation(fromId: uid,
                                          toId: toId,
                                          user: toUser,
                                          lastText: lastText,
                                          timestamp: Date(),
                                          directMessageApproved: !directMessage)
        
        
        do {
            // Write to recent chats the data of the messages
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
            
            // Raise the flag for recent chat
            db.collection("RecentChats")
                .document(uid)
                .setData(["wasUpdated": true]) { error in
                if let error = error {
                    self.errorMessage = "Failed to save recent message: \(error)"
                    print("Chat: Failed to save recent message: \(error)")
                    return
                }
            }
            
        }
        catch {
            print("Chat: \(error)")
            return
        }
        
    }
    
    func getSectionedMessages(for messages: [ChatModel]) {
        DispatchQueue.main.async {
            self.sectionedMessages.removeAll()
            var messagesForDate = [ChatModel]()
            for message in messages {
                if let firstMessage = messagesForDate.first, let firstMessageTimestamp = firstMessage.timestamp {
                    let daysBetween = firstMessageTimestamp.daysBetween(date: message.timestamp ?? Date())
                    if -daysBetween >= 1 {
                        self.sectionedMessages.append(messagesForDate)
                        messagesForDate.removeAll()
                        messagesForDate.append(message)
                    }
                    else {
                        messagesForDate.append(message)
                    }
                }
                else {
                    messagesForDate.append(message)
                }
            }
            self.sectionedMessages.append(messagesForDate)
        }
        
    }
    
}
