//
//  Elites.swift
//  Amore
//
//  Created by Kshitiz Sharma on 12/26/21.
//

import SwiftUI

struct Elites: View {
    
    @EnvironmentObject var receivedGivenEliteModel: ReceivedGivenEliteModel
    @Namespace var animation
    @Binding var selectedItem : CardProfileWithPhotos?
    @Binding var show: Bool
    @State var geometry: GeometryProxy
    
    func getProfile(userId:String) -> Binding<CardProfileWithPhotos> {
        return Binding {
            receivedGivenEliteModel.elitesReceivedPhotos_Dict[userId] ?? CardProfileWithPhotos()
        } set: { newCard in
            receivedGivenEliteModel.elitesReceivedPhotos_Dict[userId] = newCard
        }
    }
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(),spacing: 20), count: 2),spacing: 10){
            
                ForEach(receivedGivenEliteModel.elitesReceivedPhotos) { profile in
                    
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
}

