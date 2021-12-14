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
    
    func getProfile(userId:String) -> Binding<CardProfileWithPhotos> {
        switch selectedTab {
            
            case .likesReceived:
                return Binding {
                    cardProfileModel.cardsDictionary[userId] ?? CardProfileWithPhotos()
                } set: { newCard in
                    cardProfileModel.cardsDictionary[userId] = newCard
                }
            
            case .superLikesGive:
                return Binding {
                    receivedGivenEliteModel.superLikesGivenPhotos_Dict[userId] ?? CardProfileWithPhotos()
                } set: { newCard in
                    receivedGivenEliteModel.superLikesGivenPhotos_Dict[userId] = newCard
                }

            case .elitePicks:
                return Binding {
                    cardProfileModel.cardsDictionary[userId] ?? CardProfileWithPhotos()
                } set: { newCard in
                    cardProfileModel.cardsDictionary[userId] = newCard
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
                    
                    ScrollView{
                        
                        VStack{
                            
                            switch selectedTab {
                                
                                case .likesReceived:
                                    LikesReceived(selectedItem:$selectedItem,
                                                  show:$show,
                                                  geometry:geometry)
                                    .environmentObject(cardProfileModel)
                                
                                case .superLikesGive:
                                    LikesGiven(selectedItem:$selectedItem,
                                                  show:$show,
                                                  geometry:geometry)
                                    .environmentObject(receivedGivenEliteModel)
                                
                                case .elitePicks:
                                    LikesReceived(selectedItem:$selectedItem,
                                                  show:$show,
                                                  geometry:geometry)
                                    .environmentObject(cardProfileModel)
                            }
                                    
                        }
                    }
                    Spacer(minLength: 0)
                }
                .opacity(show ? 0 : 1)
                
                if show{
                    if let selectedItemVar = selectedItem {
                        Detail(selectedItem: getProfile(userId:selectedItemVar.id!), show: $show, animation: animation)
                    }
                }
            }
            .background(Color.white.ignoresSafeArea())
        }
    }
}

