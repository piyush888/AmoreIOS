//
//  LikesGiven.swift
//  Amore
//
//  Created by Kshitiz Sharma on 12/12/21.
//

import SwiftUI

struct LikesGiven: View {
    
    @EnvironmentObject var receivedGivenEliteModel: ReceivedGivenEliteModel
    @Namespace var animation
    @Binding var selectedItem : CardProfileWithPhotos?
    @Binding var show: Bool
    @State var geometry: GeometryProxy
    
    func getProfile(userId:String) -> Binding<CardProfileWithPhotos> {
        return Binding {
            receivedGivenEliteModel.superLikesGivenPhotos_Dict[userId] ?? CardProfileWithPhotos()
        } set: { newCard in
            receivedGivenEliteModel.superLikesGivenPhotos_Dict[userId] = newCard
        }
    }
    
    var body: some View {
        
        LazyVGrid(columns: Array(repeating: GridItem(.flexible(),spacing: 20), count: 2),spacing: 25){
        
            ForEach(receivedGivenEliteModel.superLikesGivenPhotos) { profile in
                
                    Button{
                        withAnimation(.spring()){
                            selectedItem = profile
                            show.toggle()
                        }
                    } label : {
                        MiniCardView(singleProfile: getProfile(userId:profile.id!),
                                     animation: animation,
                                     geometry:geometry)
                    }
            
            }
        }
        .padding()
        
    }
}

