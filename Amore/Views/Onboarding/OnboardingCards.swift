//
//  OnboardingCards.swift
//  Amore
//
//  Created by Kshitiz Sharma on 9/21/21.
//

import SwiftUI

struct OnboardingCards: View {
    
    var boardingtitle: String
    var boardingtext: String
    var image: String
    
    var body: some View {
        
        VStack{
                Image(image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(15)
                    .padding(.horizontal,40)
                    .shadow(color: Color("onboarding-pink"),
                            radius: 8, x: 3, y: 3)
                
                Text(boardingtitle)
                    .foregroundColor(.pink)
                    .font(.BoardingTitle)
                    .padding(.top,8)
                
                
                Text(boardingtext)
                    .padding(.top,10)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.black)
                    .font(.BoardingSubHeading)
        }
        .padding(.horizontal,25)
    }
}

struct OnboardingCards_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingCards(boardingtitle: "Algorithm",
                        boardingtext: "Users going through a vetting process to ensure you never match with bots.",
                        image: "onboarding_girl1")
    }
}
