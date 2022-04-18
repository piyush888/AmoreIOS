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
                    gradient: Gradient(colors: [Color.purple, Color.blue,  Color.white, Color.white]),
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
                            .foregroundColor(Color.white)
                        Text("Consider upgrading to Amore Gold or Platinum")
                            .font(.caption)
                            .foregroundColor(Color.white)
                    } else if subscriptionTypeId.contains("Gold") {
                        Text("Amore \(subscriptionTypeId.components(separatedBy: ".")[2]) Gold plan")
                            .font(.title2)
                            .foregroundColor(Color.white)
                        Text("Consider upgrading to Amore 3 Month Platinum")
                            .font(.caption)
                            .foregroundColor(Color.white)
                    } else if subscriptionTypeId.contains("Platinum") {
                        Text("Amore \(subscriptionTypeId.components(separatedBy: ".")[2]) Platinum plan")
                            .font(.title2)
                            .foregroundColor(Color.white)
                        Text("We hope you are enjoying the app")
                            .font(.caption)
                            .foregroundColor(Color.white)
                    }
                    
                }
                
                Spacer()
                
                if subscriptionTypeId.contains("Platinum") || subscriptionTypeId.contains("Gold") {
                    
                    SubscriptionDetails(popUpCardSelection:$popUpCardSelection,
                                        showModal:$showModal,
                                        bgColor:Color.clear)
                        .frame(width: UIScreen.main.bounds.width-50, height:90)
                        .padding(.horizontal,30)
                    
                }
                
                
                Spacer()
                
                if subscriptionTypeId.contains("Free") {
                
                    Button {
                        //TODO redirect to payment page
                    } label: {
                        ZStack{
                            Capsule()
                                .fill(LinearGradient(
                                    gradient: Gradient(colors: [Color.yellow, Color.red]),
                                    startPoint: .leading,
                                    endPoint: .trailing)
                                )
                                .frame(width:UIScreen.main.bounds.width - 150, height:80)
                            
                            VStack {
                                Text("Upgrade to Amore Gold")
                                    .foregroundColor(Color.white)
                                    .font(.headline)
                                if let pricingData = storeManager.amoreGoldPricing {
                                    Text("3 month for \(Float(truncating: pricingData["Amore Gold 1 Month"]?.price ?? 0.0))")
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
                
                if subscriptionTypeId.contains("Free") {
                    Spacer()
                    Text("Or")
                        .font(.headline)
                        .foregroundColor(Color.white)
                    Spacer()
                }
                
                if subscriptionTypeId.contains("Free") || subscriptionTypeId.contains("Gold") {
                
                    Button {
                        //TODO redirect to payment page
                    } label: {
                        ZStack{
                            Capsule()
                                .fill(LinearGradient(
                                   gradient: Gradient(colors: [Color.green, Color.blue]),
                                    startPoint: .leading,
                                    endPoint: .trailing)
                                )
                                .frame(width:UIScreen.main.bounds.width - 150, height:80)
                            
                            VStack {
                                Text("Upgrade to Platinum")
                                    .foregroundColor(Color.white)
                                    .font(.headline)
                                if let pricingData = storeManager.amorePlatinumPricing {
                                    Text("3 month for \(Float(truncating: pricingData["Amore Platinum 1 Month"]?.price ?? 0.0), specifier: "%.2f")")
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
                
                HStack {
                    Spacer()
                    Button("Rate us") {
                        storeManager.writeReview()
                    }
                    .buttonStyle(GrowingButton(buttonColor:Color.yellow, fontColor: Color.white))
                    Spacer()
                    Button("Close") {
                        showModal.toggle()
                    }
                    .buttonStyle(GrowingButton(buttonColor:Color.blue, fontColor: Color.white))
                    Spacer()
                }
                
            }
            .padding(10)
            .cornerRadius(12)
            .clipped()
            .frame(width: UIScreen.main.bounds.width-50, height: 400)
        }
        
      
        
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
