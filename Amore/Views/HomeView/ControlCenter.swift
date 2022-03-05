//
//  ControlCenter.swift
//  Amore
//
//  Created by Kshitiz Sharma on 10/10/21.
//

import SwiftUI

struct ControlCenter: View {
    
    @Binding var currentPage: ViewTypes
//    @Binding var newMessageBadge: Bool
    
    var controlCenterColor = Color(UIColor.lightGray)
    
    var body: some View {
        HStack {
            
//            if newMessageBadge {
//                Image(systemName: "text.bubble.fill")
//                    .imageScale(.large)
//                    .foregroundColor(currentPage == .messagingView ? Color.blue : controlCenterColor)
//                    .padding(.horizontal)
//                    .onTapGesture {
//                        currentPage = .messagingView
//                    }
//                    .overlay(Text("\(Image(systemName: "suit.heart.fill"))")
//                                .foregroundColor(.green)
//                                .font(.body), alignment: .topTrailing)
//            }
//            else {
                Image(systemName: "text.bubble.fill")
                    .imageScale(.large)
                    .foregroundColor(currentPage == .messagingView ? Color.blue : controlCenterColor)
                    .padding(.horizontal)
                    .onTapGesture {
                        currentPage = .messagingView
                    }
//            }
            
            Spacer()
            Image(systemName: "sparkles")
                .imageScale(.large)
                .foregroundColor(currentPage == .likesTopPicksView ? Color.blue : controlCenterColor)
                .padding(.horizontal)
                .onTapGesture {
                    currentPage = .likesTopPicksView
                }
                
            Spacer()
            Image(systemName: "bonjour")
                .imageScale(.large)
                .foregroundColor(currentPage == .swipeView ? Color.blue : controlCenterColor)
                .padding(.horizontal)
                .onTapGesture {
                    currentPage = .swipeView
                }
                
            Spacer()
            Image(systemName: "slider.vertical.3")
                .imageScale(.large)
                .foregroundColor(currentPage == .filterSettingsView ? Color.blue : controlCenterColor)
                .padding(.horizontal)
                .onTapGesture {
                    currentPage = .filterSettingsView
                }
            
            Spacer()
            Image(systemName: "person.fill")
                .imageScale(.large)
                .foregroundColor(currentPage == .userSettingsView ? Color.blue : controlCenterColor)
                .padding(.horizontal)
                .onTapGesture {
                    currentPage = .userSettingsView
                }
        }
    }
}

