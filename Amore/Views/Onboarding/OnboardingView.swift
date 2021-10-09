//
//  OnboardingView.swift
//  Amore
//
//  Created by Kshitiz Sharma on 9/20/21.
//

import SwiftUI
import FirebaseAuth


struct OnboardingView: View {
    
    @StateObject var profileModel = ProfileViewModel()
    @EnvironmentObject var model: OnboardingModel
    @State var tabSelectionIndex = 0
    @State var loggedIn: Bool = false
    @State var loginFormVisible = false
    @State var profileCreationDone: Bool = false
    
    func checkLogin() {
        loggedIn = Auth.auth().currentUser == nil ? false : true
        print("Logged In: "+String(loggedIn))
    }
    
    func checkProfileCreationDone() {
        if profileModel.userProfile.email != nil {
            profileCreationDone = true
        }
        else {
            profileCreationDone = false
        }
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
                            .environmentObject(profileModel)
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
            // Logged In
            // If User Profile Data pulled from Firestore
            if profileModel.profileFetchedAndReady {
                ZStack {
                    // If User profile already created
                    if profileCreationDone {
                        HomeView(loggedIn: $loggedIn)
                    }
                    // Else User profile creation process
                    else {
                        BasicUserInfo(profileCreationDone: $profileCreationDone)
                            .environmentObject(profileModel)
                    }
                }
                .onAppear {
                    checkProfileCreationDone()
                }
            }
            else {
                Text("Please Wait...")
                    .onAppear {
                        profileModel.getUserProfile()
                    }
            }
            
        }
        
    }
}

struct OnboardingOneView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
            .environmentObject(OnboardingModel())
    }
}
