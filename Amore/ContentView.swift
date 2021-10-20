//
//  ContentView.swift
//  Amore
//
//  Created by Kshitiz Sharma on 9/20/21.
//

import SwiftUI
import FirebaseAuth

struct ContentView: View {
    
    @AppStorage("log_Status") var logStatus = false
    
    @StateObject var profileModel = ProfileViewModel()
    @StateObject var streamModel = StreamViewModel()
    
    var body: some View {
        
        // If User is Not Logged In Yet
        if !logStatus {
            // Onboarding View - Logged Out
            VStack {
                Spacer()
                
                // Amore heading
                VStack {
                    
                    Text("Amore")
                        .font(.title)
                        .foregroundColor(Color.pink)
                        .shadow(color: .pink, radius: 2, x: 0, y: 0)
                        
                    Text("The Indian Way of Dating")
                        .font(.caption2)
                        .italic()
                }
                .padding(.top,60)
                
                // Onboarding Swipeable Cards
                OnboardingAllCards()
                
                // Signin/Sign Up Button - Mobile Number - OTP Login
                LogInSheetView()
                    .environmentObject(profileModel)
                    .environmentObject(streamModel)
                
                Spacer()
            }
            .onAppear{
                // As soon as the page loads check if user is already logged In
                profileModel.checkLogin()
            }
        }
        else {
            // If logged In
            // If User Profile Data pulled from Firestore
            if profileModel.profileFetchedAndReady {
                ZStack {
                    // If User profile already created
                    if profileModel.userProfile.email != nil {
                        HomeView()
                            .environmentObject(streamModel)
                    }
                    // Else user profile not created
                    // Show users forms to complete the profile
                    else {
                        BasicUserInfoForm()
                            .environmentObject(profileModel)
                            .environmentObject(streamModel)
                    }
                }
            }
            // Pull profile data first
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
