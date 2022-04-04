//
//  SubsriptionItemPricing.swift
//  Amore
//
//  Created by Kshitiz Sharma on 2/21/22.
//

// This file is not in use anywhere & will be used later for stripe integration to build market place where people who match can send each other flowers

import Foundation
import Firebase
import FirebaseFirestoreSwift
import StoreKit

// Not being used anywhere
struct StripePricings : Codable{
    var superLikesPricing : [SubscriptionItemPricing]
    var boostPricing : [SubscriptionItemPricing]
    var messagesPricing: [SubscriptionItemPricing]
    var amoreGoldPricing: [SubscriptionItemPricing]
    var amorePlatinumPricing: [SubscriptionItemPricing]
}

// Not being used anywhere
struct SubscriptionItemPricing: Identifiable, Codable, Hashable {
    var id: String
    var itemQuantity: Int
    var description: String
    var pricePerQty: Float
    var currency: String
}



