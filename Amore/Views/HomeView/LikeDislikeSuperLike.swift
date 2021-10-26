//
//  LikeDislikeSuperLike.swift
//  Amore
//
//  Created by Kshitiz Sharma on 10/6/21.
//

import SwiftUI

struct LikeDislikeSuperLike: View {
    
    @Binding var curSwipeStatus: AllCardsView.LikeDislike
    
    var body: some View {
        
        HStack {
            
            Button {
                
            } label: {
                Image(systemName: "arrow.uturn.backward")
                    .resizable()
                    .frame(width:25, height:25)
                    .foregroundColor(.orange)
            }

            Spacer()
            
            Button {
                curSwipeStatus = AllCardsView.LikeDislike.dislike
            } label: {
                Image(systemName: "xmark.circle")
                    .resizable()
                    .frame(width:44, height:44)
                    .foregroundColor(.gray)
                    .padding(.horizontal)
            }
            
            Spacer()
            
            Button {
                
            } label: {
                Image(systemName: "star.circle")
                    .resizable()
                    .frame(width:35, height:35)
                    .foregroundColor(Color("gold-star"))
            }

            Spacer()
            
            Button {
                curSwipeStatus = AllCardsView.LikeDislike.like
            } label: {
                Image(systemName: "heart.circle.fill")
                    .resizable()
                    .frame(width:44, height:44)
                    .foregroundColor(.pink)
                    .padding(.horizontal)
                    .shadow(color: .pink,
                            radius: 0.1, x: 1, y: 1)
            }
            
            Spacer()
            
            Button {
                
            } label: {
                Image(systemName: "bolt.circle.fill")
                    .resizable()
                    .frame(width:35, height:35)
                    .foregroundColor(.blue)
                    .shadow(color: .blue,
                            radius: 0.1, x: 1, y: 1)
            }
                
        }.padding(.horizontal,20)
    }
}

struct LikeDislikeSuperLike_Previews: PreviewProvider {
    static var previews: some View {
        LikeDislikeSuperLike(curSwipeStatus: Binding.constant(AllCardsView.LikeDislike.none))
    }
}
