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
                    .scaledToFill()
                    .frame(height: 450, alignment: .center)
                    .cornerRadius(15)
                    .padding(.horizontal,45)
                    .shadow(color: Color("onboarding-pink"),
                            radius: 8, x: 3, y: 3)
                
                Text(boardingtitle)
                    .foregroundColor(.pink)
                    .font(.BoardingTitle)
                    .padding(.top,8)
                
                
                Text(boardingtext)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.black)
                    .font(.BoardingSubHeading)
                    .padding(.horizontal)
                    .padding(.bottom,10)
        }
        .padding(.bottom, 20)
    }
}

struct OnboardingCards_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            OnboardingCards(boardingtitle: "Algorithm",
                            boardingtext: "Users going through a vetting process to ensure you never match with bots.",
                            image: "onboarding_girl1")
            .previewDisplayName("iPhone 13 Pro Max")
            .previewDevice("iPhone 13 Pro Max")
            OnboardingCards(boardingtitle: "Algorithm",
                            boardingtext: "Users going through a vetting process to ensure you never match with bots.",
                            image: "onboarding_girl1")
            .previewDisplayName("iPhone 13 Mini")
            .previewDevice("iPhone 13 Mini")
            OnboardingCards(boardingtitle: "Algorithm",
                            boardingtext: "Users going through a vetting process to ensure you never match with bots.",
                            image: "onboarding_girl1")
            .previewDisplayName("iPhone 12 Mini")
            .previewDevice("iPhone 12 Mini")
            OnboardingCards(boardingtitle: "Algorithm",
                            boardingtext: "Users going through a vetting process to ensure you never match with bots.",
                            image: "onboarding_girl1")
            .previewDisplayName("iPhone 12 Pro")
            .previewDevice("iPhone 12 Pro")
            OnboardingCards(boardingtitle: "Algorithm",
                            boardingtext: "Users going through a vetting process to ensure you never match with bots.",
                            image: "onboarding_girl1")
            .previewDisplayName("iPhone 11")
            .previewDevice("iPhone 11")
        }
    }
}
