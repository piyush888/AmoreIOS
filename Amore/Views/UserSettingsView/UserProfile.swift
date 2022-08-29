//
//  UserProfile.swift
//  Amore
//
//  Created by Kshitiz Sharma on 10/11/21.
//


// Localized Titles a.k.a TabKey are Stored in Apple InApp Purchase Developer account
// Please make sure Localized Titles are always same even when you create new products
// other wise the application will break

// 5 Super Likes
// 15 Super Likes
// 30 Super Likes
// 2 Boosts
// 5 Boosts
// 10 Boosts
// 5 Messages
// 10 Messages
// 15 Messages
// Amore Platinum 1 Month
// Amore Platinum 3 Month
// Amore Platinum 6 Month
// Amore Gold 1 Month
// Amore Gold 3 Month
// Amore Gold 6 Month



import SwiftUI
import StoreKit

struct UserProfile: View {
    
    @EnvironmentObject var profileModel: ProfileViewModel
    @EnvironmentObject var photoModel: PhotoModel
    @EnvironmentObject var storeManager: StoreManager
    @EnvironmentObject var adminAuthenticationModel: AdminAuthenticationViewModel
    
    @State var profileEditingToBeDone: Bool = false
    @State var settingsDone: Bool = false
    @State var showModal = false
    @State var popUpCardSelection: PopUpCards = .superLikeCards
    
    @Environment(\.colorScheme) var colorScheme
    
    var subscriptionDetailColor: Binding<Color> {
        return colorScheme == .dark ? Binding.constant(Color(hex: 0x24244A)): Binding.constant(Color(hex: 0xe8f4f8))
    }
    
