//
//  TopPicksChild.swift
//  Amore
//
//  Created by Kshitiz Sharma on 12/27/21.
//

import SwiftUI

struct TopPicksChild: View {
    
    @Namespace var animation
    @Binding var selectedItem : CardProfileWithPhotos?
    @Binding var show: Bool
    @Binding var dataArray: [CardProfileWithPhotos]
    @State var selectedTab: TopPicksLikesView
    @Binding var selectedTabSubView: TopPicksLikesSubView
    @State var stringNoDataPresent: String
    @State var viewHeadText: String
    @State var viewHeadIcon: String
    @State var iconColor: Color
    @State var verticalView: Bool
    @EnvironmentObject var receivedGivenEliteModel: ReceivedGivenEliteModel
    @State var geometry: GeometryProxy
    
    var body: some View {
        
        if dataArray.count == 0 {
            VStack {
                
                    Text(stringNoDataPresent)
                        .foregroundColor(Color.gray)
                        .padding([.top,.bottom],20)
                        .font(.headline)
                    
                    Image(systemName: "suit.heart.fill")
                        .foregroundColor(Color.red)
                        .font(.title)
            }
        }
        else {
            VStack {
                
                HStack {
                    Text(viewHeadText)
                        .foregroundColor(Color.gray)
                        .font(.caption)
                    
                    Image(systemName: viewHeadIcon)
                        .foregroundColor(iconColor)
                        .font(.title3)
                }
                
                // Shows card vertically arranged . - KTZ
                if self.verticalView {
                    ScrollView{
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible(),spacing: 10), count: 2),spacing: 10){
                           ForEach(dataArray) { profile in
                                        Button{
                                            withAnimation(.spring()){
                                                self.selectedTabSubView = TopPicksLikesSubView.likesGivenTab
                                                selectedItem = profile
                                                show.toggle()
                                            }
                                        } label : {
                                            MiniCardView(singleProfile: receivedGivenEliteModel.getProfile(profileId:profile.id!,
                                                                                                           selectedTab:selectedTab,
                                                                                                           selectedTabSubView:selectedTabSubView),
                                                         animation: animation,
                                                         geometry:geometry,
                                                         miniCardWidth:geometry.size.width/2.2,
                                                         miniCardHeight:geometry.size.height/3)
                                        }
                                
                                }
                            }
                        .padding()
                        
                    }
                } else {
                    // Shows Card horizontally scaled... Like a carousel... - KTZ
                    ScrollView(.horizontal) {
                    LazyHGrid(rows:  Array(repeating: GridItem(.flexible(),spacing: 10), count: 1), spacing: 10) {
                        ForEach(dataArray) { profile in
                                     Button{
                                         withAnimation(.spring()){
                                             self.selectedTabSubView = TopPicksLikesSubView.superLikesGivenTab
                                             selectedItem = profile
                                             show.toggle()
                                         }
                                     } label : {
                                         MiniCardView(singleProfile: receivedGivenEliteModel.getProfile(profileId:profile.id!,
                                                                                                        selectedTab:selectedTab,
                                                                                                        selectedTabSubView:selectedTabSubView),
                                                      animation: animation,
                                                      geometry:geometry,
                                                      miniCardWidth:geometry.size.width/3.5,
                                                      miniCardHeight:geometry.size.height/4.5)
                                     }
                             
                             }
                    }
                }
                }
                
            }
        }
        
    }
}

