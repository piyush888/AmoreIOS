//
//  ControlCenter.swift
//  Amore
//
//  Created by Kshitiz Sharma on 10/10/21.
//

import SwiftUI
import FirebaseAuth

struct ControlCenter: View {
    
    @Binding var loggedIn: Bool
    
    var controlCenterColor = Color(UIColor.lightGray)
    
    var body: some View {
        HStack {
            
            Image(systemName: "text.bubble.fill")
                .imageScale(.large)
                .foregroundColor(controlCenterColor)
                .padding(.horizontal)
                
            Spacer()
            Image(systemName: "sparkles")
                .imageScale(.large)
                .foregroundColor(controlCenterColor)
                .padding(.horizontal)
                
            Spacer()
            Image(systemName: "bonjour")
                .imageScale(.large)
                .foregroundColor(controlCenterColor)
                .padding(.horizontal)
                
            Spacer()
            Image(systemName: "slider.vertical.3")
                .imageScale(.large)
                .foregroundColor(controlCenterColor)
                .padding(.horizontal)
            
            Spacer()
            Button {
                try! Auth.auth().signOut()
                loggedIn = false
            } label: {
                Image(systemName: "person.fill")
                    .imageScale(.large)
                    .foregroundColor(controlCenterColor)
                    .padding(.horizontal)
            }
            
        }
    }
}

