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
                Image(systemName: "arrowshape.turn.up.backward.circle.fill")
                    .resizable()
                    .frame(width:35, height:35)
                    .foregroundColor(.orange)
            }

            Spacer()
            
            Button {
                curSwipeStatus = AllCardsView.LikeDislike.dislike
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .resizable()
                    .frame(width:55, height:55)
                    .foregroundColor(.gray)
                    .padding(.horizontal)
                    .shadow(color: .white,
                            radius: 5, x: 1, y: 1)
            }
            
            Spacer()
            
            Button {
                
            } label: {
                Image(systemName: "star.circle.fill")
                    .resizable()
                    .frame(width:40, height:40)
                    .foregroundColor(Color("gold-star"))
                    .shadow(color: .white,
                            radius: 1, x: 1, y: 1)
            }

            Spacer()
            
            Button {
                curSwipeStatus = AllCardsView.LikeDislike.like
            } label: {
                Image(systemName: "heart.circle.fill")
                    .resizable()
                    .frame(width:55, height:55)
                    .foregroundColor(.pink)
                    .padding(.horizontal)
                    .shadow(color: .white,
                            radius: 5, x: 1, y: 1)
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
                
        }
    }
}

struct LikeDislikeSuperLike_Previews: PreviewProvider {
    static var previews: some View {
        LikeDislikeSuperLike(curSwipeStatus: Binding.constant(AllCardsView.LikeDislike.none))
    }
}
