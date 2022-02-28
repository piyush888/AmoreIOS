//
//  SubscriptionTypes.swift
//  Amore
//
//  Created by Kshitiz Sharma on 2/28/22.
//

import SwiftUI

struct SubscriptionTypes: View {

    @EnvironmentObject var storeManager: StoreManager
    
    var body: some View {
        
        Group {
        
            ForEach(storeManager.myProducts, id: \.self) { product in
                HStack {
                    VStack(alignment: .leading) {
                        Text(product.localizedTitle)
                            .font(.headline)
                        Text(product.localizedDescription)
                            .font(.caption2)
                    }
                    Spacer()
                    if UserDefaults.standard.bool(forKey: product.productIdentifier) {
                        Text("Purchased")
                            .foregroundColor(.green)
                    } else {
                        Button(action: {
                            storeManager.purchaseProduct(product: product)
                        }) {
                            Text("Buy for \(product.price) $")
                        }
                            .foregroundColor(.blue)
                    }
                }
        }
        
        }
    }
}

struct SubscriptionTypes_Previews: PreviewProvider {
    static var previews: some View {
        SubscriptionTypes()
    }
}
