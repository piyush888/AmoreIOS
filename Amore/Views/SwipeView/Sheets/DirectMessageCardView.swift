//
//  DirectMessageCardView.swift
//  Amore
//
//  Created by Piyush Garg on 03/06/22.
//

import SwiftUI
import StoreKit
import RiveRuntime

struct DirectMessageCardView: View {
    
    @EnvironmentObject var storeManager: StoreManager
    @EnvironmentObject var chatViewModel: ChatViewModel
    @State var fromUser: ChatUser
    @State var toUser: ChatUser
    @Binding var allcardsActiveSheet: AllCardsActiveSheet?
    @Binding var buttonSwipeStatus: AllCardsView.LikeDislike
    
    @State var directMessage = ""
    let button = RiveViewModel(fileName: "button", autoPlay: false)
    @State private var info: AlertInfo?
    
    private var MessageCountView: some View {
        Text("\(storeManager.purchaseDataDetails.purchasedMessagesCount.boundInt + storeManager.purchaseDataDetails.subscriptionMessageCount.boundInt)")
    }
    
    private var buttonGradient: Array<Color> {
        return (storeManager.purchaseDataDetails.purchasedMessagesCount.boundInt + storeManager.purchaseDataDetails.subscriptionMessageCount.boundInt) == 0 ? [Color.gray] : [Color.red, Color.pink, Color.white]
    }
    
    var totalMessagesCount: Int {
        let purchasedMessagesCount =  self.storeManager.purchaseDataDetails.purchasedMessagesCount.boundInt
        let subscriptionMessageCount =  self.storeManager.purchaseDataDetails.subscriptionMessageCount.boundInt
        return purchasedMessagesCount+subscriptionMessageCount
    }
    
    func consumeAMessage() {
        // Since Subscriptions expire everyday, make sure to consume the dail subscriptions first before consuming the purcahses
        if let subscriptionMessageCount = storeManager.purchaseDataDetails.subscriptionMessageCount {
            if subscriptionMessageCount > 0 {
                storeManager.purchaseDataDetails.subscriptionMessageCount.boundInt -= 1
            } else {
                if let purchasedMessagesCount = storeManager.purchaseDataDetails.purchasedMessagesCount {
                    if purchasedMessagesCount > 0 {
                        storeManager.purchaseDataDetails.purchasedMessagesCount.boundInt -= 1
                    }
                }
            }
        }
    }
    
