//
//  ContentView.swift
//  Amore
//
//  Created by Kshitiz Sharma on 9/20/21.
//

import SwiftUI
import FirebaseAuth
import CoreLocation
import StoreKit

struct ContentView: View {
    
    @AppStorage("log_Status") var logStatus = false
    
    @StateObject var profileModel = ProfileViewModel()
    @StateObject var photoModel = PhotoModel()
    @StateObject var adminAuthenticationModel = AdminAuthenticationViewModel()
    @StateObject var filterModel = FilterModel()
    @StateObject var cardProfileModel = CardProfileModel()
    @StateObject var receivedGivenEliteModel = ReceivedGivenEliteModel()
    @StateObject var reportActivityModel = ReportActivityModel()
    @StateObject var storeManager = StoreManager()
    @StateObject var storeProfileV2 = ProfileViewModelV2()
    
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
//                    .environmentObject(streamModel)
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
                            if filterModel.filterDataFetched {
                                // If location authorisation granted
                                if [CLAuthorizationStatus.authorizedWhenInUse, CLAuthorizationStatus.authorizedAlways].contains(profileModel.authorizationStatus) {
                                    HomeView()
                                        .environmentObject(profileModel)
                                        .environmentObject(photoModel)
                                        .environmentObject(adminAuthenticationModel)
                                        .environmentObject(filterModel)
                                        .environmentObject(cardProfileModel)
                                        .environmentObject(receivedGivenEliteModel)
                                        .environmentObject(reportActivityModel)
                                        .environmentObject(storeManager)
                                        .onAppear {
                                            print("Content View on appear triggered, all data is being intialized")
//                                            profileModel.getUserProfile()
                                            profileModel.checkMinNumOfPhotosUploaded()
                                            cardProfileModel.filterRadius = filterModel.filterData.radiusDistance
                                            cardProfileModel.fetchProfile(filterData:filterModel.filterData)
                                            profileModel.getLocationOnce()
                                            profileModel.updateUserProfile(profileId: Auth.auth().currentUser?.uid)
                                            receivedGivenEliteModel.getLikesReceivedData()
                                            receivedGivenEliteModel.getLikesGivenData()
                                            receivedGivenEliteModel.getSuperLikesGivenData()
                                            receivedGivenEliteModel.elitesData()
                                            // Observing the storemanager payment queue and responds to the changes.
                                            SKPaymentQueue.default().add(storeManager)
                                            storeManager.getProducts()
                                            storeManager.getPurchase()
                                            storeProfileV2.writeUserProfileToBackend(userProfile:profileModel.editUserProfile)
                                        }
                                }
                                // Else get location permission
                                else {
                                    LocationView()
                                        .environmentObject(profileModel)
                                }
                            }
                            else {
                                ProgressView()
                                    .onAppear {
                                        filterModel.getFilter()
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
                    }
                }
            }
            
            
            
            // Pull profile data first
            else {
                ProgressView()
                    .onAppear {
                        profileModel.getUserProfile()
                        profileModel.checkMinNumOfPhotosUploaded()
                        filterModel.getFilter()
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
