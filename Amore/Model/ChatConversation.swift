//
//  ChatConversation.swift
//  Amore
//
//  Created by Piyush Garg on 05/02/22.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

struct ChatConversation: Identifiable, Codable {
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
}