    var body: some View {
        
            GeometryReader { geometry in
                
                VStack {
                    
                    // Done Button
                    HStack {
                        Spacer()
                        Button {
                            allcardsActiveSheet = nil
                        } label: {
                            DoneButton()
                        }
                    }.padding()
                    
                    VStack(spacing: 16) {
                        Image(systemName: "message.circle.fill")
                            .resizable()
                            .frame(width:50, height:50)
                            .foregroundColor(Color(hex:0xFA86C4))

                        HStack {
                            Text("You've")
                            MessageCountView
                            Text("Messages")
                        }.font(.largeTitle)
                        
                        Text("Slide into their DMs with your best pickup line")
                        Text("Your message request will be directly delivered to other users message box. They can choose to accept or reject your request after reviewing your profile.")
                            .customFont(.footnote)
                            .opacity(0.7)
                            .padding(.horizontal,20)
                    }
                    
                    // Please provide information why you want to report user
                    TextEditor(text: $directMessage)
                        .frame(height: 100.0)
                        .cornerRadius(20)
                        .shadow(color: .purple, radius: 20)
                        .padding(10)
                        
                        
                    /**
                     Send Message Button
                     - Assigne chatText
                     - Send Message
                     - Update Firestore purchase records
                     */
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
                                Text("Send request")
                                    .foregroundColor(Color.blue)
                                    .bold()
                                Image(systemName: "paperplane.circle.fill")
                                    .font(.system(size: 30))
                                    .foregroundColor(Color(hex:0xFA86C4))
                            }
                            .offset(x: 4, y: 4)
                            .font(.title3)
                        )
                        .onTapGesture {
                            try? button.play(animationName: "active")
                            
                            // Don't allow user to send a blank message
                            if directMessage.count == 0 {
                                info = AlertInfo(
                                    id: .one,
                                        title: "Try again",
                                        message: "Please enter a message before sending",
                                        dismissButton: Alert.Button.default(
                                            Text("Okay"),
                                            action: {
                                                print(".one")
                                            })
                                    )
                            }
                            else {
                                // if the message count is not 0
                                if self.totalMessagesCount > 0 {
                                    chatViewModel.chatText = directMessage
                                    chatViewModel.handleSend(fromUser: fromUser, toUser: toUser, directMessage: true, type:"text")
                                    self.consumeAMessage()
                                    _ = storeManager.storePurchaseNoParams()
                                    directMessage = ""
                                    info = AlertInfo(
                                            id: .three,
                                            title: "Success !!",
                                            message: "Your message was successfully sent to \(toUser.firstName.bound). Keep swiping, Happy finding a Match !!!",
                                            dismissButton: Alert.Button.default(
                                                Text("Okay"),
                                                action: {
                                                    allcardsActiveSheet = nil
                                                    buttonSwipeStatus = .like
                                                })
                                        )
                                }
                                else {
                                    // If the message count is 0
                                    info = AlertInfo(
                                            id: .two,
                                            title: "Oh Oh Sorry !!",
                                            message: "Please purcahse a message to send a request",
                                            dismissButton: Alert.Button.default(
                                                Text("Okay"),
                                                action: {
                                                   print(".two")
                                                })
                                            )
                                }
                                try? button.reset()
                            }
                        }
                    
                    
                    
                    Spacer()
                    
                    // Divider
                    HStack {
                        Rectangle().frame(height: 1).opacity(0.1)
                        Text("OR").customFont(.subheadline2).foregroundColor(.black.opacity(0.3))
                        Rectangle().frame(height: 1).opacity(0.1)
                    }
                    
                    Spacer()
                    
                    // Give user option to buy messages here
                    VStack {
                        if let pricingData = storeManager.messagesPricing {
                            // TODO: Change the name of common class to something more generic from BoostBuyButton to CommonBuyButton - Ktz
                            DirectMessageBuyButton(messageCount:5.0,
                                           totalCost: Float(truncating: pricingData["5 Messages"]?.price ?? 0.0),
                                           currency: pricingData["5 Messages"]?.localizedPrice?.first ?? "$",
                                           skProductObj: pricingData["5 Messages"] ?? SKProduct())
                                .frame(width: geometry.size.width*0.80)
                                .environmentObject(storeManager)
                        

                            DirectMessageBuyButton(messageCount:10.0,
                                           totalCost: Float(truncating: pricingData["10 Messages"]?.price ?? 0.0),
                                           currency: pricingData["10 Messages"]?.localizedPrice?.first ?? "$",
                                           skProductObj: pricingData["10 Messages"] ?? SKProduct())
                                .frame(width: geometry.size.width*0.80)
                                .environmentObject(storeManager)
                        }
                        
                    }
                    
                }
                
            }
            .padding(.horizontal)
            .background(
                Image("Spline")
                    .blur(radius: 50)
                    .offset(x: 200, y: 100)
            )
            .alert(item: $info, content: { info in
                        Alert(title: Text(info.title),
                              message: Text(info.message),
                              dismissButton:info.dismissButton
                        )
                }
            )
        
    }
}




struct AlertInfo: Identifiable {

    enum AlertType {
        case one
        case two
        case three
    }
    
    let id: AlertType
    let title: String
    let message: String
    let dismissButton: Alert.Button
}



struct DirectMessageCardView_Previews: PreviewProvider {
    static var previews: some View {
        DirectMessageCardView(fromUser: ChatUser(),
                              toUser: ChatUser(),
                              allcardsActiveSheet: Binding.constant(AllCardsActiveSheet.directMessageSheet),
                              buttonSwipeStatus:Binding.constant(AllCardsView.LikeDislike.none))
            .environmentObject(StoreManager())
            .environmentObject(ChatViewModel())
    }
}


struct DirectMessageBuyButton: View {
    @EnvironmentObject var storeManager: StoreManager
    // Recieves [5, 10, 15] which is used to refer 5 Messages, 10 Messages and 15 Messages
    @State var messageCount: Float = 0.0
    @State var totalCost:Float = 0.0
    @State var currency: Character // Receives Dollar Sign
    @State var skProductObj: SKProduct = SKProduct()
    
    var body: some View {
        
            Button {
                if let purchasedMessagesCount = storeManager.purchaseDataDetails.purchasedMessagesCount {
                    self.storeManager.tempPurchaseHold.purchasedMessagesCount = purchasedMessagesCount + Int(messageCount)
                    // Purchase the product by passing in the Sk Product Object
                    storeManager.purchaseProduct(product:skProductObj)
                }
            } label : {
                
                VStack {
                        HStack {
                            Text("Buy \(messageCount, specifier: "%.2f")")
                            Image(systemName: "message.circle.fill")
                            Text("for \(String(currency))\(totalCost, specifier: "%.2f")")
                        }
                    }
                    .purcahseButton()
            }

        }
}
