//
//  MyAmoreCard.swift
//  Amore
//
//  Created by Kshitiz Sharma on 10/30/21.
//

import SwiftUI
import StoreKit

struct MyAmoreCard: View {
    
    @StateObject var appReview = AppReview()
    @EnvironmentObject var storeManager: StoreManager
    @Binding var showModal: Bool
    @Binding var popUpCardSelection: PopUpCards
    @State var subscriptionTypeId: String
    
    @Environment(\.colorScheme) var colorScheme
    
    var monthsInSubscription: String {
          let numberOfMonth = subscriptionTypeId.components(separatedBy: ".")[2]
          return numberOfMonth
    }
    
    
    var body: some View {
        
        ZStack {
            // Background for the card
            cardBackground
                
            VStack(alignment:.center, spacing:10) {
               
                // Amore text
                myAmoreCardText
                
                Spacer()
                
                // If user has a Gold Subscription show the following
                if subscriptionTypeId.contains("Gold") {
                    VStack(spacing:0) {
                        Text("You are subscribed to \(monthsInSubscription) Amore Gold plan")
                        
                        HStack(spacing:1) {
                            Image(systemName: "star.fill")
                                .foregroundColor(Color("gold-star"))
                            Text("3 Super likes everyday")
                        }
                        
                        HStack(spacing:1) {
                            Image(systemName: "bolt.fill")
                                .foregroundColor(Color.blue)
                            Text("1 Boost a day")
                        }
                        
                        HStack(spacing:1) {
                            Image(systemName: "message.circle.fill")
                                .foregroundColor(Color.red)
                            Text("2 messages everyday")
                        }
                    }
                    
                    SubscriptionDetails(popUpCardSelection:$popUpCardSelection,
                                        showModal:$showModal,
                                        backgroundColor:Binding.constant(Color.clear))
                        .environmentObject(storeManager)
                        .padding(.vertical,10)
                        .padding(.horizontal,20)
                        
                    
                    
                    Button {
                        UIApplication.shared.open(URL(string: "https://apps.apple.com/account/billing")!)
                    } label: {
                        Text("Manage Subscription")
                    }
                    .buttonStyle(GrowingButton(buttonColor:Color.clear, fontColor: Color.white))
                    .padding(.top,20)
                    
                }
                //If the user has Free Subscription show the following
                else if subscriptionTypeId.contains("Free") {
                    Button {
                        self.storeManager.tempPurchaseHold.subscriptionTypeId = "Amore.ProductId.3M.Gold.v2"
                        self.storeManager.purchaseProduct(product: self.storeManager.amoreGoldPricing["Amore Gold 3 Month"] ?? SKProduct())
                    } label: {
                        buyAmoreGoldButton
                    }
                }
                
                Spacer()
                // Button to give option to user for rating the app or collapse the view
                rateUsAndCollapseView
             
            }
            .padding(10)
            .cornerRadius(12)
            .clipped()
            .frame(width: UIScreen.main.bounds.width-50, height: 400)
        }
        .foregroundColor(Color.white)
    }
    
    var cardBackground: some View {
        Rectangle()
            .fill(LinearGradient(
                gradient: Gradient(colors: [Color(hex:0xf492f0), Color(hex:0xf9c58d)]),
                startPoint: .top,
                endPoint: .bottom)
            )
            .frame(width: UIScreen.main.bounds.width-50, height: 500)
            .cornerRadius(20)
    }
    
    var buyAmoreGoldButton: some View {
        ZStack {
            Capsule()
                .fill(LinearGradient(
                    gradient: Gradient(colors: [Color(hex:0xf86ca7), Color(hex:0xf4d444)]),
                    startPoint: .leading,
                    endPoint: .trailing)
                )
                .frame(width:UIScreen.main.bounds.width*0.70,height:80)
            
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
    
    var myAmoreCardText: some View {
        Group {
        
            if subscriptionTypeId.contains("Free") {
                Text("If you like Amore Free")
                    .font(.title2)
                Text("Consider upgrading to Amore Gold")
//                        Text("Consider upgrading to Amore Gold or Platinum")
            } else if subscriptionTypeId.contains("Gold") {
                Text("Amore \(monthsInSubscription) Gold plan")
                    .font(.title2)
//                        Text("Consider upgrading to Amore 3 Month Platinum")
//                            .font(.caption)
            }
//                    else if subscriptionTypeId.contains("Platinum") {
//                        Text("Amore \(subscriptionTypeId.components(separatedBy: ".")[2]) Platinum plan")
//                            .font(.title2)
//                        Text("We hope you are enjoying the app")
//                            .font(.caption)
//                    }
            
        }
        
    }
    
    var rateUsAndCollapseView: some View {
        HStack(spacing:60) {
            Button {
                appReview.writeReview()
            } label : {
                Text("Rate us")
            }
            .buttonStyle(GrowingButton(buttonColor:Color.pink, fontColor: Color.white))
            
            NoThanksButton(showModal:$showModal, buttonColor:Color.clear, fontColor:Color.white)
                
        }
        .padding(.top,10)
    }
    
    
//    // Not being used anywhere 08.18.22
//    var platinumSubscription: some View {
//        Group {
//
//            // Or Text to distinguish between Platinum and Gold subscription. Not required since we are removing platinum now.
//            if subscriptionTypeId.contains("Free") {
//                Text("Or")
//                    .font(.headline)
//                    .foregroundColor(Color.white)
//                    .padding(.vertical,10)
//            }
//
//
//            if subscriptionTypeId.contains("Free") || subscriptionTypeId.contains("Gold") {
//
//                Button {
//                    //TODO redirect to payment page
//                    self.storeManager.oldpurchaseDataDetails.subscriptionTypeId = "Amore.ProductId.3M.Platinum.v2"
//                    self.storeManager.purchaseProduct(product: self.storeManager.amorePlatinumPricing["Amore Platinum 3 Month"] ?? SKProduct())
//                } label: {
//                    ZStack{
//                        Capsule()
//                            .fill(LinearGradient(
//                               gradient: Gradient(colors: [Color.green, Color.blue]),
//                                startPoint: .leading,
//                                endPoint: .trailing)
//                            )
//                            .frame(height:80)
//
//                        VStack {
//                            Text("Upgrade to Platinum")
//                                .foregroundColor(Color.white)
//                                .font(.headline)
//
//                            if let pricingData = storeManager.amorePlatinumPricing {
//                                Text("3 month for \(Float(truncating: pricingData["Amore Platinum 3 Month"]?.price ?? 0.0), specifier: "%.2f")")
//                                    .italic()
//                                    .foregroundColor(Color.white)
//                                    .font(.subheadline)
//                            }
//
//                            Text("Top picks, super stars, boosts, messages")
//                                .foregroundColor(Color.white)
//                                .font(.caption)
//                        }
//                    }
//                }
//            }
//        }
//    }
    
}

struct NoThanksButton: View {
    
    @Binding var showModal: Bool
    @State var buttonColor: Color = Color.clear
    @State var fontColor: Color = Color.gray
    
    
    var body: some View {
        Button {
            showModal.toggle()
        } label : {
            Text("No thanks")
        }
        .buttonStyle(GrowingButton(buttonColor:self.buttonColor, fontColor: self.fontColor))
        .opacity(0.8)
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
