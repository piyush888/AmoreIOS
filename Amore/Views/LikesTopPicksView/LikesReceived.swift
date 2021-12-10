//
//  LikesReceived.swift
//  Amore
//
//  Created by Kshitiz Sharma on 12/9/21.
//

import SwiftUI

struct LikesReceived: View {
    
    @Namespace var animation
    @Binding var selectedItem : CardProfileWithPhotos?
    @Binding var show: Bool
    @EnvironmentObject var cardProfileModel: CardProfileModel
    @State var geometry: GeometryProxy
    
    func getProfile(userId:String) -> Binding<CardProfileWithPhotos> {
        return Binding {
            cardProfileModel.cardsDictionary[userId] ?? CardProfileWithPhotos()
        } set: { newCard in
            cardProfileModel.cardsDictionary[userId] = newCard
        }
    }
    
    
    var body: some View {
        
        LazyVGrid(columns: Array(repeating: GridItem(.flexible(),spacing: 20), count: 2),spacing: 25){
        
            ForEach(cardProfileModel.allCardsWithPhotosDeck) { profile in
                
                    Button{
                        withAnimation(.spring()){
                            selectedItem = profile
                            show.toggle()
                        }
                    } label : {
                        MiniCardView(singleProfile: getProfile(userId:profile.id!),
                                     animation: animation,
                                     geometry:geometry)
                            .environmentObject(cardProfileModel)
                    }
            
            }
        }
        .padding()
        
    }
}

