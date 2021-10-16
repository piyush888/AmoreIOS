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
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
            .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
    }
}

struct OnboardingAllCards_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingAllCards()
    }
}
