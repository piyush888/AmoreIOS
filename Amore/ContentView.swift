//
//  ContentView.swift
//  Amore
//
//  Created by Kshitiz Sharma on 9/20/21.
//

import SwiftUI
import FirebaseAuth

struct ContentView: View {
    
    @StateObject var profileModel = ProfileViewModel()
    @State var loggedIn: Bool = false
    
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
        
        // If User is Not Logged In Yet
        if !loggedIn {
            // Onboarding View - Logged Out
            VStack {
                Spacer()
                // Onboarding Swipeable Cards
                OnboardingAllCards()
                
                // Sign In/Sign Up Button
                LogInSheetView(loggedIn: $loggedIn)
                    .environmentObject(profileModel)
                
                Spacer()
            }
            .onAppear{
                // As soon as the page loads check if user is already logged In
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
                    // Else user profile not created
                    // Show users forms to complete the profile
                    else {
                        BasicUserInfoForm(profileCreationDone: $profileCreationDone)
                            .environmentObject(profileModel)
                    }
                }
                .onAppear {
                    checkProfileCreationDone()
                }
            }
            else {
                ProgressView()
                    .onAppear {
                        profileModel.getUserProfile()
                    }
            }
            
        }
        
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
