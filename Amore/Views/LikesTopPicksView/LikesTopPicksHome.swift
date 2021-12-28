//
//  Home.swift
//  Specs
//
//  Created by Balaji on 20/11/20.
//

import SwiftUI

struct LikesTopPicksHome: View {
    
    @Namespace var animation
    @EnvironmentObject var cardProfileModel: CardProfileModel
    @EnvironmentObject var receivedGivenEliteModel: ReceivedGivenEliteModel
    
    @State var selectedTab: TopPicksLikesView = .likesReceived
    @State var tabs: [TopPicksLikesView] = [.likesReceived, .superLikesGive, .elitePicks]
    @State var selectedItem : CardProfileWithPhotos? = nil
    
    @State var show = false
    @State var showingAlert: Bool = false
    @State var alertMessage: String = ""
        
    var body: some View {
        
        GeometryReader { geometry in
            ZStack{
                
                VStack{
                    
                    HStack(spacing: 0){
                        Spacer()
                        
                        ForEach(tabs,id: \.self){tab in
                            
                            // Tab Button....
                            // Likes received, Likes given, Elite Picks
                            TabButtonMenu(titleSelected: tab,
                                      selectedTab: $selectedTab,
                                      animation: animation)
                            
                            // even spacing....
                            if tabs.last != tab{Spacer(minLength: 0)}
                        }
                        Spacer()
                    }
                    .padding()
                    .padding(.top,5)
                    
                    
                    switch selectedTab {
                        
                        case .likesReceived:
                            TopPicksChild(selectedItem: $selectedItem,
                                      show: $show,
                                      dataArray: $receivedGivenEliteModel.superLikesReceivedPhotos,
                                      selectedTab: selectedTab,
                                      stringNoDataPresent: "You have no Super Likes yet, Keep Swiping!!",
                                      viewHeadText: "Super likes received by you",
                                      viewHeadIcon: "star.fill",
                                      iconColor:Color("gold-star"),
                                      geometry:geometry)
                            .environmentObject(receivedGivenEliteModel)
                        
                        case .superLikesGive:
                            TopPicksChild(selectedItem: $selectedItem,
                                  show: $show,
                                  dataArray: $receivedGivenEliteModel.superLikesGivenPhotos,
                                  selectedTab: selectedTab,
                                  stringNoDataPresent: "You have not given any Likes yet, Keep Swiping!!",
                                  viewHeadText: "Super likes given by you",
                                  viewHeadIcon: "heart.fill",
                                  iconColor:Color.red,
                                  geometry:geometry)
                                .environmentObject(receivedGivenEliteModel)
                        
                        case .elitePicks:
                            TopPicksChild(selectedItem: $selectedItem,
                              show: $show,
                              dataArray: $receivedGivenEliteModel.elitesReceivedPhotos,
                              selectedTab: selectedTab,
                              stringNoDataPresent: "You have not given any Likes yet, Keep Swiping!!",
                              viewHeadText: "Elite picks you",
                              viewHeadIcon: "bolt.fill",
                              iconColor:Color.yellow,
                              geometry:geometry)
                            .environmentObject(receivedGivenEliteModel)
                    }
                    
                                    
                    Spacer(minLength: 0)
                    
                }
                .opacity(show ? 0 : 1)
                
                if show{
                    if let selectedItemVar = selectedItem {
                        ZStack {
                            // Open the pop up window which expand every Mini Card
                            CardDetail(selectedItem: receivedGivenEliteModel.getProfile(profileId:selectedItemVar.id!,selectedTab: selectedTab),
                                   show: $show,
                                   animation: animation)
                            
                            VStack {
                                Spacer()
                                switch selectedTab {
                                    case .likesReceived:
                                        HStack(alignment:.center) {
                                            
                                            DislikeButton(profileId:selectedItemVar.id!,
                                                          show: $show,
                                                          showingAlert:$showingAlert,
                                                          alertMessage:$alertMessage,
                                                          selectedTab:selectedTab)
                                                .environmentObject(receivedGivenEliteModel)
                                            
                                            SuperLikeButton(profileId:selectedItemVar.id!,
                                                            show: $show,
                                                            showingAlert:$showingAlert,
                                                            alertMessage:$alertMessage,
                                                            selectedTab:selectedTab)
                                                .environmentObject(receivedGivenEliteModel)
                                            
                                            LikeButton(profileId: selectedItemVar.id!,
                                                       show: $show,
                                                       showingAlert:$showingAlert,
                                                       alertMessage:$alertMessage,
                                                       selectedTab:selectedTab)
                                                .environmentObject(receivedGivenEliteModel)
                                            
                                        }
                                        .padding(.bottom, 30)
                                    
                                    case .superLikesGive:
                                        HStack(alignment:.center) {
                                            SuperLikeButton(profileId:selectedItemVar.id!,
                                                            show: $show,
                                                            showingAlert:$showingAlert,
                                                            alertMessage:$alertMessage,
                                                            selectedTab:selectedTab)
                                                .environmentObject(receivedGivenEliteModel)
                                        }
                                        .padding(.bottom,30)
                                    
                                    case .elitePicks:
                                        HStack(alignment:.center) {
                                            DislikeButton(profileId:selectedItemVar.id!,
                                                          show: $show,
                                                          showingAlert:$showingAlert,
                                                          alertMessage:$alertMessage,
                                                          selectedTab:selectedTab)
                                                .environmentObject(receivedGivenEliteModel)
                                            
                                            SuperLikeButton(profileId:selectedItemVar.id!,
                                                            show: $show,
                                                            showingAlert:$showingAlert,
                                                            alertMessage:$alertMessage,
                                                            selectedTab:selectedTab)
                                                .environmentObject(receivedGivenEliteModel)
                                            
                                            LikeButton(profileId: selectedItemVar.id!,
                                                       show: $show,
                                                       showingAlert:$showingAlert,
                                                       alertMessage:$alertMessage,
                                                       selectedTab:selectedTab)
                                                .environmentObject(receivedGivenEliteModel)
                                        }
                                        .padding(.bottom, 30)
                                }
                            }
                            
                        }
                    }
                }
            }
            .background(Color.white.ignoresSafeArea())
            .alert(isPresented: $showingAlert) {
                   Alert(
                       title: Text(""),
                       message: Text(self.alertMessage)
                   )
            }
            
        }
    }
}

