//
//  UserProfile.swift
//  Amore
//
//  Created by Kshitiz Sharma on 10/11/21.
//

import SwiftUI

struct UserProfile: View {
    
    @EnvironmentObject var profileModel: ProfileViewModel
    @EnvironmentObject var photoModel: PhotoModel
    @EnvironmentObject var stripeModel: StripeModel
    
    @State var profileEditingToBeDone: Bool = false
    @State var settingsDone: Bool = false
    @State var showModal = false
    @State var popUpCardSelection: PopUpCards = .superLikeCards
    
    var body: some View {
        
        NavigationView {
            
            GeometryReader { geometry in
                
                ZStack {
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
                    
                    
                    if showModal {
                        
                        if let pricingData = stripeModel.pricingData {
                            
                            switch popUpCardSelection {
                                
                                case .superLikeCards :
                                    BuySubscriptionOrItemsCard(cardColorFormat:[Color.purple, Color.blue, Color.white],
                                                      cardName: "Super Likes",
                                                      cardHeaderSymbol:"star.circle",
                                                      cardHeaderSymbolColor:Color("gold-star"),
                                                      headerText:"Stand out with Super Like",
                                                      subHeaderText:"You're 3x likely to get a match!!",
                                                      showModal: $showModal,
                                                      geometry:geometry,
                                                      priceTabs: pricingData.superLikesPricing,
                                                      selectedPriceTabId: pricingData.superLikesPricing[1].id,
                                                      currency: pricingData.superLikesPricing[1].currency,
                                                      totalCost:Float(pricingData.superLikesPricing[1].itemQuantity) * pricingData.superLikesPricing[1].pricePerQty
                                                    )
                                
                                case .boostCards :
                                    BuySubscriptionOrItemsCard(cardColorFormat:[Color.yellow, Color.orange, Color.white],
                                                  cardName: "Boost",
                                                  cardHeaderSymbol:"bolt.circle.fill",
                                                               cardHeaderSymbolColor:Color.blue,
                                                  headerText:"Skip the queue",
                                                  subHeaderText:"Be on top of the deck for 30 minutes",
                                                  showModal: $showModal,
                                                  geometry:geometry,
                                                  priceTabs: pricingData.boostPricing,
                                                  selectedPriceTabId: pricingData.boostPricing[1].id,
                                                  currency: pricingData.boostPricing[1].currency,
                                                  totalCost:Float(pricingData.boostPricing[1].itemQuantity) * pricingData.boostPricing[1].pricePerQty
                                                )
                                
                                case .messagesCards:
                                    BuySubscriptionOrItemsCard(cardColorFormat:[Color.red, Color.pink, Color.white],
                                              cardName: "Messages",
                                              cardHeaderSymbol:"message.circle.fill",
                                                           cardHeaderSymbolColor:Color.white,
                                              headerText:"Be in their DM",
                                              subHeaderText:"Get noticed, say something nice",
                                              showModal: $showModal,
                                              geometry:geometry,
                                              priceTabs: pricingData.messagesPricing,
                                              selectedPriceTabId: pricingData.messagesPricing[1].id,
                                              currency: pricingData.messagesPricing[1].currency,
                                              totalCost:Float(pricingData.messagesPricing[1].itemQuantity) * pricingData.messagesPricing[1].pricePerQty
                                            )
                                    
                                case .myAmorecards:
                                    MyAmoreCard(showModal: $showModal,
                                                popUpCardSelection:$popUpCardSelection)
                                    
                                case .amorePlatinum:
                                    BuySubscriptionOrItemsCard(cardColorFormat:[Color.black,Color.white],
                                          cardName: "Amore Platinum",
                                          cardHeaderSymbol:"bolt.heart.fill",
                                          cardHeaderSymbolColor:Color.white,
                                          headerText:"Amore Platinum",
                                          subScriptText1:"Top Picks",
                                          subScriptText2:"Unlimited Likes",
                                          subScriptText3:"10 Super likes everyday",
                                          subScriptText4:"5 Boost a month",
                                          subScriptText5:"2 messages everyday",
                                          showModal: $showModal,
                                          geometry:geometry,
                                          priceTabs: pricingData.amorePlatinumPricing,
                                          selectedPriceTabId: pricingData.amorePlatinumPricing[1].id,
                                          currency: pricingData.amorePlatinumPricing[1].currency,
                                          totalCost:Float(pricingData.amorePlatinumPricing[1].itemQuantity) * pricingData.amorePlatinumPricing[1].pricePerQty
                                        )
                                
                                case .amoreGold:
                                    BuySubscriptionOrItemsCard(cardColorFormat:[Color.red,Color.yellow],
                                      cardName: "Amore Gold",
                                      cardHeaderSymbol:"bolt.heart.fill",
                                      cardHeaderSymbolColor:Color("gold-star"),
                                      headerText:"Amore Gold",
                                      subScriptText1:"Top Picks",
                                      subScriptText2:"500 Likes everyday",
                                      subScriptText3:"5 Super likes everyday",
                                      subScriptText4:"2 Boost a month",
                                      subScriptText5:"1 messages everyday",
                                      showModal: $showModal,
                                      geometry:geometry,
                                      priceTabs: pricingData.amoreGoldPricing,
                                      selectedPriceTabId: pricingData.amoreGoldPricing[1].id,
                                      currency: pricingData.amoreGoldPricing[1].currency,
                                      totalCost:Float(pricingData.amoreGoldPricing[1].itemQuantity) * pricingData.amoreGoldPricing[1].pricePerQty
                                    )
                                                      
                                } // switch statement
                            } // check for nil
                        } // show modal
                        
                } // Zstack
            } // geometry reader
        } // navigation view
    }
    
}


// Template to display cards - this view is used by all the subscription & individualized item buying cards
struct BuySubscriptionOrItemsCard : View {
    
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
    @State var priceTabs: [SubscriptionItemPricing]
    @State var selectedPriceTabId: String
    @State var currency: String
    @State var totalCost: Float
    
    var body: some View {
        
            ZStack{
                
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
                        ForEach(priceTabs, id:\.self) { priceTab in
                            PriceTab(itemId:priceTab.id,
                                     itemQuantity: priceTab.itemQuantity,
                                     description: priceTab.description,
                                     pricePerQty: priceTab.pricePerQty,
                                     currency: priceTab.currency,
                                     selectedPriceTabId: $selectedPriceTabId,
                                     animation: animation,
                                     totalCost: $totalCost)
                        }
                        
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
                        ZStack{
                            Capsule()
                                .fill(LinearGradient(
                                    gradient: Gradient(colors: [cardColorFormat[0],cardColorFormat[1]]),
                                    startPoint: .leading,
                                    endPoint: .trailing)
                                )
                                .frame(width:UIScreen.main.bounds.width - 150, height:50)
                            
                            VStack {
                                Text("Buy \(currency) \(totalCost, specifier: "%.1f")")
                                    .foregroundColor(Color.white)
                                    .font(.headline)
                            }
                        }
                        .padding(.top,15)
                        
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
    @Binding var totalCost: Float
    
    var body: some View {
        
        
        Button(action: {
            withAnimation(.spring()){
                selectedPriceTabId = itemId
            }
            totalCost = Float(itemQuantity) * pricePerQty
        }) {
            VStack {
                Text(String(self.itemQuantity))
                    .font(.title)
                
                Text(description)
                    .font(.subheadline)
                
                Divider()
                
                Text("\(currency) \(pricePerQty, specifier: "%.1f")/ea")
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
