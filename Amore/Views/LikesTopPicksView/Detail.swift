//
//  Detail.swift
//  Amore
//
//  Created by Kshitiz Sharma on 10/18/21.
//

import SwiftUI


import SwiftUI

struct Detail: View {
    @Binding var selectedItem: TopPicksProfiles
    @Binding var show: Bool
    
    var animation: Namespace.ID
    
    @State var loadContent = false
    
    @State var selectedColor : Color = Color("p1")
    
    var body: some View {
        
        
        // optimisation for samller size iphone...
        ScrollView(UIScreen.main.bounds.height < 750 ? .vertical : .init(), content: {
            
            LazyVStack{
                
                HStack(spacing: 25){
                    
                    Button(action: {
                        // closing view...
                        withAnimation(.spring()){show.toggle()}
                    }) {
                        
                        Image(systemName: "chevron.left")
                            .font(.title)
                            .foregroundColor(.black)
                    }
                    
                    Spacer()
                    
                }
                .padding()
                
                VStack(spacing: 10){
                    
                    Image(selectedItem.image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .cornerRadius(10)
                        // since id is common,.....
                        .matchedGeometryEffect(id: "image\(selectedItem.id)", in: animation)
                        .padding()
                    
                    Text(selectedItem.firstName)
                        .font(.title)
                        .fontWeight(.heavy)
                        .foregroundColor(.black)
                    
                    HStack{
                        
                        Text(selectedItem.age)
                            .fontWeight(.heavy)
                            .foregroundColor(.black)
                            .matchedGeometryEffect(id: "rating\(selectedItem.id)", in: animation)
                        
                        Spacer()
                        
                        Button(action: {}) {
                            
                            Image(systemName: "suit.heart")
                                .font(.title2)
                                .foregroundColor(.black)
                        }
                        .matchedGeometryEffect(id: "heart\(selectedItem.id)", in: animation)
                        
                    }
                    .padding()
                }
                .background(
                    Color(selectedItem.image)
                        .clipShape(CustomShape())
                        .matchedGeometryEffect(id: "color\(selectedItem.id)", in: animation)
                )
                .cornerRadius(15)
                .padding()
                
                // delay loading the content for smooth animation...
                VStack{
                    
                }
                .padding([.horizontal,.bottom])
                .frame(height: loadContent ? nil : 0)
                .opacity(loadContent ? 1 : 0)
                // for smooth transition...
                
                Spacer(minLength: 0)
            }
        })
        .onAppear {
            
            withAnimation(Animation.spring().delay(0.45)){
                loadContent.toggle()
            }
        }
    }
}
