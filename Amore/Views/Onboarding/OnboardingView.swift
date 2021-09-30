//
//  OnboardingView.swift
//  Amore
//
//  Created by Kshitiz Sharma on 9/20/21.
//

import SwiftUI
import FirebaseAuth


struct OnboardingView: View {
    
    @EnvironmentObject var model: OnboardingModel
    @State var tabSelectionIndex = 0
    @State var loggedIn: Bool = false
    @State var loginFormVisible = false
    
    func checkLogin() {
        loggedIn = Auth.auth().currentUser == nil ? false : true
        print("Logged In: "+String(loggedIn))
    }
    
    var body: some View {
        
        if !loggedIn {
            // Onboarding View - Logged Out
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
            
                
                
                // Sign In/Sign Up Button
                VStack{
                    Button{
                        loginFormVisible = true
                    } label : {
                        ZStack{
                            Rectangle()
                                .frame(height:45)
                                .cornerRadius(5.0)
                                .foregroundColor(.pink)
                                .padding(.horizontal,44)
                            
                            Text("Sign In/Sign Up")
                                .foregroundColor(.white)
                                .bold()
                                .font(.BoardingButton)
                        }
                    }
                    .sheet(isPresented: $loginFormVisible, onDismiss: {
                        checkLogin()
                    }) {
                        Number(loginFormVisible: $loginFormVisible)
                    }
                }
                .padding(.horizontal,44)
                .padding(.bottom,44)
                
                Spacer()
                
            }
            .onAppear{
                checkLogin()
            }
        }
        else {
            // Home View/Profile View -- Logged In
            HomeView(loggedIn: $loggedIn)
        }
        
    }
}

struct OnboardingOneView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
            .environmentObject(OnboardingModel())
    }
}
