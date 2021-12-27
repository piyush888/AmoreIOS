//
//  TabButtonMenu.swift
//  Amore
//
//  Created by Kshitiz Sharma on 10/18/21.
//

import SwiftUI

struct TabButtonMenu: View {
    
    @State var titleSelected: TopPicksLikesView
    @Binding var selectedTab: TopPicksLikesView
    var animation: Namespace.ID
    
    var body: some View {
        
        Button(action: {
            withAnimation(.spring()){
                selectedTab = titleSelected
            }
        }) {
            
            Text("\(titleSelected.rawValue)")
                .font(.system(size: 15))
                .bold()
                .foregroundColor(selectedTab == titleSelected ? .white : .gray)
                .padding(.vertical,10)
                .padding(.horizontal,selectedTab == titleSelected ? 20 : 0)
                .background(
                
                    // For Slide Effect Animation...
                    
                    ZStack{
                        
                        if selectedTab == titleSelected {
                            
                            Color.blue
                                .clipShape(Capsule())
                                .matchedGeometryEffect(id: "Tab", in: animation)
                        }
                    }
                )
        }
    }
}

