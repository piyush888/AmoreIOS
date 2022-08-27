//
//  ContactCommunityLegal.swift
//  Amore
//
//  Created by Kshitiz Sharma on 10/28/21.
//

import SwiftUI
import FirebaseAuth

struct ContactCommunityLegal: View {
    
    @State var width: CGFloat = 0.0
    @EnvironmentObject var photoModel: PhotoModel
    @EnvironmentObject var profileModel: ProfileViewModel
    @EnvironmentObject var adminAuthenticationModel: AdminAuthenticationViewModel
    let currentUser = Auth.auth().currentUser
    
    var body: some View {
        
        Form {
            Section {
                /// Phone Number
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
                
                SettingFormComponents(settingName:"Help & Support",
                                      urlToOpen:"http://aidronesoftware.com")
                
                SettingFormComponents(settingName:"Community Guidelines",
                                      urlToOpen:"http://aidronesoftware.com")
                
                SettingFormComponents(settingName:"Safety Tips",
                                      urlToOpen:"http://aidronesoftware.com")
                
                SettingFormComponents(settingName:"Safety Center",
                                      urlToOpen:"http://aidronesoftware.com")
                
                SettingFormComponents(settingName:"Privacy Policy",
                                      urlToOpen:"http://aidronesoftware.com")
                
                SettingFormComponents(settingName:"Terms of Service",
                                      urlToOpen:"http://aidronesoftware.com")
                
                SettingFormComponents(settingName:"License",
                                      urlToOpen:"http://aidronesoftware.com")
                
                SettingFormComponents(settingName:"Privacy Preference",
                                      urlToOpen:"http://aidronesoftware.com")
            }
            
            Section(header: Text("Others")) {
                // Contact Support
                ContactSupport()

                // Delete Profile
                DeleteProfileButton()
                    .environmentObject(photoModel)
                    .environmentObject(profileModel)
                    .environmentObject(adminAuthenticationModel)
            }
            .navigationBarTitleDisplayMode(.inline)
            
        }
        .cornerRadius(15)
    }
}


struct SettingFormComponents: View {
    
    @State private var showSafari: Bool = false
    @State var settingName: String = ""
    @State var urlToOpen: String = ""
    
    var body: some View {
        HStack {
            Text(settingName)
            Spacer()
            Image(systemName: "chevron.right")
        }.onTapGesture {
            showSafari.toggle()
        }.fullScreenCover(isPresented: $showSafari, content: {
                SFSafariViewWrapper(url: URL(string: urlToOpen)!)
        })
    
    }
}

struct ContactCommunityLegal_Previews: PreviewProvider {
    static var previews: some View {
        ContactCommunityLegal(width:400.0)
    }
}
