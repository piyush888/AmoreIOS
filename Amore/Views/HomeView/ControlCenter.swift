//
//  ControlCenter.swift
//  Amore
//
//  Created by Kshitiz Sharma on 10/10/21.
//

import SwiftUI

struct ControlCenter: View {
    
    @Binding var currentPage: ViewTypes
    
    var controlCenterColor = Color(UIColor.lightGray)
    
    var body: some View {
        HStack {
            
            Image(systemName: "text.bubble.fill")
                .imageScale(.large)
                .foregroundColor(controlCenterColor)
                .padding(.horizontal)
                .onTapGesture {
                    currentPage = .messagingView
                }
                
            Spacer()
            Image(systemName: "sparkles")
                .imageScale(.large)
                .foregroundColor(controlCenterColor)
                .padding(.horizontal)
                .onTapGesture {
                    currentPage = .likesTopPicksView
                }
                
            Spacer()
            Image(systemName: "bonjour")
                .imageScale(.large)
                .foregroundColor(controlCenterColor)
                .padding(.horizontal)
                .onTapGesture {
                    currentPage = .swipeView
                }
                
            Spacer()
            Image(systemName: "slider.vertical.3")
                .imageScale(.large)
                .foregroundColor(controlCenterColor)
                .padding(.horizontal)
                .onTapGesture {
                    currentPage = .filterSettingsView
                }
            
            Spacer()
            Image(systemName: "person.fill")
                .imageScale(.large)
                .foregroundColor(controlCenterColor)
                .padding(.horizontal)
                .onTapGesture {
                    currentPage = .userSettingsView
                }
        }
    }
}

