//
//  HomeView.swift
//  Amore
//
//  Created by Piyush Garg on 28/09/21.
//

import SwiftUI

struct HomeView: View {
    
    @Binding var loggedIn: Bool
    
    var body: some View {
        VStack {
            // Control Center
            ControlCenter(loggedIn:$loggedIn)
                .padding()
            
            // Update new cards over here
            AllCardsView()
            
            // Undo, Dislike, Star, Like, Boost
            LikeDislikeSuperLike()
                .padding()
            
        }.navigationBarHidden(true)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(loggedIn: Binding.constant(true))
    }
}
