//
//  OnboardingAllCards.swift
//  Amore
//
//  Created by Kshitiz Sharma on 10/16/21.
//

import SwiftUI

struct OnboardingAllCards: View {
    
    @StateObject var onboardingModel = OnboardingModel()
    @State var tabSelectionIndex = 0
    
    var body: some View {
        VStack(spacing:0) {
            TabView(selection: $tabSelectionIndex){
                ForEach(0..<onboardingModel.onboardingsData.count) { index in
                    // Pictures, Onboarding Heading & Onboarding SubText
                    OnboardingCards(
                        boardingtitle: onboardingModel.onboardingsData[index].onboardingtitle,
                        boardingtext: onboardingModel.onboardingsData[index].onboardingtext,
                        image: onboardingModel.onboardingsData[index].image
                    )
                    .tag(index)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            
            
            HStack(spacing: 4) {
                ForEach(0..<onboardingModel.onboardingsData.count) { index in
                    Capsule()
                        .fill(Color.gray.opacity(tabSelectionIndex == index ? 1 : 0.55))
                        .frame(width: tabSelectionIndex == index ? 18 : 4, height: 4)
                        .animation(.easeInOut, value: tabSelectionIndex)
                }
            }
        }
        .frame(height: UIScreen.main.bounds.size.height * 0.75, alignment: .center)
    }
}

struct OnboardingAllCards_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingAllCards()
    }
}
