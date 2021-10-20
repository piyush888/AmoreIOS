//
//  LoadingScreen.swift
//  Amore
//
//  Created by Kshitiz Sharma on 10/17/21.
//

import SwiftUI

struct LoadingScreen: View {
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        
        ZStack{
            
            Color.primary
                .opacity(0.2)
                .ignoresSafeArea()
            
            ProgressView()
                .frame(width: 50, height: 50)
                .background(colorScheme == .dark ? Color.black : Color.white)
                .cornerRadius(8)
        }
    }
}

struct LoadingScreen_Previews: PreviewProvider {
    static var previews: some View {
        LoadingScreen()
    }
}
