//
//  UserProfile.swift
//  Amore
//
//  Created by Kshitiz Sharma on 10/11/21.
//

import SwiftUI
import StoreKit

struct UserProfile: View {
    
    @EnvironmentObject var profileModel: ProfileViewModel
    @EnvironmentObject var photoModel: PhotoModel
    @EnvironmentObject var storeManager: StoreManager
    
    @State var profileEditingToBeDone: Bool = false
    @State var settingsDone: Bool = false
    @State var showModal = false
    @State var popUpCardSelection: PopUpCards = .superLikeCards
    
    var body: some View {
        
        NavigationView {
            
            GeometryReader { geometry in
                
                ZStack {
                    ScrollView{
                        VStack(alignment:.center) {
                            
                            // User Data
                            /// Image
                            /// Where user works
                            /// School Attended
                            UserSnapDetails()
                                .environmentObject(photoModel)
                                .environmentObject(profileModel)
                            
                            
                            // User Setttings View
                            /// Settings
                            /// Edit Profile
                            /// Safety
                            SettingEditProfileSafety(settingsDone:$settingsDone,
                                                     profileEditingToBeDone:$profileEditingToBeDone)
                                .environmentObject(photoModel)
                                .environmentObject(profileModel)
                                .padding(.bottom,20)
                            
                            // Subscription details
                            /// SuperLike
                            /// Number Of Boosst Left
                            /// Upgrade
                            SubscriptionDetails(popUpCardSelection:$popUpCardSelection,
                                                showModal:$showModal,
                                                bgColor:Color(red: 0.80, green: 1.0, blue: 1.0))
                            
                            
                            
                            SubscriptionTypes()
                                .environmentObject(storeManager)
                            
                            
                            Spacer()
                            
                            // Subscription Options
                            /// User subscription amore
                            /// Amore Platinum Information
                            ///  Amore Gold Information
                            ZStack {
                                Spacer()
                                
                                RoundedRectangle(cornerRadius: 20)
                                    .foregroundColor(Color(red: 0.80, green: 1.0, blue: 1.0))
                                VStack {
                                    MyAmore(width: 300,
                                            popUpCardSelection:$popUpCardSelection,
                                            showModal: $showModal)
                                    AmorePlatinum(width:300,
                                                  popUpCardSelection:$popUpCardSelection,
                                                  showModal:$showModal)
                                    AmoreGold(width:300,
                                              popUpCardSelection:$popUpCardSelection,
                                              showModal:$showModal)
                                        .padding(.bottom,10)
                                }
                                
                                Spacer()
                            }
                            
                        }
                        .padding(.horizontal,20)
                        .navigationBarHidden(true)
                    } // ScrollView
                        
                        if showModal {
                            
                                switch popUpCardSelection {
                                    
                                    case .superLikeCards :
                                        if let pricingData = storeManager.superLikesPricing {
                                            BuySubscriptionOrItemsCard(cardColorFormat:[Color.purple, Color.blue, Color.white],
                                                              cardName: "Super Likes",
                                                              cardHeaderSymbol: "star.circle",
                                                              cardHeaderSymbolColor: Color("gold-star"),
                                                              headerText: "Stand out with Super Like",
                                                              subHeaderText: "You're 3x likely to get a match!!",
                                                              showModal: $showModal,
                                                              geometry: geometry,
                                                              priceTabs: pricingData,
                                                              selectedPriceTabId: pricingData["5 Super Likes"]?.productIdentifier ?? "NoId",
                                                              selectedDictIndex: "5 Super Likes",
                                                              currency: pricingData["5 Super Likes"]?.localizedPrice ?? "USD",
                                                              totalCost: Float(truncating: pricingData["5 Super Likes"]?.price ?? 0.0),
                                                              firstTabKey: "5 Super Likes",
                                                              firstTabCount: 5,
                                                              secondTabKey: "15 Super Likes",
                                                              secondTabCount: 15,
                                                              thirdTabKey: "30 Super Likes",
                                                              thirdTabCount: 30
                                                            )
                                                            .environmentObject(storeManager)
                                        }
                                    
                                    case .boostCards :
                                        if let pricingData = storeManager.boostsPricing {
                                            BuySubscriptionOrItemsCard(cardColorFormat:[Color.yellow, Color.orange, Color.white],
                                                              cardName: "Boosts",
                                                              cardHeaderSymbol: "bolt.circle.fill",
                                                              cardHeaderSymbolColor: Color.blue,
                                                              headerText: "Skip the queue",
                                                              subHeaderText: "Be on top of the deck for 30 minutes",
                                                              showModal: $showModal,
                                                              geometry: geometry,
                                                              priceTabs: pricingData,
                                                              selectedPriceTabId: pricingData["2 Boosts"]?.productIdentifier ?? "NoId",
                                                              selectedDictIndex: "2 Boosts",
                                                              currency: pricingData["2 Boosts"]?.localizedPrice ?? "USD",
                                                              totalCost: Float(truncating: pricingData["2 Boosts"]?.price ?? 0.0),
                                                              firstTabKey: "2 Boosts",
                                                              firstTabCount: 2,
                                                              secondTabKey: "5 Boosts",
                                                              secondTabCount: 5,
                                                              thirdTabKey: "10 Boosts",
                                                              thirdTabCount: 10
                                                            )
                                                            .environmentObject(storeManager)
                                        }
                                    
                                    case .messagesCards:
                                        if let pricingData = storeManager.messagesPricing {
                                            BuySubscriptionOrItemsCard(cardColorFormat:[Color.red, Color.pink, Color.white],
                                                              cardName: "Messages",
                                                              cardHeaderSymbol: "message.circle.fill",
                                                              cardHeaderSymbolColor: Color.white,
                                                              headerText: "Be in their DM",
                                                              subHeaderText: "Get noticed, say something nice",
                                                              showModal: $showModal,
                                                              geometry: geometry,
                                                              priceTabs: pricingData,
                                                              selectedPriceTabId: pricingData["5 Messages"]?.productIdentifier ?? "NoId",
                                                              selectedDictIndex: "5 Messages",
                                                              currency: pricingData["5 Messages"]?.localizedPrice ?? "USD",
                                                              totalCost: Float(truncating: pricingData["5 Messages"]?.price ?? 0.0),
                                                              firstTabKey: "5 Messages",
                                                              firstTabCount: 5,
                                                              secondTabKey: "10 Messages",
                                                              secondTabCount: 10,
                                                              thirdTabKey: "15 Messages",
                                                              thirdTabCount: 15
                                                            )
                                                            .environmentObject(storeManager)
                                        }
                                        
                                    case .myAmorecards:
                                        MyAmoreCard(showModal: $showModal,
                                                    popUpCardSelection:$popUpCardSelection)
                                        
                                    case .amorePlatinum:
                                        if let pricingData = storeManager.amorePlatinumPricing {
                                            BuySubscriptionOrItemsCard(cardColorFormat:[Color.black,Color.white],
                                                              cardName: "Month",
                                                              cardHeaderSymbol: "bolt.heart.fill",
                                                              cardHeaderSymbolColor: Color.white,
                                                              headerText:"Platinum Subscription",
                                                              subScriptText1:"Top Picks",
                                                              subScriptText2:"Unlimited Likes",
                                                              subScriptText3:"10 Super likes everyday",
                                                              subScriptText4:"5 Boost a month",
                                                              subScriptText5:"2 messages everyday",
                                                              showModal: $showModal,
                                                              geometry: geometry,
                                                              priceTabs: pricingData,
                                                              selectedPriceTabId: pricingData["Amore Platinum 1 Month"]?.productIdentifier ?? "NoId",
                                                              selectedDictIndex: "Amore Platinum 1 Month",
                                                              currency: pricingData["Amore Platinum 1 Month"]?.localizedPrice ?? "USD",
                                                              totalCost: Float(truncating: pricingData["Amore Platinum 1 Month"]?.price ?? 0.0),
                                                              firstTabKey: "Amore Platinum 1 Month",
                                                              firstTabCount: 1,
                                                              secondTabKey: "Amore Platinum 3 Month",
                                                              secondTabCount: 3,
                                                              thirdTabKey: "Amore Platinum 6 Month",
                                                              thirdTabCount: 6
                                                            )
                                                            .environmentObject(storeManager)
                                        }
                                    
                                    case .amoreGold:
                                    if let pricingData = storeManager.amoreGoldPricing {
                                        BuySubscriptionOrItemsCard(cardColorFormat:[Color.red,Color.yellow],
                                                          cardName: "Month",
                                                          cardHeaderSymbol: "bolt.heart.fill",
                                                          cardHeaderSymbolColor: Color("gold-star"),
                                                          headerText:"Gold Subscription",
                                                          subScriptText1:"Top Picks",
                                                          subScriptText2:"500 Likes everyday",
                                                          subScriptText3:"5 Super likes everyday",
                                                          subScriptText4:"2 Boost a month",
                                                          subScriptText5:"1 messages everyday",
                                                          showModal: $showModal,
                                                          geometry: geometry,
                                                          priceTabs: pricingData,
                                                          selectedPriceTabId: pricingData["Amore Gold 1 Month"]?.productIdentifier ?? "NoId",
                                                          selectedDictIndex: "Amore Gold 1 Month",
                                                          currency: pricingData["Amore Gold 1 Month"]?.localizedPrice ?? "USD",
                                                          totalCost: Float(truncating: pricingData["Amore Gold 1 Month"]?.price ?? 0.0),
                                                          firstTabKey: "Amore Gold 1 Month",
                                                          firstTabCount: 1,
                                                          secondTabKey: "Amore Gold 3 Month",
                                                          secondTabCount: 3,
                                                          thirdTabKey: "Amore Gold 6 Month",
                                                          thirdTabCount: 6
                                                        )
                                                       .environmentObject(storeManager)
                                    }
                                                          
                                    } // switch statement
                            } // show modal
                            
                } // Zstack
            } // geometry reader
        } // navigation view
    }
    
}


