//
//  DirectMessageCardView.swift
//  Amore
//
//  Created by Piyush Garg on 03/06/22.
//

import SwiftUI

struct DirectMessageCardView: View {
    @EnvironmentObject var storeManager: StoreManager
    @EnvironmentObject var chatModel: ChatModel
    @State var fromUser: ChatUser
    @State var toUser: ChatUser
    @Binding var cardActive: AllCardsActiveSheet?
    @State var directMessage: String?
    
    private var MessageCountView: some View {
        VStack {
            Text("\(storeManager.purchaseDataDetails.totalMessagesCount.boundInt) Messages Left")
        }
    }
    private var buttonGradient: Array<Color> {
        return storeManager.purchaseDataDetails.totalMessagesCount.boundInt == 0 ? [Color.gray] : [Color.red, Color.pink, Color.white]
    }
    var body: some View {
        
            GeometryReader { geometry in
                
                VStack {
                    
                    HStack {
                        Spacer()
                        Button {
                            cardActive = .none
                        } label: {
                            Text("Cancel")
                        }
                    }.padding(.top)
                    
                    Spacer()
                    MessageCountView
                    Spacer()
                    // Please provide information why you want to report user
                    EditCardForm(formHeight: 100.0,
                                 formHeadLine: "Slide into their DMs with your best pickup line",
                                 formInput: $directMessage)
                        .foregroundColor(Color.black)

                    /**
                     Send Message Button
                     - Assigne chatText
                     - Send Message
                     - Update Firestore purchase records
                     */
                    Button {
                        if storeManager.purchaseDataDetails.totalMessagesCount.boundInt > 0 {
                            chatModel.chatText = directMessage.bound
                            chatModel.handleSend(fromUser: fromUser, toUser: toUser, directMessage: true)
                            storeManager.purchaseDataDetails.totalMessagesCount.boundInt -= 1
                            _ = storeManager.storePurchaseNoParams()
                            cardActive = .none
                            print("Chat: Direct Message Sent")
                        }
                    } label: {
                        ZStack {
                            Capsule()
                                .fill(LinearGradient(
                                    gradient: Gradient(colors: buttonGradient),
                                    startPoint: .leading,
                                    endPoint: .trailing)
                                )
                                .frame(width:geometry.size.width*0.50, height:geometry.size.height/18)
                            
                            VStack {
                                Text("Send Message")
                                    .font(.headline)
                            }
                        }
                        .foregroundColor(.white)
                        
                    }
                    // If no more DMs left, disable the button
                    .disabled(storeManager.purchaseDataDetails.totalMessagesCount.boundInt == 0)
                    
                    Spacer()
                    
                }
                .navigationBarItems(trailing: Button(action: {
                    cardActive = .none
                }) {
                    Text("Done").bold()
                })
                
            }
            .padding(.horizontal)
            .padding(.bottom,20)
    }
}

struct DirectMessageCardView_Previews: PreviewProvider {
    static var previews: some View {
        DirectMessageCardView(fromUser: ChatUser(), toUser: ChatUser(), cardActive: Binding.constant(AllCardsActiveSheet.directMessageSheet))
            .environmentObject(StoreManager())
            .environmentObject(ChatModel())
    }
}