    var body: some View {
        
        GeometryReader { geometry in
            
        
            NavigationView {
            
                ZStack {
                        
                    VStack(alignment:.center, spacing:2) {
                        Spacer()
                        
                        // User Data
                        /// Image
                        /// Where user works
                        /// School Attended
                        UserSnapDetails(geometry: geometry)
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
                            .environmentObject(adminAuthenticationModel)
                            .padding(.bottom,10)
                            
                        // Subscription details
                        /// SuperLike : Show count or option to buy
                        /// Boosts: Show count or option to buy
                        /// Messages: Show count and option to buy
                        /// Restore: Restore Purchase
                        SubscriptionDetails(popUpCardSelection:$popUpCardSelection,
                                            showModal:$showModal,
                                            backgroundColor:subscriptionDetailColor)
                            .environmentObject(storeManager)
                            .padding(.bottom,10)
                        
                        
                        // Subscription Options
                        /// User subscription amore
                        /// Amore Platinum Information
                        ///  Amore Gold Information
                        ZStack {
                            Spacer()
                            
                            RoundedRectangle(cornerRadius: 20)
                                .foregroundColor(colorScheme == .dark ? Color(hex: 0x24244A): Color(hex: 0xe8f4f8))
                            VStack(spacing:8) {
                                
                                SubscriptionCardButtons(width: geometry.size.width * 0.75,
                                                        height: geometry.size.height * 0.09,
                                                        popUpCardSelection:$popUpCardSelection,
                                                        showModal: $showModal,
                                                        selectionType:.myAmorecards,
                                                        buttonMainText:"My Amore",
                                                        buttonSubText:"",
                                                        buttonColor:[Color(hex:0xf492f0), Color(hex:0xf9c58d)])
                                
                                
                                
//                                SubscriptionCardButtons(width: geometry.size.width * 0.75,
//                                                        height: geometry.size.height * 0.09,
//                                                        popUpCardSelection:$popUpCardSelection,
//                                                        showModal: $showModal,
//                                                        selectionType:.amorePlatinum,
//                                                        buttonMainText:"Amore Platinum",
//                                                        buttonSubText:"",
//                                                        buttonColor:[Color(hex:0x0b3866), Color(hex:0x83f5e5)])
                                
                                
                                SubscriptionCardButtons(width: geometry.size.width * 0.75,
                                                        height: geometry.size.height * 0.09,
                                                        popUpCardSelection:$popUpCardSelection,
                                                        showModal: $showModal,
                                                        selectionType:.amoreGold,
                                                        buttonMainText:"Amore Gold",
                                                        buttonSubText:"",
                                                        buttonColor:[Color(hex:0xf86ca7), Color(hex:0xf4d444)])
                            }
                            .padding(.vertical,20)
                            
                            Spacer()
                        }
                        
                        Spacer()
                    }
                    .padding(.horizontal,20)
                    .navigationBarHidden(true)
                    
                    if showModal {
                        
                            switch popUpCardSelection {
                                
                                case .superLikeCards :
                                    if let pricingData = storeManager.superLikesPricing {
                                        BuySubscriptionOrItemsCard(cardColorFormat: [Color(hex:0xf86ca7),
                                                                                     Color(hex:0xf4d444),
                                                                                     Color.white],
                                                          cardName: "Super Likes",
                                                          cardHeaderSymbol: "star.circle",
                                                                   cardHeaderSymbolColor: Color.white,
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
                                                          thirdTabCount: 30,
                                                          selectedItemCount: 5,
                                                          popUpCardSelection:$popUpCardSelection
                                                        )
                                                        .environmentObject(storeManager)
                                                        
                                    }
                                
                                case .boostCards :
                                    if let pricingData = storeManager.boostsPricing {
                                        BuySubscriptionOrItemsCard(cardColorFormat:[Color.purple, Color(hex:0xf55a9b), Color.white],
                                                          cardName: "Boosts",
                                                          cardHeaderSymbol: "bolt.circle.fill",
                                                          cardHeaderSymbolColor: Color.white,
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
                                                          thirdTabCount: 10,
                                                          selectedItemCount: 2,
                                                          popUpCardSelection:$popUpCardSelection
                                                        )
                                                        .environmentObject(storeManager)
                                    }
                                
                                case .messagesCards:
                                    if let pricingData = storeManager.messagesPricing {
                                        BuySubscriptionOrItemsCard(cardColorFormat:[Color.red, Color(hex:0xf7a6f5), Color.white],
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
                                                          thirdTabCount: 15,
                                                          selectedItemCount: 5,
                                                          popUpCardSelection:$popUpCardSelection
                                                        )
                                                        .environmentObject(storeManager)
                                    }
                                    
                                case .myAmorecards:
                                    MyAmoreCard(showModal: $showModal,
                                                popUpCardSelection:$popUpCardSelection,
                                                subscriptionTypeId:storeManager.purchaseDataDetails.subscriptionTypeId ?? "Amore.ProductId.12M.Free.v1")
                                    .environmentObject(storeManager)
                                    
                                case .amorePlatinum:
                                    if let pricingData = storeManager.amorePlatinumPricing {
                                        BuySubscriptionOrItemsCard(cardColorFormat:[Color(hex:0x0b3866),Color(hex:0x83f5e5),],
                                                          cardName: "Month",
                                                          cardHeaderSymbol: "bolt.heart.fill",
                                                          cardHeaderSymbolColor: Color.white,
                                                          headerText:"Platinum Subscription",
                                                          subScriptText1:"Top Picks",
                                                          subScriptText2:"",
                                                          subScriptText3:"7 Super likes everyday",
                                                          subScriptText4:"5 Boost a month",
                                                          subScriptText5:"3 messages everyday",
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
                                                          thirdTabCount: 6,
                                                          selectedItemCount: 1,
                                                          popUpCardSelection:$popUpCardSelection
                                                        )
                                                        .environmentObject(storeManager)
                                    }
                                
                                case .amoreGold:
                                if let pricingData = storeManager.amoreGoldPricing {
                                    BuySubscriptionOrItemsCard(cardColorFormat:[Color(hex:0xf86ca7), Color(hex:0xf4d444)],
                                                      cardName: "Month",
                                                      cardHeaderSymbol: "bolt.heart.fill",
                                                      cardHeaderSymbolColor: Color("gold-star"),
                                                      headerText:"Gold Subscription",
                                                      subScriptText1:"Top Picks",
                                                      subScriptText2:"",
                                                      subScriptText3:"5 Super likes everyday",
                                                      subScriptText4:"1 Boost a day",
                                                      subScriptText5:"3 messages everyday",
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
                                                      thirdTabCount: 6,
                                                      selectedItemCount: 1,
                                                      popUpCardSelection:$popUpCardSelection
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
    // priceTabs received the pricingData
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
    @State var selectedItemCount: Int
    @Binding var popUpCardSelection: PopUpCards
    
    
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
                                 selectedItemCount:$selectedItemCount,
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
                                 selectedItemCount:$selectedItemCount,
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
                                 selectedItemCount:$selectedItemCount,
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
                        
                        // Buy Button
                        VStack {
                            
                            if cardName == "Month" {
                                // Subscription
                                if storeManager.purchaseDataDetails.subscriptionTypeId == selectedPriceTabId {
                                    // If Subscription is already purchased
                                    PayButton(buttonText: "Purchased",
                                         cardName: "",
                                         totalCost: Binding.constant(Float(0.0)),
                                         buttonColor: [Color.blue])
//                                buttonColor: [cardColorFormat[0],cardColorFormat[1]]
                                } else {
                                    Button(action: {
                                        self.storeManager.tempPurchaseHold.subscriptionTypeId = priceTabs[selectedDictIndex]?.productIdentifier
                                        self.storeManager.purchaseProduct(product: priceTabs[selectedDictIndex] ?? SKProduct())
                                    }) {
                                        PayButton(buttonText: "\(currency)",
                                           cardName: storeManager.purchaseDataDetails.subscriptionTypeId == "Amore.ProductId.12M.Free.v1" ? "Buy for" : "Update plan",
                                           totalCost: $totalCost,
                                           buttonColor: [Color.blue])
//                                buttonColor: [cardColorFormat[0],cardColorFormat[1]]
                                    }
                                }
                                    
                            } else {
                                // Consumables
                                Button(action: {
                                    if cardName == "Boosts" {
                                        if let purchasedBoostCount = storeManager.purchaseDataDetails.purchasedBoostCount {
                                         self.storeManager.tempPurchaseHold.purchasedBoostCount = purchasedBoostCount + selectedItemCount
                                        }
                                    } else if cardName == "Messages" {
                                        if let purchasedMessagesCount = storeManager.purchaseDataDetails.purchasedMessagesCount {
                                            self.storeManager.tempPurchaseHold.purchasedMessagesCount = purchasedMessagesCount + selectedItemCount
                                        }
                                    } else if cardName == "Super Likes" {
                                        if let purchasedSuperLikesCount = storeManager.purchaseDataDetails.purchasedSuperLikesCount {
                                            self.storeManager.tempPurchaseHold.purchasedSuperLikesCount = purchasedSuperLikesCount + selectedItemCount
                                        }
                                    }
                                    storeManager.purchaseProduct(product: priceTabs[selectedDictIndex] ?? SKProduct())
                                }) {
                                    PayButton(buttonText: "\(currency)",
                                       cardName: "Buy for",
                                       totalCost: $totalCost,
                                       buttonColor: [Color.blue])
                                }
//                                .foregroundColor(.blue)
                            }
                            
                         }
                        
                        Spacer()
                        
                        NoThanksButton(showModal:$showModal,
                                       buttonColor:Color.clear,
                                       fontColor:Color.gray)
                            .padding(.bottom,10)
                    }
                    
                    
                }
                .padding(10)
                .cornerRadius(12)
                .clipped()
                .frame(width: UIScreen.main.bounds.width-50, height: geometry.size.height/1.7)
            }
            .animation(Animation.easeInOut)
        
        
    }
    
}


struct PriceTab: View {
    
    @State var itemId: String
    @State var itemQuantity: Int
    @State var description: String
    @State var pricePerQty: Float
    @State var currency: String
    @Binding var selectedPriceTabId: String
    @Binding var selectedItemCount: Int
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
                selectedItemCount = itemQuantity
            }
        }) {
            VStack {
                Text(String(self.itemQuantity))
                    .font(.title)
                
                Text(description)
//                    .font(.headline)
                
                Divider()
                
                Text("\(currency)")
//                    .bold()
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
                .frame(width:UIScreen.main.bounds.width * 0.45, height:50)
            
            VStack {
                if totalCost == 0.0 {
                    Text("\(buttonText)")
                } else {
                    Text("\(cardName) \(String(buttonText.first!)) \(totalCost, specifier: "%.2f")")
                }
            }
            .foregroundColor(Color.white)
        }
        .padding(.top,15)
        
    }
    
}



