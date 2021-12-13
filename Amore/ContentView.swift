//
//  ContentView.swift
//  Amore
//
//  Created by Kshitiz Sharma on 9/20/21.
//

import SwiftUI
import FirebaseAuth
import CoreLocation

struct ContentView: View {
    
    @AppStorage("log_Status") var logStatus = false
    
    @StateObject var profileModel = ProfileViewModel()
    @StateObject var streamModel = StreamViewModel()
    @StateObject var photoModel = PhotoModel()
    @StateObject var adminAuthenticationModel = AdminAuthenticationViewModel()
    @StateObject var filterAndLocationModel = FilterAndLocationModel()
    @StateObject var cardProfileModel = CardProfileModel()
    @StateObject var receivedGivenEliteModel = ReceivedGivenEliteModel()
    
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
                    .environmentObject(adminAuthenticationModel)
                
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
                        // If 2 or more photos already added
                        if profileModel.minPhotosAdded {
                            // If filter and location data is fetched and ready
                            if filterAndLocationModel.filterAndLocationDataFetched {
                                // If location authorisation granted
                                if [CLAuthorizationStatus.authorizedWhenInUse, CLAuthorizationStatus.authorizedAlways].contains(filterAndLocationModel.authorizationStatus) {
                                    HomeView()
                                        .environmentObject(profileModel)
                                        .environmentObject(streamModel)
                                        .environmentObject(photoModel)
                                        .environmentObject(adminAuthenticationModel)
                                        .environmentObject(filterAndLocationModel)
                                        .environmentObject(cardProfileModel)
                                        .environmentObject(receivedGivenEliteModel)
                                        .onAppear {
                                            print("Content View on appear triggered, all data is being intialized")
                                            profileModel.getUserProfile()
                                            profileModel.checkMinNumOfPhotosUploaded()
                                            cardProfileModel.fetchProfile(numberOfProfiles: 10)
                                            receivedGivenEliteModel.getLikesGivenData()
                                            filterAndLocationModel.getLocationOnce()
                                            filterAndLocationModel.updateFilterAndLocation()
                                        }
                                    // To Test MoreInfo, comment out HomeView and uncomment block below
        //                            MoreInfoForBetterMatch()
        //                                .environmentObject(profileModel)
        //                                .onAppear {
        //                                    profileModel.getUserProfile()
        //                                    profileModel.checkMinNumOfPhotosUploaded()
        //                                }
                                }
                                // Else get location permission
                                else {
                                    LocationView()
//                                        .environmentObject(locationModel)
                                        .environmentObject(filterAndLocationModel)
                                }
                            }
                            else {
                                ProgressView()
                                    .onAppear {
                                        filterAndLocationModel.getFilterAndLocation()
                                    }
                            }
                            
                        }
                        else {
                            AddPhotosView()
                                .environmentObject(photoModel)
                                .environmentObject(profileModel)
                                .onAppear {
                                    profileModel.checkMinNumOfPhotosUploaded()
                                }
                        }

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
                        profileModel.checkMinNumOfPhotosUploaded()
                        filterAndLocationModel.getFilterAndLocation()
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
