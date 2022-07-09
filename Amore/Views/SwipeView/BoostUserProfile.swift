//
//  BoostProfile.swift
//  Amore
//
//  Created by Kshitiz Sharma on 6/19/22.
//

import SwiftUI
import Firebase
import StoreKit
import RiveRuntime

struct BoostUserProfile: View {
    
    @EnvironmentObject var storeManager: StoreManager
    @EnvironmentObject var profileModel: ProfileViewModel
    @EnvironmentObject var photoModel: PhotoModel
    
    
    @Binding var allcardsActiveSheet: AllCardsActiveSheet?
    @State var popUpCardSelection: PopUpCards = .superLikeCards
    
    private var BoostCountView: some View {
        Text("\(storeManager.purchaseDataDetails.totalBoostCount.boundInt)")
    }
    
    private var boostBalanceIsZero: Bool {
        return storeManager.purchaseDataDetails.totalBoostCount.boundInt == 0 ? true : false
    }
    
    @State var boostSecondsRemaining: Int = 0
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State var isBoostActive: Bool = false
    
    func activateBoost() {
        let boostTimeRemainingInUnix = NSDate().timeIntervalSince1970 - (profileModel.editUserProfile.boostTime ?? 0)
        // Boost count is less than number of seconds in an hour, that means boost is stil active
        if boostTimeRemainingInUnix < 3600 {
            boostSecondsRemaining = Int(3600 - boostTimeRemainingInUnix)
            isBoostActive = true
        } else {
            isBoostActive = false
        }
    }
    
    
    // The RiveViewModel has methods to play and pause specific animations. To do that, the Rive asset must be declared first. If you have an animation that automatically plays, you can set autoplay to false.autoPlay
    let button = RiveViewModel(fileName: "button", autoPlay: false)
    let radiateAnimation = RiveViewModel(fileName: "radiate", autoPlay: true)
    
