//
//  Home.swift
//  Specs
//
//  Created by Balaji on 20/11/20.
//

import SwiftUI

struct LikesTopPicksHome: View {
    
    @State var selectedTab = tabs[0]
    @Namespace var animation
    
    @State var show = false
    @State var selectedItem : TopPicksProfiles = TopPicksProfilesList[0]
    
    var body: some View {
        
        ZStack{
            
            VStack{
                
                ScrollView{
                    
                    VStack{
                        
                        HStack(spacing: 0){
                            Spacer()
                            
                            ForEach(tabs,id: \.self){tab in
                                
                                // Tab Button....
                                
                                TabButton(title: tab, selected: $selectedTab, animation: animation)
                                
                                // even spacing....
                                
                                if tabs.last != tab{Spacer(minLength: 0)}
                            }
                            Spacer()
                        }
                        .padding()
                        .padding(.top,5)
                        
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible(),spacing: 20), count: 2),spacing: 25){
                            
                            ForEach(TopPicksProfilesList){item in
                                
                                // Card the matches
                                if selectedTab == "Matches" {
                                    Button{
                                        withAnimation(.spring()){
                                            selectedItem = item
                                            show.toggle()
                                        }
                                    } label : {
                                        CardView(item: item, animation: animation)
                                    }
                                } else {
                                // Card the elite picks
                                    Button{
                                        withAnimation(.spring()){
                                            selectedItem = item
                                            show.toggle()
                                        }
                                    } label : {
                                        CardView(item: item, animation: animation)
                                    }
                                }
                                    
                            }
                        }
                        .padding()
                    }
                }
                
                Spacer(minLength: 0)
            }
            .opacity(show ? 0 : 1)
            
            if show{
                Detail(selectedItem: $selectedItem, show: $show, animation: animation)
            }
        }
        .background(Color.white.ignoresSafeArea())
    }
}

// Tabs...

var tabs = ["Likes Received","Elite Picks"]
