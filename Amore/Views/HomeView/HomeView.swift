//
//  HomeView.swift
//  Amore
//
//  Created by Piyush Garg on 28/09/21.
//

import SwiftUI
import FirebaseAuth

struct HomeView: View {
    
    @Binding var loggedIn: Bool
    
    var body: some View {
        VStack {
            Text("Welcome!")
            Button {
                try! Auth.auth().signOut()
                loggedIn = false
            } label: {
                Text("Sign Out")
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(loggedIn: Binding.constant(true))
    }
}
