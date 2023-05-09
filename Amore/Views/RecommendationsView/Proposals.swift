//
//  Proposals.swift
//  Amore
//
//  Created by Kshitiz Sharma on 5/9/23.
//

import SwiftUI
import Firebase

struct ProposalsHome: View {
    
    @Namespace var animation
    @EnvironmentObject var cardProfileModel: CardProfileModel
    @EnvironmentObject var receivedGivenEliteModel: ReceivedGivenEliteModel
    @EnvironmentObject var profileModel: ProfileViewModel
    @EnvironmentObject var chatViewModel: ChatViewModel
    @EnvironmentObject var storeManager: StoreManager
    
    @Binding var selectedTab: ProposalsView
    @State var tabs: [ProposalsView] = [.likesReceived, .superLikesAndLikesGiven]
    @State var selectedItem : CardProfileWithPhotos? = nil
    
    @State var show = false
    @State var showingAlert: Bool = false
    @State var alertMessage: String = ""
    @State var allcardsActiveSheet: AllCardsActiveSheet?
    
    @State var profileForChat: CardProfileWithPhotos = CardProfileWithPhotos()
    
    var body: some View {
        
        GeometryReader { geometry in
            ZStack{
                
                VStack{
                    // Tabs: Likes Received, Likes Given, Elites
                    HStack(spacing: 0){
                        Spacer()
                        
                        ForEach(tabs,id: \.self){tab in
                            
                            // Tab Button....
                            // Likes received, Likes given, Elite Picks
                            ProposalTabMenu(titleSelected: tab,
                                      selectedTab: $selectedTab,
                                      animation: animation)
                            
                            // even spacing....
                            if tabs.last != tab{Spacer(minLength: 0)}
                        }
                        Spacer()
                    }
                    .padding()
                    .padding(.top,5)
                    
                    // Views to be displayed for each of the above tab selected
                    switch selectedTab {
                         
                        case .likesReceived:
                            ZStack {
                                ScrollView{
                                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(),spacing: 10), count: 2),spacing: 10){
                                        ForEach(receivedGivenEliteModel.superLikesReceivedPhotos) { profile in
                                            Button{
                                                withAnimation(.spring()){
                                                    selectedItem = profile
                                                    show = true
                                                }
                                            } label : {
                                                MiniCardView(singleProfile: profile,
                                                             animation: animation,
                                                             geometry:geometry,
                                                             miniCardWidth:geometry.size.width/2.2,
                                                             miniCardHeight:geometry.size.height/3)
                                            }
                                        }
                                    }
                                    .padding()
                                }
                            }
                            
                        case .superLikesAndLikesGiven:
                            ZStack {
                                ScrollView{
                                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(),spacing: 10), count: 1),spacing: 10){
                                        ForEach(receivedGivenEliteModel.likesGivenPhotos) { profile in
                                            Button{
                                                withAnimation(.spring()){
                                                    selectedItem = profile
                                                    show = true
                                                }
                                            } label : {
                                                MiniCardView(singleProfile: profile,
                                                             animation: animation,
                                                             geometry:geometry,
                                                             miniCardWidth:geometry.size.width,
                                                             miniCardHeight:geometry.size.height/4)
                                            }
                                        }
                                    }
                                    .padding()
                                }
                                
                            }
                            
                    }
                    Spacer(minLength: 0)
                    
                }
                .opacity(show ? 0 : 1)
                
                // Button functionalities for each of the above views
                if show {
                    if let selectedProfile = selectedItem {
                        ZStack {
                            ChildCardView(singleProfile: selectedProfile,
                                          swipeStatus: Binding.constant(AllCardsView.LikeDislike.none),
                                          cardColor: Binding.constant(Color.pink))
                        }
                    }
                }
            }
            .alert(isPresented: $showingAlert) {
                   Alert(
                       title: Text(""),
                       message: Text(self.alertMessage)
                   )
            }
            .sheet(item: $allcardsActiveSheet) { item in
                
                switch item {
                    case .buyMoreSuperLikesSheet:
                        Text("Empty View buyMoreSuperLikesSheet")
                    
                    case .reportProfileSheet:
                        Text("Empty View reportProfileSheet")
                    
                    case .boostProfileSheet:
                        Text("Empty View boostProfileSheet")
//                    TODO: Logic for directMessageSent needs to be implemented
                    case .directMessageSheet:
                        DirectMessageCardView(
                            fromUser: ChatUser(id: Auth.auth().currentUser?.uid,
                                               firstName: profileModel.editUserProfile.firstName,
                                               lastName: profileModel.editUserProfile.lastName,
                                               image1: profileModel.editUserProfile.image1),
                            toUser: ChatUser(id: profileForChat.id,
                                             firstName: profileForChat.firstName,
                                             lastName: profileForChat.lastName,
                                             image1: profileForChat.image1),
                            allcardsActiveSheet: $allcardsActiveSheet,
                            directMessageSent: Binding.constant(false))
                            .environmentObject(chatViewModel)
                            .environmentObject(storeManager)
                
                    case .buyMoreRewindsSheet:
                        Text("Empty view .buyMoreRewindsSheet")
                    
                    case .purchaseSuccessfull:
                        Text("Empty view .purchaseSuccessfull")
                }
            }
        }
    }
    
    
}




struct ProposalTabMenu: View {
    
    @State var titleSelected: ProposalsView
    @Binding var selectedTab: ProposalsView
    var animation: Namespace.ID
    
    var body: some View {
        
        Button(action: {
            withAnimation(.spring()){
                selectedTab = titleSelected
            }
        }) {
            
            Text("\(titleSelected.rawValue)")
                .font(.system(size: 15))
                .bold()
                .foregroundColor(selectedTab == titleSelected ? .white : .gray)
                .padding(.vertical,10)
                .padding(.horizontal,selectedTab == titleSelected ? 20 : 0)
                .background(
                
                    // For Slide Effect Animation...
                    
                    ZStack{
                        
                        if selectedTab == titleSelected {
                            
                            Color.blue
                                .clipShape(Capsule())
                                .matchedGeometryEffect(id: "Tab", in: animation)
                        }
                    }
                )
        }
    }
}

