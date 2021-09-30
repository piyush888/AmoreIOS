//
//  ContentView.swift
//  Amore
//
//  Created by Kshitiz Sharma on 9/20/21.
//

import SwiftUI
import FirebaseAuth

struct ContentView: View {
    var body: some View {
        OnboardingView()
            .environmentObject(OnboardingModel())
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
