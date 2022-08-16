//
//  MyAmoreCard.swift
//  Amore
//
//  Created by Kshitiz Sharma on 10/30/21.
//

import SwiftUI
import StoreKit

struct MyAmoreCard: View {
    
    @EnvironmentObject var storeManager: StoreManager
    @Binding var showModal: Bool
    @Binding var popUpCardSelection: PopUpCards
    @State var subscriptionTypeId: String
    
    var body: some View {
        
        ZStack{
            Rectangle()
                .fill(LinearGradient(
                    gradient: Gradient(colors: [Color(hex:0x83489e), Color(hex:0xc5302e)]),
                    startPoint: .top,
                    endPoint: .bottom)
                )
                .frame(width: UIScreen.main.bounds.width-50, height: 500)
                .cornerRadius(20)
                
                
            VStack(alignment:.center) {
               
                Spacer()
                
                Group{
                
                    if subscriptionTypeId.contains("Free") {
                        Text("If you like Amore Free")
                            .font(.title2)
                        Text("Consider upgrading to Amore Gold or Platinum")
                            .font(.caption)
                    } else if subscriptionTypeId.contains("Gold") {
                        Text("Amore \(subscriptionTypeId.components(separatedBy: ".")[2]) Gold plan")
                            .font(.title2)
                        Text("Consider upgrading to Amore 3 Month Platinum")
                            .font(.caption)
                    } else if subscriptionTypeId.contains("Platinum") {
                        Text("Amore \(subscriptionTypeId.components(separatedBy: ".")[2]) Platinum plan")
                            .font(.title2)
                        Text("We hope you are enjoying the app")
                            .font(.caption)
                    }
                    
                }
                
                Spacer()
                
                if subscriptionTypeId.contains("Platinum") || subscriptionTypeId.contains("Gold") {
                    
                    SubscriptionDetails(popUpCardSelection:$popUpCardSelection,
                                        showModal:$showModal)
                        .frame(width: UIScreen.main.bounds.width-50, height:90)
                        .padding(.horizontal,30)
                }
                
                
                Spacer()
                
                // Gold Subscription
                if subscriptionTypeId.contains("Free") {
                
                    Button {
                        //TODO redirect to payment page
                        self.storeManager.oldpurchaseDataDetails.subscriptionTypeId = "Amore.ProductId.3M.Gold.v2"
                        self.storeManager.purchaseProduct(product: self.storeManager.amoreGoldPricing["Amore Gold 3 Month"] ?? SKProduct())
                    } label: {
                        
                        ZStack {
                            Capsule()
                                .fill(LinearGradient(
                                    gradient: Gradient(colors: [Color.yellow, Color.red]),
                                    startPoint: .leading,
                                    endPoint: .trailing)
                                )
                                .frame(height:80)
                            
                            VStack {
                                Text("Upgrade to Amore Gold")
                                    .foregroundColor(Color.white)
                                    .font(.headline)
                                if let pricingData = storeManager.amoreGoldPricing {
                                    Text("3 month for \(Float(truncating: pricingData["Amore Gold 3 Month"]?.price ?? 0.0), specifier: "%.2f")")
                                        .italic()
                                        .foregroundColor(Color.white)
                                        .font(.subheadline)
                                }
                                Text("Don't make them wait")
                                    .font(.caption)
                                    .foregroundColor(Color.white)
                            }
                        }
                        .padding(.top,15)
                        
                    }
                }
                
                // Or Text
                if subscriptionTypeId.contains("Free") {
                    Text("Or")
                        .font(.headline)
                        .foregroundColor(Color.white)
                        .padding(.vertical,10)
                }
                
                
                // Platinum Subscription
                if subscriptionTypeId.contains("Free") || subscriptionTypeId.contains("Gold") {
                
                    Button {
                        //TODO redirect to payment page
                        self.storeManager.oldpurchaseDataDetails.subscriptionTypeId = "Amore.ProductId.3M.Platinum.v2"
                        self.storeManager.purchaseProduct(product: self.storeManager.amorePlatinumPricing["Amore Platinum 3 Month"] ?? SKProduct())
                    } label: {
                        ZStack{
                            Capsule()
                                .fill(LinearGradient(
                                   gradient: Gradient(colors: [Color.green, Color.blue]),
                                    startPoint: .leading,
                                    endPoint: .trailing)
                                )
                                .frame(height:80)
                            
                            VStack {
                                Text("Upgrade to Platinum")
                                    .foregroundColor(Color.white)
                                    .font(.headline)
                                
                                if let pricingData = storeManager.amorePlatinumPricing {
                                    Text("3 month for \(Float(truncating: pricingData["Amore Platinum 3 Month"]?.price ?? 0.0), specifier: "%.2f")")
                                        .italic()
                                        .foregroundColor(Color.white)
                                        .font(.subheadline)
                                }
                                    
                                Text("Top picks, super stars, boosts, messages")
                                    .foregroundColor(Color.white)
                                    .font(.caption)
                            }
                        }
                    }
                }
                
                Spacer()
                
                
                HStack(spacing:60) {
                    
                    Button {
                        storeManager.writeReview()
                    } label : {
                        Text("Rate us")
                            .foregroundColor(Color.white)
                            .bold()
                    }
                    
                    Button {
                        showModal.toggle()
                    } label : {
                        Text("Close")
                            .foregroundColor(Color.white)
                            .bold()
                    }
                    
                }
                .padding(.top,10)
                
            }
            .padding(10)
            .cornerRadius(12)
            .clipped()
            .frame(width: UIScreen.main.bounds.width-50, height: 400)
        }
        .foregroundColor(Color.white)
      
        
    }
}


struct GrowingButton: ButtonStyle {
    
    @State var buttonColor: Color
    @State var fontColor: Color
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(self.buttonColor)
            .foregroundColor(self.fontColor)
            .clipShape(Capsule())
            .scaleEffect(configuration.isPressed ? 1.2 : 1)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}
