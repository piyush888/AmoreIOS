//
//  NoMatchesView.swift
//  Amore
//
//  Created by Kshitiz Sharma on 4/21/23.
//

import SwiftUI

struct NoMatchesView: View {
    @Binding var currentPage: ViewTypes
    
    var body: some View {
        VStack {
            Image(systemName: "heart.fill")
                .font(.largeTitle)
                .foregroundColor(.red)
                .padding(.bottom)
            Text("You haven't found your perfect match yet.")
                .font(.headline)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding()
            Button(action: {
                // Navigate to swipe view
                currentPage = .swipeView
            }) {
                Text("Keep Swiping")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding(.top)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .edgesIgnoringSafeArea(.all)
    }
}

struct NoMatchesView_Previews: PreviewProvider {
    static var previews: some View {
        NoMatchesView(currentPage:Binding.constant(ViewTypes.messagingView))
    }
}
