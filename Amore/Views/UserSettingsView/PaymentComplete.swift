//
//  PaymentComplete.swift
//  Amore
//
//  Created by Kshitiz Sharma on 4/17/22.
//
import SwiftUI

struct PaymentComplete: View {
        
    @EnvironmentObject var storeManager: StoreManager
    @State var subscriptionTypeId: String
    @State var time = 0.0
    @State var scale = 0.1
    let duration = 5.0
    
    var body: some View {
        
        ZStack {
            Image(systemName: "heart.fill")
                .frame(width:60, height:60)
                    .foregroundColor(.pink)
                    .modifier(ParticlesModifier())
                    .offset(x: -100, y : -50)
                
            Image(systemName: "heart.fill")
                    .frame(width:60, height:60)
                    .foregroundColor(.blue)
                    .modifier(ParticlesModifier())
                    .offset(x: 60, y : 70)
            
            VStack {
                
                Image(systemName: "gift.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
                    .foregroundColor(.blue)
                
                
                Text("Thanks for being part of community, Purchas was complete.")
                    .padding(20)
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                
                
                Image(systemName: "bolt.heart.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
                    .foregroundColor(.red)
                
                
                if subscriptionTypeId.contains("Free") {
                    Text("If you like Amore Free")
                        .font(.title2)
                        .foregroundColor(Color.black)
                    Text("Consider upgrading to Amore Gold or Platinum")
                        .font(.caption)
                        .foregroundColor(Color.black)
                } else if subscriptionTypeId.contains("Gold") {
                    Text("Amore \(subscriptionTypeId.components(separatedBy: ".")[2]) Gold plan")
                        .font(.title2)
                        .foregroundColor(Color.black)
                    Text("We hope you are enjoying the app")
                        .font(.caption)
                        .foregroundColor(Color.black)
                } else if subscriptionTypeId.contains("Platinum") {
                    Text("Amore \(subscriptionTypeId.components(separatedBy: ".")[2]) Platinum plan")
                        .font(.title2)
                        .foregroundColor(Color.black)
                    Text("We hope you are enjoying the app")
                        .font(.caption)
                        .foregroundColor(Color.black)
                }
                
                SubscriptionDetails(popUpCardSelection:Binding.constant(PopUpCards.myAmorecards),
                                    showModal:Binding.constant(false),
                                    bgColor:Color.clear)
                    .frame(width: UIScreen.main.bounds.width-50, height:90)
                    .padding(.horizontal,30)
                
                
                
                HStack {
                    Spacer()
                    
                    // Rate Us
                    Button("Rate us") {
                        storeManager.writeReview()
                    }
                    .buttonStyle(GrowingButton(buttonColor:Color.yellow, fontColor: Color.white))
                    
                    Spacer()
                    
                    Button("Keep Swiping") {
                        storeManager.paymentCompleteDisplayMyAmore = false
                    }
                    .buttonStyle(GrowingButton(buttonColor:Color.pink, fontColor: Color.white))
                    
                    Spacer()
                }
                .padding()
                
            }
        }
        
    }
}

struct PaymentComplete_Previews: PreviewProvider {
    
    static var previews: some View {
        PaymentComplete(subscriptionTypeId:"Amore.ProductId.12M.Platinum.v1")
            .environmentObject(StoreManager())
    }
}

