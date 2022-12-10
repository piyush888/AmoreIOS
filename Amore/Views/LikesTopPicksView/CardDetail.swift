//
//  CardDetail.swift
//  Amore
//
//  Created by Kshitiz Sharma on 10/18/21.
//

import SwiftUI


import SwiftUI

struct CardDetail: View {
    
    @State var selectedProfile: CardProfileWithPhotos
    @Binding var show: Bool
    
    var animation: Namespace.ID
    
    @State var loadContent = false
    
    @State var selectedColor : Color = Color("p1")
    
    var body: some View {
        
        
        VStack {
            
            HStack(spacing: 25){
                
                Button(action: {
                    // closing view...
                    withAnimation(.spring()){show.toggle()}
                }) {
                    
                    Image(systemName: "chevron.left.circle.fill")
                        .font(.title)
                        .foregroundColor(Color.blue)
                }
                
                Spacer()
                
            }.padding()
            
            ChildCardView(singleProfile: selectedProfile,
                          swipeStatus: Binding.constant(AllCardsView.LikeDislike.none),
                          cardColor: Binding.constant(Color.pink))
            
            // delay loading the content for smooth animation...
            VStack{
                
            }
            .padding([.horizontal,.bottom])
            .frame(height: loadContent ? nil : 0)
            .opacity(loadContent ? 1 : 0)
            // for smooth transition...
                    
            Spacer(minLength: 0)
            
        }
        .onAppear {
            
            withAnimation(Animation.spring().delay(0.45)){
                loadContent.toggle()
            }
        }
        
        
    }
}