// Template to display cards - this view is used by all the subscription & individualized item buying cards
struct BuySubscriptionOrItemsCard : View {
    
    @EnvironmentObject var storeManager: StoreManager
    
    @Namespace var animation
    @State var cardColorFormat: [Color]
    @State var cardName: String
    @State var cardHeaderSymbol: String
    @State var cardHeaderSymbolColor: Color
    @State var headerText: String
    @State var subHeaderText: String?
    @State var subScriptText1: String?
    @State var subScriptText2: String?
    @State var subScriptText3: String?
    @State var subScriptText4: String?
    @State var subScriptText5: String?
    @Binding var showModal: Bool
    @State var geometry: GeometryProxy
    @State var priceTabs: [String: SKProduct]
    @State var selectedPriceTabId: String
    @State var selectedDictIndex: String
    @State var currency: String
    @State var totalCost: Float
    @State var firstTabKey: String
    @State var firstTabCount: Int
    @State var secondTabKey: String
    @State var secondTabCount: Int
    @State var thirdTabKey: String
    @State var thirdTabCount: Int
    
    var body: some View {
        
            ZStack {
                
                // Card rectangle background cover
                // Just the color which is gradient
                // Different cards have different colors
                Rectangle()
                    .fill(LinearGradient(
                        gradient: Gradient(colors: self.cardColorFormat),
                        startPoint: .top,
                        endPoint: .bottom)
                    )
                    .frame(width: UIScreen.main.bounds.width-50, height: geometry.size.height/1.5)
                    .cornerRadius(20)
                
                // Content of the card
                VStack(alignment:.center) {
                   
                    Spacer()
                    // Symbol for the item or subscription
                    Image(systemName: self.cardHeaderSymbol)
                        .resizable()
                        .frame(width:50, height:50)
                        .foregroundColor(self.cardHeaderSymbolColor)
                    
                    // Desription about items or subscription
                    Group {
                        // Headline text for item or subscription
                        Text(self.headerText)
                            .font(.title2)
                            .foregroundColor(Color.white)
                        
                        // Sub headline text for item or subscription
                        if let text = self.subHeaderText {
                            Text(text)
                                .font(.headline)
                                .foregroundColor(Color.white)
                        }
                        
                        // Sub text for item or subscription
                        if let text = self.subScriptText1{Text(text).foregroundColor(Color.white)}
                        if let text = self.subScriptText2{Text(text).foregroundColor(Color.white)}
                        if let text = self.subScriptText3{Text(text).foregroundColor(Color.white)}
                        if let text = self.subScriptText4{Text(text).foregroundColor(Color.white)}
                        if let text = self.subScriptText5{Text(text).foregroundColor(Color.white)}
                    }
                    
                    Spacer()
                    
                    // Item/Subscription Pricing.
                    // Pricing data is received from the backend
                    // We ite over each subscription or itemized pricing details
                    HStack {
                        PriceTab(itemId: priceTabs[firstTabKey]?.productIdentifier ?? "NoId",
                                 itemQuantity: firstTabCount,
                                 description: cardName,
                                 pricePerQty: Float(truncating: priceTabs[firstTabKey]?.price ?? 0.0)/Float(firstTabCount),
                                 currency: priceTabs[firstTabKey]?.localizedPrice ?? "USD",
                                 selectedPriceTabId: $selectedPriceTabId,
                                 animation: animation,
                                 priceTabCost: Binding.constant(Float(truncating: priceTabs[firstTabKey]?.price ?? 0.0)),
                                 totalCost:$totalCost,
                                 dictIndex:firstTabKey,
                                 selectedDictIndex:$selectedDictIndex
                        )
                        
                        PriceTab(itemId: priceTabs[secondTabKey]?.productIdentifier ?? "NoId",
                                 itemQuantity: secondTabCount,
                                 description: cardName,
                                 pricePerQty: Float(truncating: priceTabs[secondTabKey]?.price ?? 0.0)/Float(secondTabCount),
                                 currency: priceTabs[secondTabKey]?.localizedPrice ?? "USD",
                                 selectedPriceTabId: $selectedPriceTabId,
                                 animation: animation,
                                 priceTabCost: Binding.constant(Float(truncating: priceTabs[secondTabKey]?.price ?? 0.0)),
                                 totalCost:$totalCost,
                                 dictIndex:secondTabKey,
                                 selectedDictIndex:$selectedDictIndex
                                )
                        
                        PriceTab(itemId: priceTabs[thirdTabKey]?.productIdentifier ?? "NoId",
                                 itemQuantity: thirdTabCount,
                                 description: cardName,
                                 pricePerQty: Float(truncating: priceTabs[thirdTabKey]?.price ?? 0.0)/Float(thirdTabCount),
                                 currency: priceTabs[thirdTabKey]?.localizedPrice ?? "USD",
                                 selectedPriceTabId: $selectedPriceTabId,
                                 animation: animation,
                                 priceTabCost: Binding.constant(Float(truncating: priceTabs[thirdTabKey]?.price ?? 0.0)),
                                 totalCost:$totalCost,
                                 dictIndex:thirdTabKey,
                                 selectedDictIndex:$selectedDictIndex
                                 )
                    }
                    .padding(.top,10)
                    .foregroundColor(Color.white)
                    
                    Spacer()
                    
                    // Buttons
                    /// Buy the subscription or item
                    /// Option to see amore gold
                    /// No Thanks to close the tab
                    Group {
                        
                        // Buy the subscripion or item
                        VStack {
                            
                            // Buy the subscripion or item
                            if UserDefaults.standard.bool(forKey: selectedPriceTabId) {
                               PayButton(buttonText: "Purchased",
                                         cardName: "",
                                         totalCost: Binding.constant(Float(0.0)),
                                         buttonColor: [cardColorFormat[0],cardColorFormat[1]])

                            } else {
                                Button(action: {
                                    storeManager.purchaseProduct(product: priceTabs[selectedDictIndex] ?? SKProduct())
                                }) {
                                    PayButton(buttonText: "\(currency)",
                                       cardName: "Buy",
                                       totalCost: $totalCost,
                                       buttonColor: [cardColorFormat[0],cardColorFormat[1]])
                                }
                                .foregroundColor(.blue)
                            }
                            
                         }
                        
                        Spacer()
                        
                        // Close the card
                        Text("No thanks")
                            .foregroundColor(Color.gray)
                            .onTapGesture {
                                showModal.toggle()
                            }
                            .padding(.top,10)
                    }
                    
                    
                }
                .padding(10)
                .cornerRadius(12)
                .clipped()
                .frame(width: UIScreen.main.bounds.width-50, height: geometry.size.height/1.7)
            }
        
        
    }
    
}


