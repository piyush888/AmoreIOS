//
//  SettingEditProfileSafety.swift
//  Amore
//
//  Created by Kshitiz Sharma on 10/30/21.
//

import SwiftUI

struct SettingEditProfileSafety: View {
    
    @EnvironmentObject var profileModel: ProfileViewModel
    @EnvironmentObject var photoModel: PhotoModel
    @EnvironmentObject var adminAuthenticationModel: AdminAuthenticationViewModel
    // Close the settings tab
    @Binding var settingsDone: Bool
    // Close the Editing Tab
    @Binding var profileEditingToBeDone: Bool
    
    var body: some View {
        
        HStack(spacing:50) {
            
            NavigationLink(isActive: $settingsDone) {
                UserSettingView(settingsDone: $settingsDone)
                    .environmentObject(photoModel)
                    .environmentObject(profileModel)
                    .environmentObject(adminAuthenticationModel)
            } label: {
                Button {
                    settingsDone = true
                } label: {
                    
                    LinearGradient(
                        gradient: Gradient(colors: [Color.gray, Color.purple]),
                        startPoint: .leading,
                        endPoint: .trailing)
                        .frame(width:60, height:60)
                        .mask(Image(systemName: "gearshape.fill")
                                .font(.system(size:40)))
                        .padding(.bottom,20)
                    
                }
            }
            
            NavigationLink(isActive: $profileEditingToBeDone) {
                EditProfile(profileEditingToBeDone: $profileEditingToBeDone,
                                   careerField:profileModel.editUserProfile.careerField,
                                   religion:profileModel.editUserProfile.religion,
                                   politics:profileModel.editUserProfile.politics,
                                   education:profileModel.editUserProfile.education,
                                   countryRaisedIn:profileModel.editUserProfile.countryRaisedIn,
                                   doYouSmoke:profileModel.editUserProfile.doYouSmoke,
                                   doYouDrink:profileModel.editUserProfile.doYouDrink,
                                   doYouWorkOut:profileModel.editUserProfile.doYouWorkOut)
                    .environmentObject(photoModel)
                    .environmentObject(profileModel)
            } label: {
                
                LinearGradient(
                    gradient: Gradient(colors: [Color.gray, Color.purple]),
                    startPoint: .leading,
                    endPoint: .trailing)
                    .frame(width:60, height:60)
                    .mask(Image(systemName: "pencil.circle.fill")
                            .font(.system(size:40)))
                
            }
            
            NavigationLink(
                destination: UserSafetyView(),
                label: {
                    LinearGradient(
                        gradient: Gradient(colors: [Color.gray, Color.purple]),
                        startPoint: .leading,
                        endPoint: .trailing)
                        .frame(width:60, height:60)
                        .mask(Image(systemName: "shield.fill")
                                .font(.system(size:40)))
                        .padding(.bottom,20)
                })
            
        }
        
    }
}


