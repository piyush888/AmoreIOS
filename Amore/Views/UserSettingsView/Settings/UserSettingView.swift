//
//  UserSettingView.swift
//  Amore
//
//  Created by Kshitiz Sharma on 10/22/21.
//

import SwiftUI
import FirebaseAuth

struct UserSettingView: View {
    
    @StateObject var notificatonViewModel = NotificatonViewModel()
    @AppStorage("log_Status") var log_Status = false
    @EnvironmentObject var photoModel: PhotoModel
    @EnvironmentObject var profileModel: ProfileViewModel
    @EnvironmentObject var adminAuthenticationModel: AdminAuthenticationViewModel
    @EnvironmentObject var storeManager: StoreManager
    
    let currentUser = Auth.auth().currentUser
    
    @State var showModal = false
    
    var body: some View {
        
        Form {
            // Phone Number
            // Email
            Section(header:Text("Account Settings")) {
                userDetails
            }
            
            Section(header:Text("Contact Us")) {
                SettingFormComponents(settingName:"Help and Support",
                                      urlToOpen:"https://www.luvamore.com/about#contact")
            }
            
            
            Section(header:Text("Community")) {
                SettingFormComponents(settingName:"Community Guidelines",
                                      urlToOpen:"https://www.luvamore.com/communityguidelines")
                
                SettingFormComponents(settingName:"Safety Tips",
                                      urlToOpen:"https://www.luvamore.com/safetytips")
                
                SettingFormComponents(settingName:"Safety Center",
                                      urlToOpen:"https://www.luvamore.com/safetytips")
            }
            
            
            Section(header:Text("Privacy")) {
                
                SettingFormComponents(settingName:"Cookie Policy",
                                      urlToOpen:"https://www.luvamore.com/cookiepolicy")
                
                SettingFormComponents(settingName:"Privacy Policy",
                                      urlToOpen:"https://www.luvamore.com/privacy")
            }
            
            Section(header:Text("Legal")) {
                SettingFormComponents(settingName:"Terms of Service",
                                      urlToOpen:"https://www.luvamore.com/termsandconditions")
                
            }
            
            
            Section {
                Button {
                    // Restore the purchase
                    storeManager.restoreProducts()
                } label:{
                    Text("Restore Purchases")
                }
            }
            
            Section {
                    // Deletion of the account
                    DeleteProfileButton()
            }
            
            // Logout
            Section {
                logoOut
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Settings")
    }
    
    var logoOut: some View {
        // Log Out
        Button{
            DispatchQueue.main.async {
               notificatonViewModel.deleteFCMTokenFromFirestore {
                   photoModel.resetPhotosOnLogout()
                   adminAuthenticationModel.removeCookies()
                   // Firestore logout
                   try! Auth.auth().signOut()
                   log_Status = false
               }
           }
        } label : {
            Text("Log Out")
        }
    }
    
    var userDetails: some View {
        Group {
            // Phone Number
            HStack {
                Text("Phone Number")
                Spacer()
                Text("\(currentUser?.phoneNumber ?? "")")
            }
            
            /// Email
            HStack {
                Text("Email")
                Spacer()
                Text("\(profileModel.userProfile.email ?? "")")
            }
        }
    }
    
}




struct UserSettingView_Previews: PreviewProvider {
    static var previews: some View {
        UserSettingView()
            .environmentObject(PhotoModel())
            .environmentObject(ProfileViewModel())
            .environmentObject(AdminAuthenticationViewModel())
    }
}
