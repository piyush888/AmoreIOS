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
    
    func getProfile(profileId:String) -> Binding<CardProfileWithPhotos> {
        switch selectedTab {
            
            case .likesReceived:
                return Binding {
                    receivedGivenEliteModel.superLikesReceivedPhotos_Dict[profileId] ?? CardProfileWithPhotos()
                } set: { newCard in
                    receivedGivenEliteModel.superLikesReceivedPhotos_Dict[profileId] = newCard
                }
            
            case .superLikesGive:
                return Binding {
                    receivedGivenEliteModel.superLikesGivenPhotos_Dict[profileId] ?? CardProfileWithPhotos()
                } set: { newCard in
                    receivedGivenEliteModel.superLikesGivenPhotos_Dict[profileId] = newCard
                }

            case .elitePicks:
                return Binding {
                    receivedGivenEliteModel.elitesReceivedPhotos_Dict[profileId] ?? CardProfileWithPhotos()
                } set: { newCard in
                    receivedGivenEliteModel.elitesReceivedPhotos_Dict[profileId] = newCard
                }
            
        }
    }
    
    var body: some View {
        
        GeometryReader { geometry in
            ZStack{
                
                VStack{
                    
                    HStack(spacing: 0){
                        Spacer()
                        
                        ForEach(tabs,id: \.self){tab in
                            
                            // Tab Button....
                            TabButton(titleSelected: tab,
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
                            LikesReceived(selectedItem:$selectedItem,
                                          show:$show,
                                          geometry:geometry)
                            .environmentObject(receivedGivenEliteModel)
                        
                        case .superLikesGive:
                            LikesGiven(selectedItem:$selectedItem,
                                          show:$show,
                                          geometry:geometry)
                            .environmentObject(receivedGivenEliteModel)
                        
                        case .elitePicks:
                            Elites(selectedItem:$selectedItem,
                                          show:$show,
                                          geometry:geometry)
                            .environmentObject(receivedGivenEliteModel)
                    }
                    
                                    
                    Spacer(minLength: 0)
                    
                }
                .opacity(show ? 0 : 1)
                
                if show{
                    if let selectedItemVar = selectedItem {
                        ZStack {
                            Detail(selectedItem: getProfile(profileId:selectedItemVar.id!), show: $show, animation: animation)
                            
                            VStack {
                                Spacer()
                                switch selectedTab {
                                    case .likesReceived:
                                        HStack(alignment:.center) {
                                            DislikeButton(profileId:selectedItemVar.id!, show: $show)
                                            SuperLikeButton(profileId:selectedItemVar.id!, show: $show)
                                            LikeButton(profileId: selectedItemVar.id!, show: $show)
                                        }
                                        .padding(.bottom, 30)
                                    
                                    case .superLikesGive:
                                        HStack(alignment:.center) {
                                            SuperLikeButton(profileId:selectedItemVar.id!, show: $show)
                                        }
                                        .padding(.bottom,30)
                                    
                                    case .elitePicks:
                                        HStack(alignment:.center) {
                                            DislikeButton(profileId:selectedItemVar.id!, show: $show)
                                            SuperLikeButton(profileId:selectedItemVar.id!, show: $show)
                                            LikeButton(profileId: selectedItemVar.id!, show: $show)
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
                       message: Text("Action failed, please try again")
                   )
            }
            
        }
    }
}

