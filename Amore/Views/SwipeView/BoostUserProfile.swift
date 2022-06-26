//
//  BoostProfile.swift
//  Amore
//
//  Created by Kshitiz Sharma on 6/19/22.
//

import SwiftUI
import RiveRuntime

struct BoostUserProfile: View {
    
    @EnvironmentObject var storeManager: StoreManager
    @Binding var cardActive: AllCardsActiveSheet?
    @State var popUpCardSelection: PopUpCards = .superLikeCards
    
    private var BoostCountView: some View {
        Text("\(storeManager.purchaseDataDetails.purchasedBoostCount.boundInt)")
    }
    
    private var boostBalanceIsZero: Bool {
//        return storeManager.purchaseDataDetails.purchasedBoostCount.boundInt == 0 ? true : false
        // UNDO
        return false
    }
    
    // The RiveViewModel has methods to play and pause specific animations. To do that, the Rive asset must be declared first. If you have an animation that automatically plays, you can set autoplay to false.autoPlay
    let button = RiveViewModel(fileName: "button", autoPlay: false)
    let radiateAnimation = RiveViewModel(fileName: "radiate", autoPlay: true)
    
    static let gradientStart = Color(red: 239.0 / 255, green: 120.0 / 255, blue: 221.0 / 255)
    static let gradientEnd = Color(red: 239.0 / 255, green: 172.0 / 255, blue: 120.0 / 255)
    
    var body: some View {
            
        
            GeometryReader { geometry in

                VStack {

                    // Part 1 - 'Done' button for closing the sheet
                    HStack {
                        Spacer()
                        Button {
                            cardActive = .none
                        } label: {
                            Text("Done")
                            .fontWeight(.bold)
                            .font(.subheadline)
                            .padding()
                            .foregroundColor(.white)
                            .background(LinearGradient(gradient: Gradient(colors: [Color("dark-green"), Color("light-green")]), startPoint: .leading, endPoint: .trailing))
                            .cornerRadius(20)
                        }
                    }.padding()


                    // Part 2 - Boot Description Status
                    VStack(spacing: 16) {
                        Image(systemName: "bolt.circle.fill")
                            .resizable()
                            .frame(width:50, height:50)
                            .foregroundColor(Color.blue)

                        HStack {
                            Text("You've")
                            BoostCountView
                            Text("Boost")
                        }.font(.largeTitle)
                        
                        Text("Boost your profile for next 60 min")
                        Text("Once profile boost is triggered, the Amore recommendation engine pushes your profile to relevant users nearby, giving you a better prospect of finding a potential match.")
                            .customFont(.footnote)
                            .opacity(0.7)
                            .padding(.horizontal,20)
                        
                        
                    }
                    
                    Spacer()
                    
                    Text("Profile was seen by 324 users")
                        .font(.title2)
                    
                    // Radiant
                    radiateAnimation
                        .view()
                        .frame(width:geometry.size.width/1.5)
                        
                    
                    // Part 3.2 Activate Boost if boost count is already more than x
                    button
                        .view()
                        .frame(width:330, height:80)
                        .background(
                            Color.black
                                .cornerRadius(30)
                                .blur(radius: 40)
                                .opacity(0.2)
                                .offset(y: 10)
                        )
                        .overlay(
                            HStack {
//                                Text("Boost me").fontWeight(.bold)
//                                Image(systemName: "bolt.circle.fill")
                                Text("00:34")
                                    .font(.title)
                                    .fontWeight(.bold)
                                    
                            }
                            .offset(x: 4, y: 4)
                            .font(.title3)
                            .foregroundColor(Color.blue)
                        )
                        .onTapGesture {
                            // Activate Boost Profile
                            try? button.play(animationName: "active")
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                                withAnimation(.spring()) {
                                    cardActive = .none
                                }
                            }
                            storeManager.purchaseDataDetails.purchasedBoostCount = 2
                        }
                    
                    Spacer()
                    
                    // Divider
                    HStack {
                        Rectangle().frame(height: 1).opacity(0.1)
                        Text("OR").customFont(.subheadline2).foregroundColor(.black.opacity(0.3))
                        Rectangle().frame(height: 1).opacity(0.1)
                    }
                    
                    Spacer()
                    
                    // Give user to buy boost here
                    if let pricingData = storeManager.boostsPricing {
                        HStack {
                            Button {
                                storeManager.purchaseDataDetails.purchasedBoostCount = 2
                            } label: {
                                HStack {
                                    Image(systemName: "creditcard.fill")
                                    Text("Buy Boost here")
                                }
                                .purcahseButton()
                            }
                            
                            Button {
                                storeManager.purchaseDataDetails.purchasedBoostCount = 2
                            } label: {
                                HStack {
                                    Image(systemName: "creditcard.fill")
                                    Text("Buy Boost here")
                                }
                                .purcahseButton()
                            }
                        }
                    }
                    
                    
                }

            }
            .padding()
            .background(
                    RiveViewModel(fileName: "shapes").view()
                            .ignoresSafeArea()
                            .blur(radius: 30)
                            .background(
                                Image("Spline")
                                    .blur(radius: 50)
                                    .offset(x: 200, y: 100)
                            )


            )
    }
}

struct BoostUserProfile_Previews: PreviewProvider {
    static var previews: some View {
        BoostUserProfile(cardActive:Binding.constant(AllCardsActiveSheet.boostProfileSheet))
            .preferredColorScheme(.dark)
            .environmentObject(StoreManager())
    }
}
