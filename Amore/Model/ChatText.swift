//
//  ChatMessage.swift
//  Amore
//
//  Created by Piyush Garg on 05/02/22.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

//struct FirebaseConstants {
//    static let fromId = "fromId"
//    static let toId = "toId"
//    static let text = "text"
//}
//
//struct ChatMessage: Identifiable, Codable {
//
//    var id: String { documentId }
//
//    let documentId: String
//    let fromId, toId, text: String
//
//    init(documentId: String, data: [String: Any]) {
//        self.documentId = documentId
//        self.fromId = data[FirebaseConstants.fromId] as? String ?? ""
//        self.toId = data[FirebaseConstants.toId] as? String ?? ""
//        self.text = data[FirebaseConstants.text] as? String ?? ""
//    }
//}

struct ChatText: Identifiable, Codable, Hashable {
    @DocumentID var id: String?
    var fromId: String?
    var toId: String?
    var text: String?
}
