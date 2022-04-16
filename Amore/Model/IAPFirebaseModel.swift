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
    var totalBoostCount: Int?
    var totalSuperLikesCount: Int?
    var totalMessagesCount:  Int?
    var subscriptionTypeId: String?
}

struct IAPPurcahseHistoryModel: Identifiable, Codable, Hashable {
    @DocumentID public var id: String?
    var purcahseType: String?
    var purcahseAmount: Double?
    var timeOfPurchase: Date?
    var wasPurcahseSuccessful: Bool?
    var isCosumable: Bool?
    var isSubscription: Bool?
}
