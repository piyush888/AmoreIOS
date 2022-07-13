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
    
    @Binding var selectedTab: TopPicksLikesView
    @State var selectedTabSubView: TopPicksLikesSubView = .likesGivenTab
    @State var tabs: [TopPicksLikesView] = [.likesReceived, .superLikesAndLikesGiven, .elitePicks]
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
                            // Likes Received Vertical Scroll
                            TopPicksChild(selectedItem: $selectedItem,
                                      show: $show,
                                      dataArray: $receivedGivenEliteModel.superLikesReceivedPhotos,
                                      selectedTab: selectedTab,
                                      selectedTabSubView:Binding.constant(TopPicksLikesSubView.none),
                                      stringNoDataPresent: "You have no Super Likes yet, Keep Swiping!!",
                                      viewHeadText: "Super likes received by you",
                                      viewHeadIcon: "star.fill",
                                      iconColor:Color("gold-star"),
                                      verticalView:true,
                                      geometry:geometry)
                            .environmentObject(receivedGivenEliteModel)
                        
                        case .superLikesAndLikesGiven:
                        VStack {
                            // Super Likes Given Carousel
                            TopPicksChild(selectedItem: $selectedItem,
                                  show: $show,
                                  dataArray: $receivedGivenEliteModel.superLikesGivenPhotos,
                                  selectedTab: selectedTab,
                                  selectedTabSubView:$selectedTabSubView,
                                  stringNoDataPresent: "You haven't given any Super Likes yet, Keep Swiping!!",
                                  viewHeadText: "Super likes given by you",
                                  viewHeadIcon: "star.fill",
                                  iconColor:Color("gold-star"),
                                  verticalView:false,
                                  geometry:geometry)
                                .padding(.horizontal,10)
                                .environmentObject(receivedGivenEliteModel)
                                
                            // Likes Given Vertical Scroll
                            TopPicksChild(selectedItem: $selectedItem,
                                  show: $show,
                                  dataArray: $receivedGivenEliteModel.likesGivenPhotos,
                                  selectedTab: selectedTab,
                                  selectedTabSubView:$selectedTabSubView,
                                  stringNoDataPresent: "You haven't given any Likes yet, Keep Swiping!!",
                                  viewHeadText: "Likes given by you",
                                  viewHeadIcon: "heart.fill",
                                  iconColor:Color.red,
                                  verticalView:true,
                                  geometry:geometry)
                                .environmentObject(receivedGivenEliteModel)
                                
                        }
                        
                        case .elitePicks:
                            // Elite Photos Vertical Scroll
                            TopPicksChild(selectedItem: $selectedItem,
                              show: $show,
                              dataArray: $receivedGivenEliteModel.elitesPhotos,
                              selectedTab: selectedTab,
                              selectedTabSubView:Binding.constant(TopPicksLikesSubView.none),
                              stringNoDataPresent: "You have not given any Likes yet, Keep Swiping!!",
                              viewHeadText: "Elite picks for you",
                              viewHeadIcon: "bolt.fill",
                              iconColor:Color.yellow,
                              verticalView:true,
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
                            CardDetail(selectedItem: receivedGivenEliteModel.getProfile(profileId:selectedItemVar.id!,selectedTab: selectedTab, selectedTabSubView:selectedTabSubView),
                                   show: $show,
                                   animation: animation)
                            
                            VStack {
                                Spacer()
                                // Buttons to show which button to show with what view.
                                switch selectedTab {
                                    // Show all dislike, superlike and like button
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
                                    
                                    // when superLikesAndLikesGiven cards are being displayed. Star will be shown
                                    case .superLikesAndLikesGiven:
                                    
                                        switch selectedTabSubView {
                                            case .likesGivenTab:
                                                HStack(alignment:.center) {
                                                    SuperLikeButton(profileId:selectedItemVar.id!,
                                                                    show: $show,
                                                                    showingAlert:$showingAlert,
                                                                    alertMessage:$alertMessage,
                                                                    selectedTab:selectedTab)
                                                        .environmentObject(receivedGivenEliteModel)
                                                }
                                                .padding(.bottom,30)
                                            
                                            case .superLikesGivenTab:
                                                Text("")
                                            
                                            case .none:
                                                Text("")
                                        }
                                    
                                    // Show all dislike, superlike and like button
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
            .alert(isPresented: $showingAlert) {
                   Alert(
                       title: Text(""),
                       message: Text(self.alertMessage)
                   )
            }
            
        }
    }
}

