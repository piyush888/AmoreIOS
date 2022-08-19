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
    
    @AppStorage("log_Status") var log_Status = false
    
    @StateObject var profileModel = ProfileViewModel()
    @StateObject var photoModel = PhotoModel()
    @StateObject var adminAuthenticationModel = AdminAuthenticationViewModel()
    @StateObject var filterModel = FilterModel()
    @StateObject var cardProfileModel = CardProfileModel()
    @StateObject var receivedGivenEliteModel = ReceivedGivenEliteModel()
    @StateObject var reportActivityModel = ReportActivityModel()
    @StateObject var storeManager = StoreManager()
    @StateObject var chatModel = ChatModel()
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        
        // If User is Not Logged In Yet
        if !log_Status {
            OnboardingView()
                .environmentObject(profileModel)
                .environmentObject(adminAuthenticationModel)
//                .onAppear{
//                    // As soon as the page loads check if user is already logged In
//                    profileModel.checkLogin()
//                }
        }
        else {
            // If logged In
            // If User Profile Data pulled from Firestore
            
            if profileModel.profileFetchedAndReady {
                ZStack {
                    // If User profile already created  or onboarding is done
//                    if profileModel.userProfile.email != nil {
                    if profileModel.profileCreationDone {
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
                                        .environmentObject(chatModel)
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
                                            receivedGivenEliteModel.elitesData(profilesAlreadySwiped: [])
                                            receivedGivenEliteModel.loadMatches()
                                            // Observing the storemanager payment queue and responds to the changes.
                                            SKPaymentQueue.default().add(storeManager)
                                            storeManager.getProducts()
                                            storeManager.getPurchase()
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
        Group {
            ContentView()
                .previewDisplayName("iPhone 13 Pro Max")
                .previewDevice("iPhone 13 Pro Max")
            ContentView()
                .previewDisplayName("iPhone 13 Mini")
                .previewDevice("iPhone 13 Mini")
            ContentView()
                .previewDisplayName("iPhone 12 Mini")
                .previewDevice("iPhone 12 Mini")
            ContentView()
                .previewDisplayName("iPhone 12 Pro")
                .previewDevice("iPhone 12 Pro")
            ContentView()
                .previewDisplayName("iPhone 11")
                .previewDevice("iPhone 11")
        }
    }
}
