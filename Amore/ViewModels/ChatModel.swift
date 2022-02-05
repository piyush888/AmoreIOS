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
//    @Published var toUser = ChatUser()
    @Published var toUser: ChatUser = ChatUser()
//    var chatText: String = ""
    @Published var chatMessages = [ChatText]()

    func handleSend() {
        guard let chatText = self.toUser.latestMessage else {
            return
        }
        if chatText.isEmpty {
            return
        }

        print(chatText)
        guard let fromId = Auth.auth().currentUser?.uid else { return }

        guard let toId = toUser.id else { return }

        let document = db.collection("messages")
            .document(fromId)
            .collection(toId)
            .document()

        let messageData = ["fromId": fromId, "toId": toId, "text": chatText, "timestamp": Timestamp()] as [String : Any]

        document.setData(messageData) { error in
            if let error = error {
                print(error)
                self.errorMessage = "Failed to save message into Firestore: \(error)"
                return
            }

            print("Successfully saved current user sending message")
//            chatText = ""
        }

        let recipientMessageDocument = db.collection("messages")
            .document(toId)
            .collection(fromId)
            .document()

        recipientMessageDocument.setData(messageData) { error in
            if let error = error {
                print(error)
                self.errorMessage = "Failed to save message into Firestore: \(error)"
                return
            }

            print("Recipient saved message as well")
        }
    }
    
    func fetchMessages() {
        guard let fromId = Auth.auth().currentUser?.uid else { return }
        guard let toId = toUser.id else { return }
        db.collection("messages")
            .document(fromId)
            .collection(toId)
            .order(by: "timestamp")
            .addSnapshotListener { querySnapshot, error in
                if let error = error {
                    self.errorMessage = "Failed to listen for messages: \(error)"
                    print(error)
                    return
                }

                querySnapshot?.documentChanges.forEach({ change in
                    if change.type == .added {
                        do {
                            let data = try change.document.data(as: ChatText.self) ?? ChatText()
    //                        let data = change.document.data()
                            self.chatMessages.append(data)
                        }
                        catch {
                            print("Error parsing fetched messages.")
                            print(error)
                        }
                    }
                })
            }
    }
    
    
}
