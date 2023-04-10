//
//  BuyMoreSuperLikesSheet.swift
//  Amore
//
//  Created by Kshitiz Sharma on 8/27/22.
//

import SwiftUI
import StoreKit


struct BuyMoreSuperLikesSheet: View {
    
    @Binding var allcardsActiveSheet: AllCardsActiveSheet?
    @EnvironmentObject var storeManager: StoreManager
    
    var totalSuperCount: Int {
        let purchasedSuperLikesCount =  self.storeManager.purchaseDataDetails.purchasedSuperLikesCount ?? 0
        let subscriptionSuperLikeCount =  self.storeManager.purchaseDataDetails.subscriptionSuperLikeCount ?? 0
        return purchasedSuperLikesCount+subscriptionSuperLikeCount
    }
    
    var body: some View {
        
        GeometryReader { geometry in
            
            ZStack {
                // background images full of shirt
                sheetBackgrounColor

                VStack {
                    // Done button to close the sheet
                    collapseSheet
                    
                    // Super like sheet description
                    sheetDescription
                        .padding(.bottom,50)
                    
                    // Buy Superlikes consumables
                    let pricingData = storeManager.superLikesPricing
                        // TODO: Change the name of common class to something more generic from BoostBuyButton to CommonBuyButton - Ktz
                        
                    Text("Most popular")
                    SuperLikeBuyButton(superLikeCount:5,
                                   totalCost: Float(truncating: pricingData["5 Super Likes"]?.price ?? 0.0),
                                   currency: pricingData["5 Super Likes"]?.localizedPrice?.first ?? "$",
                                   skProductObj: pricingData["5 Super Likes"] ?? SKProduct())
                        .frame(width: geometry.size.width*0.80)
                        .environmentObject(storeManager)
                        .padding(.bottom,5)
                    
                    
                    Text("Best Value")
                    SuperLikeBuyButton(superLikeCount:15,
                                   totalCost: Float(truncating: pricingData["15 Super Likes"]?.price ?? 0.0),
                                   currency: pricingData["15 Super Likes"]?.localizedPrice?.first ?? "$",
                                   skProductObj: pricingData["15 Super Likes"] ?? SKProduct())
                        .frame(width: geometry.size.width*0.80)
                        .environmentObject(storeManager)
                        .padding(.bottom,5)
                

                    SuperLikeBuyButton(superLikeCount:30,
                                   totalCost: Float(truncating: pricingData["30 Super Likes"]?.price ?? 0.0),
                                   currency: pricingData["30 Super Likes"]?.localizedPrice?.first ?? "$",
                                   skProductObj: pricingData["30 Super Likes"] ?? SKProduct())
                        .frame(width: geometry.size.width*0.80)
                        .environmentObject(storeManager)
                
                    
                    Spacer()
                }
            }
        }
        .padding(.horizontal)
    }
    
    // Text base description of the super likes count
    var sheetDescription: some View {
        VStack(spacing: 16) {
            
            Image(systemName: "star.circle.fill")
                .resizable()
                .frame(width:50, height:50)
                .foregroundColor(Color("gold-star"))
            
            Text("You've \(totalSuperCount) Super Likes")
                .font(.largeTitle)
            
            Text("Stand out with a super like")
            Text("Profiles super liked are notified instantaneously about your crush on them. Walk the extra mile, you miss 100% of the shots you don't take.")
                .customFont(.footnote)
                .opacity(0.7)
                .padding(.horizontal,20)
        }
    }
    
    var collapseSheet: some View {
        // Done Button
        HStack {
            Spacer()
            Button {
                allcardsActiveSheet = nil
            } label: {
                DoneButton()
            }
        }.padding()
    }
    
    var sheetBackgrounColor: some View {
        // Golden yellow color of the card
        VStack {
            ForEach(starsPositioning, id: \.self) { result in
                Image(systemName: result.imageName)
                    .resizable()
                    .frame(width:result.width, height:result.height)
                    .foregroundColor(result.color)
                    .blur(radius: result.blur)
                    .offset(x: result.x, y: result.y)
                    .rotationEffect(.degrees(result.rotationAngle))
            }
        }
        
    }
}

struct BuyMoreSuperLikesSheet_Previews: PreviewProvider {
    static var previews: some View {
        BuyMoreSuperLikesSheet(allcardsActiveSheet:
                                Binding.constant(AllCardsActiveSheet.buyMoreSuperLikesSheet))
            .environmentObject(StoreManager())
    }
}



struct SuperLikeBuyButton: View {
    @EnvironmentObject var storeManager: StoreManager
    // Recieves [5, 10, 15] which is used to refer 5 Messages, 10 Messages and 15 Messages
    @State var superLikeCount: Float = 0.0
    @State var totalCost:Float = 0.0
    @State var currency: Character // Receives Dollar Sign
    @State var skProductObj: SKProduct = SKProduct()
    
    var body: some View {
        
            Button {
                if let purchasedSuperLikesCount = storeManager.purchaseDataDetails.purchasedSuperLikesCount {
                    self.storeManager.tempPurchaseHold.purchasedSuperLikesCount = purchasedSuperLikesCount + Int(superLikeCount)
                    // Purchase the product by passing in the Sk Product Object
                    storeManager.purchaseProduct(product:skProductObj)
                }
            } label : {
                VStack {
                        HStack {
                            Text("Buy \(superLikeCount, specifier: "%.2f")")
                            Image(systemName: "star.circle.fill")
                            Text("for \(String(currency))\(totalCost, specifier: "%.2f")")
                        }
                    }
                    .quickSuperLikePurchase()
            }

        }
}
