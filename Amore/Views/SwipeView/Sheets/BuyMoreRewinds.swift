//
//  BuyMoreRewinds.swift
//  Amore
//
//  Created by Kshitiz Sharma on 11/18/22.
//

import SwiftUI
import StoreKit

struct BuyMoreRewinds: View {
    
    @EnvironmentObject var storeManager: StoreManager
    @Binding var allcardsActiveSheet: AllCardsActiveSheet?
    
    @State private var info: AlertInfo?
    @State var numberOfRewinds:String="5"
    
    var totalRewindCount: Int {
        let purchasedRewindsCount =  self.storeManager.purchaseDataDetails.purchasedRewindsCount ?? 0
        let subscriptionRewindsCount =  self.storeManager.purchaseDataDetails.subscriptionRewindsCount ?? 0
        return purchasedRewindsCount+subscriptionRewindsCount
    }
    
    var body: some View {
        
        GeometryReader { geometry in
            
            VStack {
                
                // Done Button
                HStack {
                    Spacer()
                    Button {
                        allcardsActiveSheet = nil
                    } label: {
                        DoneButton()
                    }
                }.padding()
                
                VStack(spacing: 16) {
                    
                    Image(systemName: "arrowshape.turn.up.backward.circle.fill")
                        .resizable()
                        .frame(width:80, height:80)
                        .foregroundColor(.orange)
                    
                    HStack {
                        Text("You've")
                        Text("\(totalRewindCount)")
                        Text("Replays")
                    }.font(.largeTitle)
                    
                    
                    Text("Swiped accidentally?, don't let them get away")
                    
                    Text("Unwind the action and let your love be seen")
                        .customFont(.footnote)
                        .opacity(0.7)
                        .padding(.horizontal,20)
                }

                
                Spacer()
                // Give user option to buy messages here
                VStack {
                    let pricingData = storeManager.rewindsPricing
                    RewindBuyButton(rewindCount:2.0,
                                   totalCost: Float(truncating: pricingData["2 Rewinds"]?.price ?? 0.0),
                                   currency: pricingData["2 Rewinds"]?.localizedPrice?.first ?? "$",
                                   skProductObj: pricingData["2 Rewinds"] ?? SKProduct())
                        .frame(width: geometry.size.width*0.80)
                        .environmentObject(storeManager)
                

                    RewindBuyButton(rewindCount:5.0,
                                   totalCost: Float(truncating: pricingData["5 Rewinds"]?.price ?? 0.0),
                                   currency: pricingData["5 Rewinds"]?.localizedPrice?.first ?? "$",
                                   skProductObj: pricingData["5 Rewinds"] ?? SKProduct())
                        .frame(width: geometry.size.width*0.80)
                        .environmentObject(storeManager)
                }
                Spacer()
                
            }
            
        }
        .padding(.horizontal)
        .background(
            Image("Spline")
                .blur(radius: 50)
                .offset(x: 200, y: 100)
        )
        .alert(item: $info, content: { info in
                    Alert(title: Text(info.title),
                          message: Text(info.message),
                          dismissButton:info.dismissButton
                    )
            }
        )
    }
}


struct RewindBuyButton: View {
    @EnvironmentObject var storeManager: StoreManager
    // Recieves [5, 10, 15] which is used to refer 5 Messages, 10 Messages and 15 Messages
    @State var rewindCount: Float = 0.0
    @State var totalCost:Float = 0.0
    @State var currency: Character // Receives Dollar Sign
    @State var skProductObj: SKProduct = SKProduct()
    
    var body: some View {
        
            Button {
                if let purchasedRewindsCount = storeManager.purchaseDataDetails.purchasedRewindsCount {
                    self.storeManager.tempPurchaseHold.purchasedRewindsCount = purchasedRewindsCount + Int(rewindCount)
                } else {
                    self.storeManager.tempPurchaseHold.purchasedRewindsCount = Int(rewindCount)
                }
                // Purchase the product by passing in the Sk Product Object
                storeManager.purchaseProduct(product:skProductObj)
            } label : {
                
                VStack {
                        HStack {
                            Text("Buy \(rewindCount, specifier: "%.2f")")
                            Image(systemName: "arrowshape.turn.up.backward.circle.fill")
                            Text("for \(String(currency))\(totalCost, specifier: "%.2f")")
                        }
                    }
                    .purcahseButton()
            }

        }
}

struct BuyMoreRewinds_Previews: PreviewProvider {
    static var previews: some View {
        BuyMoreRewinds(allcardsActiveSheet: Binding.constant(AllCardsActiveSheet.buyMoreRewindsSheet))
            .environmentObject(StoreManager())
    }
}
