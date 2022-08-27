//
//  IAPFirebase.swift
//  Amore
//
//  Created by Kshitiz Sharma on 3/18/22.
//  This file is used to update the

import Foundation
import Firebase
import FirebaseFirestoreSwift

struct ConsumableCountAndSubscriptionModel: Identifiable, Codable, Hashable {
    @DocumentID public var id: String?
    var purchasedBoostCount: Int?
    var purchasedSuperLikesCount: Int?
    var purchasedMessagesCount: Int?
    var subscriptonBoostCount: Int?
    var subscriptionSuperLikeCount: Int?
    var subscriptionMessageCount:  Int?
    var subscriptionTypeId: String?
    var subscriptionUpdateDateTime: Date?
}