struct PriceTab: View {
    
    @State var itemId: String
    @State var itemQuantity: Int
    @State var description: String
    @State var pricePerQty: Float
    @State var currency: String
    @Binding var selectedPriceTabId: String
    var animation: Namespace.ID
    @Binding var priceTabCost: Float
    @Binding var totalCost: Float
    @State var dictIndex: String
    @Binding var selectedDictIndex: String
    
    var body: some View {
        
        
        Button(action: {
            withAnimation(.spring()){
                selectedPriceTabId = itemId
                totalCost = priceTabCost
                selectedDictIndex = dictIndex
            }
        }) {
            VStack {
                Text(String(self.itemQuantity))
                    .font(.title)
                
                Text(description)
                    .font(.headline)
                
                Divider()
                
                Text("\(currency)")
                    .bold()
            }
            .padding(5)
            .background(
                // For Slide Effect Animation...
                ZStack{
                    if itemId == selectedPriceTabId {
                        Color.blue
                            .clipShape(RoundedRectangle(cornerRadius: 10.0))
                            .matchedGeometryEffect(id: "Tab", in: animation)
                    }
                }
            )
//            .foregroundColor(itemId == selectedPriceTabId ? .white : Color(UIColor.lightGray))
        }
    
    }
}


struct PayButton: View {

    @State var buttonText: String
    @State var cardName: String
    @Binding var totalCost: Float
    @State var buttonColor: [Color]
    
    var body: some View {
    
        ZStack{
            // Box rectangle
            Capsule()
                .fill(LinearGradient(
                    gradient: Gradient(colors:buttonColor),
                    startPoint: .leading,
                    endPoint: .trailing)
                )
                .frame(width:UIScreen.main.bounds.width - 150, height:50)
            
            VStack {
                if totalCost == 0.0 {
                    Text("\(buttonText)")
                } else {
                    Text("\(cardName) for \(String(buttonText.first!)) \(totalCost, specifier: "%.2f")")
                }
            }
            .foregroundColor(Color.white)
            .font(.headline)
        }
        .padding(.top,15)
        
    }
    
}


