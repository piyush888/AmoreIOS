//
//  SubsriptionItemPricing.swift
//  Amore
//
//  Created by Kshitiz Sharma on 2/21/22.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift
import StoreKit

struct StripePricings : Codable{
    var superLikesPricing : [SubscriptionItemPricing]
    var boostPricing : [SubscriptionItemPricing]
    var messagesPricing: [SubscriptionItemPricing]
    var amoreGoldPricing: [SubscriptionItemPricing]
    var amorePlatinumPricing: [SubscriptionItemPricing]
}

struct SubscriptionItemPricing: Identifiable, Codable, Hashable {
    var id: String
    var itemQuantity: Int
    var description: String
    var pricePerQty: Float
    var currency: String
}



