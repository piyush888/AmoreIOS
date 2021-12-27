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
    @State var dataArray: [CardProfileWithPhotos]
    @State var selectedTab: TopPicksLikesView
    @State var stringNoDataPresent: String
    @State var viewHeadText: String
    @State var viewHeadIcon: String
    @State var iconColor: Color
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
                
                ScrollView{
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(),spacing: 20), count: 2),spacing: 15){
                       ForEach(dataArray) { profile in
                                    Button{
                                        withAnimation(.spring()){
                                            selectedItem = profile
                                            show.toggle()
                                        }
                                    } label : {
                                        MiniCardView(singleProfile: receivedGivenEliteModel.getProfile(profileId:profile.id!,selectedTab:selectedTab),
                                                     animation: animation,
                                                     geometry:geometry)
                                    }
                            
                            }
                        }
                    .padding()
                }
            }
        }
        
    }
}

