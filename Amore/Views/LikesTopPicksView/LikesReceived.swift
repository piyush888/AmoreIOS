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
    @EnvironmentObject var receivedGivenEliteModel: ReceivedGivenEliteModel
    @State var geometry: GeometryProxy
    
    func getProfile(userId:String) -> Binding<CardProfileWithPhotos> {
        return Binding {
            receivedGivenEliteModel.superLikesReceivedPhotos_Dict[userId] ?? CardProfileWithPhotos()
        } set: { newCard in
            receivedGivenEliteModel.superLikesReceivedPhotos_Dict[userId] = newCard
        }
    }
    
    var body: some View {
        
        if receivedGivenEliteModel.superLikesReceivedPhotos.count == 0 {
            VStack {
                
                    Text("You have no Super Likes yet, Keep Swiping!!")
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
                    Text("Super likes received by you")
                        .foregroundColor(Color.gray)
                        .font(.caption)
                    
                    Image(systemName: "star.fill")
                        .foregroundColor(Color("gold-star"))
                        .font(.title3)
                }
                
                ScrollView{
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(),spacing: 20), count: 2),spacing: 10){
                       ForEach(receivedGivenEliteModel.superLikesReceivedPhotos) { profile in
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
    }
}

