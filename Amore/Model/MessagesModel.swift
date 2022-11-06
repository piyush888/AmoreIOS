//
//  ChatMessage.swift
//  Amore
//
//  Created by Piyush Garg on 05/02/22.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

struct ChatModel: Identifiable, Codable, Hashable {
    @DocumentID var id: String?
    var fromId: String?
    var toId: String?
    var text: String?
    var timestamp: Date?
    var otherUserUpdated: Bool? = false
    var type: String? = "text"
    var giphyId: String?
}

/* Model for chatting with users. Need for rendering 2nd party messages */
struct ChatUser: Identifiable, Codable, Equatable, Hashable {
    var id: String?
    var firstName: String?
    var lastName: String?
    var image1: ProfileImage?
}

/**
 Data model used for Recent Chats collection in firestore for last text message sent between two users.
 */
struct ChatConversation: Identifiable, Codable, Hashable {
    @DocumentID var id: String?
    var fromId: String?
    var toId: String?
    var user: ChatUser?
    var lastText: String?
    var timestamp: Date?
    var timeAgo: String {
        guard let timestamp = timestamp else {
            return ""
        }
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: timestamp, relativeTo: Date())
    }
    var msgRead: Bool? = false
    var otherUserUpdated: Bool? = false
    var directMessageApproved: Bool = true
}

