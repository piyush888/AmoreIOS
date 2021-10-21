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
    @StateObject var photoModel = PhotoModel()
    
    
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
                        // Wait while photo info fetched from firebase storage
                        if photoModel.photosFetchedAndReady {
                            // If 2 or more photos already added
                            if photoModel.minUserPhotosAdded {
                                HomeView()
                                    .environmentObject(streamModel)
                                    .onAppear {
                                        photoModel.getPhotos()
                                    }
                            }
                            else {
                                AddPhotosView()
                                    .environmentObject(photoModel)
                                    .onAppear {
                                        photoModel.getPhotos()
                                    }
                            }
                        }
                        // Progress Wheel while waiting for photo info to be fetched
                        else {
                            ProgressView()
                                .onAppear {
                                    photoModel.getPhotos()
                                }
                        }
                        
                    }
                    // Else user profile not created
                    // Show users forms to complete the profile
                    else {
                        BasicUserInfoForm()
                            .environmentObject(profileModel)
                            .environmentObject(streamModel)
                            .onAppear {
                                if photoModel.photosFetchedAndReady || photoModel.minUserPhotosAdded {
                                    photoModel.photosFetchedAndReady = false
                                    photoModel.minUserPhotosAdded = false
                                }
                            }
                    }
                }
            }
            // Pull profile data first
            else {
                ProgressView()
                    .onAppear {
                        print("Checkpoint 2")
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