    static let gradientStart = Color(red: 239.0 / 255, green: 120.0 / 255, blue: 221.0 / 255)
    static let gradientEnd = Color(red: 239.0 / 255, green: 172.0 / 255, blue: 120.0 / 255)
    
    
    // Boot Page
    var body: some View {
            
            
            GeometryReader { geometry in

                VStack {

                    // Done button to close the sheet modifier
                    HStack {
                        Spacer()
                        Button {
                            allcardsActiveSheet = nil
                        } label: {
                            DoneButton()
                        }
                    }.padding()


                    // Displays how manu boosts are left with the user & other information about how boost works
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
                    
                    
                    // Radiant Animation - Nothing happens in here, just a show piece
                    ZStack {
                        // Radiant Animation
                        radiateAnimation
                            .view()
                            .frame(width:geometry.size.width/1.5)
                        // User Profile act as a button
                        Button {
                            // Nothing happens here
                        } label: {
                            ProfileImageView(profileImage: $profileModel.editUserProfile.image1, photo: $photoModel.photo1, customModifier: UserSnapDetailsModifier(width:80, height:80))
                        }
                    }
                    
                    VStack{
                        if isBoostActive {
                            // Tells user when boost is active
                            Text("Boost is active, continue swiping")
                        } else {
                            // Normal info to encourage user to purcahse boost
                            Text("Get noticed by thousands of people around you")
                        }
                    }
                    .customFont(.footnote)
                    .opacity(0.7)
                    .padding(.horizontal,20)
                    
                    // MAIN FUNCTIONALITY
                    // Activate boost button
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
                                if isBoostActive {
                                    HStack {
                                        Text("00:\(boostSecondsRemaining/60):\(boostSecondsRemaining%60)")
                                            .fontWeight(.bold)
                                            .onReceive(timer) { _ in
                                                   if boostSecondsRemaining > 0 {
                                                       boostSecondsRemaining -= 1
                                                   }
                                               }
                                        Image(systemName: "clock")
                                    }
                                    .font(.title)
                                    
                                } else {
                                    Text("Boost me").fontWeight(.bold)
                                    Image(systemName: "bolt.circle.fill")
                                }
                            }
                            .offset(x: 4, y: 4)
                            .font(.title3)
                            .foregroundColor(Color.blue)
                        )
                        .onTapGesture {
                            try? button.play(animationName: "active")
                            // Activate boost only if not already active
                            if isBoostActive == false {
                                DispatchQueue.main.async {
                                    // Check if the total boost count is not none
                                    if storeManager.purchaseDataDetails.totalBoostCount.boundInt > 0 {
                                        profileModel.editUserProfile.boostTime = NSDate().timeIntervalSince1970
                                        profileModel.updateUserProfile(profileId:  Auth.auth().currentUser?.uid)
                                        storeManager.purchaseDataDetails.totalBoostCount.boundInt -= 1
                                        _ = storeManager.storePurchaseNoParams()
                                        isBoostActive = true
                                        self.activateBoost()
                                        print("User Boost was activated")
                                    } else {
                                        print("User has no boosts left")
                                    }
                                }
                            }
                            try? button.reset()
                        }
                    
                    
                    Spacer()
                    
                    // Divider
                    HStack {
                        Rectangle().frame(height: 1).opacity(0.1)
                        Text("OR").customFont(.subheadline2).foregroundColor(.black.opacity(0.3))
                        Rectangle().frame(height: 1).opacity(0.1)
                    }
                    
                    Spacer()
                    
                    // Give user option to buy boost here
                    VStack {
                        if let pricingData = storeManager.boostsPricing {
                            
                            BoostBuyButton(boostType:2.0,
                                           totalCost: Float(truncating: pricingData["2 Boosts"]?.price ?? 0.0),
                                           currency: pricingData["2 Boosts"]?.localizedPrice?.first ?? "$",
                                           skProductObj: pricingData["2 Boosts"] ?? SKProduct())
                                .frame(width: geometry.size.width*0.80)
                                .environmentObject(storeManager)
                        

                            BoostBuyButton(boostType:5.0,
                                           totalCost: Float(truncating: pricingData["5 Boosts"]?.price ?? 0.0),
                                           currency: pricingData["5 Boosts"]?.localizedPrice?.first ?? "$",
                                           skProductObj: pricingData["5 Boosts"] ?? SKProduct())
                                .frame(width: geometry.size.width*0.80)
                                .environmentObject(storeManager)
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
            ).onAppear {
                self.activateBoost()
            }
    }
}

//struct BoostUserProfile_Previews: PreviewProvider {
//    static var previews: some View {
//        BoostUserProfile(cardActive:Binding.constant(AllCardsActiveSheet.boostProfileSheet))
//            .preferredColorScheme(.dark)
//            .environmentObject(StoreManager())
//            .environmentObject(PhotoModel())
//            .environmentObject(CardProfileModel())
//
//    }
//}


struct BoostBuyButton: View {
    @EnvironmentObject var storeManager: StoreManager
    // Recieves [2, 5, 10] which is used to refer 2 Boost, 5 Boost and 10 Boost count
    @State var boostType: Float = 0.0
    @State var totalCost:Float = 0.0
    @State var currency: Character // Receives Dollar Sign
    @State var skProductObj: SKProduct = SKProduct()
    var body: some View {
        
        
            Button {
                if let purchasedBoostCount = storeManager.oldpurchaseDataDetails.purchasedBoostCount,
                   let totalBoostCount =  storeManager.oldpurchaseDataDetails.totalBoostCount {
                        self.storeManager.oldpurchaseDataDetails.purchasedBoostCount = purchasedBoostCount + Int(boostType)
                        self.storeManager.oldpurchaseDataDetails.totalBoostCount = totalBoostCount + Int(boostType)
                        _ = storeManager.purchaseProduct(product:skProductObj)
                }
            } label : {
                
                VStack {
                        HStack {
                            Text("Buy \(boostType, specifier: "%.2f")")
                            Image(systemName: "bolt.circle.fill")
                            Text("for \(String(currency))\(totalCost, specifier: "%.2f")")
                            Text("/ \(String(currency))\(totalCost/boostType, specifier: "%.2f") each")
                                .customFont(.footnote2)
                                .opacity(0.8)
                        }
                    }
                    .purcahseButton()
            }

        }
}


