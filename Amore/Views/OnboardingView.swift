//
//  OnboardingView.swift
//  Amore
//
//  Created by Kshitiz Sharma on 9/20/21.
//

import SwiftUI


struct OnboardingView: View {
    
    @EnvironmentObject var model: OnboardingModel
    @State var tabSelectionIndex = 0
    
    var body: some View {
        
        
        VStack {
            
            Spacer()
            
            TabView(selection: $tabSelectionIndex){
                    ForEach(0..<model.onboardingsData.count) { index in
                        // Pictures, Onboarding Heading & Onboarding SubText
                        OnboardingCards(
                            boardingtitle: model.onboardingsData[index].onboardingtitle,
                            boardingtext: model.onboardingsData[index].onboardingtext,
                            image: model.onboardingsData[index].image
                        )
                        .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
                .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
        
            
            
            // Create an account
            VStack{
                Button{
                    // TODO
                } label : {
                    ZStack{
                        Rectangle()
                            .frame(height:45)
                            .cornerRadius(5.0)
                            .foregroundColor(.pink)
                            .padding(.horizontal,44)
                        
                        Text("Create an account")
                            .foregroundColor(.white)
                            .bold()
                            .font(.BoardingButton)
                    }
                }
                
                // Option to SignIn, If User already has an account
                Text("Already have an account? Sign In")
                    .padding(.top,20)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.black)
                    .font(.BoardingSubHeading)
            }
            .padding(.horizontal,44)
            .padding(.bottom,44)
            
            Spacer()
            
        }
    }
}

struct OnboardingOneView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
            .environmentObject(OnboardingModel())
    }
}
