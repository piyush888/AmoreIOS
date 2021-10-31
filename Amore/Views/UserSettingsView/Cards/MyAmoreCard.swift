//
//  MyAmoreCard.swift
//  Amore
//
//  Created by Kshitiz Sharma on 10/30/21.
//

import SwiftUI

struct MyAmoreCard: View {
    
    @Binding var showModal: Bool
    @Binding var popUpCardSelection: PopUpCards
    
    // Types of subscription
    /// Free
    /// Gold
    /// Platinum
    @State var profileSubscription: String = "Free"
    
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
                
                    if profileSubscription == "Free" {
                        Text("Amore Free plan")
                            .font(.title2)
                            .foregroundColor(Color.white)
                        Text("Consider upgrading to Amore Gold or Platinum")
                            .font(.caption)
                            .foregroundColor(Color.white)
                    } else if profileSubscription == "Gold" {
                        Text("Amore Gold plan")
                            .font(.title2)
                            .foregroundColor(Color.white)
                        Text("Consider upgrading to Amore Platinum")
                            .font(.caption)
                            .foregroundColor(Color.white)
                    } else if profileSubscription == "Platinum" {
                        Text("Amore Platinum plan")
                            .font(.title2)
                            .foregroundColor(Color.white)
                        Text("You can buy more stars, boosts and request messages.")
                            .font(.caption)
                            .foregroundColor(Color.white)
                    }
                    
                }
                
                Spacer()
                
                if profileSubscription == "Free" {
                
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
                                Text("3 month for 800")
                                    .italic()
                                    .foregroundColor(Color.white)
                                    .font(.subheadline)
                                Text("Find your Dil today, Don't make them wait")
                                    .font(.caption)
                                    .foregroundColor(Color.white)
                                    
                            }
                        }
                        .padding(.top,15)
                        
                    }
                }
                
                if profileSubscription == "Free" {
                    Spacer()
                    Text("Or")
                        .font(.headline)
                        .foregroundColor(Color.white)
                    Spacer()
                }
                
                if profileSubscription == "Free" || profileSubscription == "Gold" {
                
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
                                Text("3 month for 1050")
                                    .italic()
                                    .foregroundColor(Color.white)
                                    .font(.subheadline)
                                Text("Top picks, super stars, boosts, messages")
                                    .foregroundColor(Color.white)
                                    .font(.caption)
                            }
                        }
                    }
                }
                
                if profileSubscription == "Platinum" {
                    
                    SubscriptionDetails(popUpCardSelection:$popUpCardSelection,
                                        showModal:$showModal,
                                        bgColor:Color.clear)
                        .frame(width: UIScreen.main.bounds.width-50, height:90)
                        .padding(.horizontal,30)
                    
                }
                
                Spacer()
                
                Text("No thanks")
                        .foregroundColor(Color.gray)
                    .onTapGesture {
                        showModal.toggle()
                    }
                    .padding(.top,10)
                
                
                
            }
            .padding(10)
            .cornerRadius(12)
            .clipped()
            .frame(width: UIScreen.main.bounds.width-50, height: 400)
        }
        
      
        
    }
}

