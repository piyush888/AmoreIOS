//
//  EditProfile.swift
//  Amore
//
//  Created by Kshitiz Sharma on 10/22/21.
//

import SwiftUI
import Firebase

struct EditProfile: View {
    
    @EnvironmentObject var photoModel: PhotoModel
    @EnvironmentObject var profileModel: ProfileViewModel
    @Binding var profileEditingToBeDone: Bool
    @State var currentPage: EditOrPreviewProfile = .editProfile
    @State var headingName = "Edit Info"
    
    var body: some View {
        
        VStack {
            
            HStack {
                
                Spacer()
                
                Button {
                    // Take Back to Profile View
                    profileModel.updateUserProfile(profileId: Auth.auth().currentUser?.uid)
                    profileEditingToBeDone = false
                } label: {
                    Text("Done")
                        .font(.title2)
                        .foregroundColor(.pink)
                }
                
            }
            
            HStack {
                Spacer()
                Text("Edit Info")
                    .font(.title2)
                    .foregroundColor(headingName == "Edit Info" ? .red : .gray)
                    .onTapGesture {
                        currentPage = .editProfile
                        headingName = "Edit Info"
                    }
                
                Spacer()
                
                Text("Preview Profile")
                    .font(.title2)
                    .foregroundColor(headingName == "Preview Profile" ? .red : .gray)
                    .onTapGesture {
                        currentPage = .previewProfile
                        headingName = "Preview Profile"
                    }
                Spacer()
            }
            
            switch currentPage {
                
            case .editProfile:
                EditCardInfo()
                    .environmentObject(photoModel)
                    .environmentObject(profileModel)
                
            case .previewProfile:
                PreviewProfile()
                    .environmentObject(photoModel)
                    .environmentObject(profileModel)
                
                
            }
            
            Spacer()
        }
        .padding(.horizontal,20)
        .padding(.top)
        .navigationBarHidden(true)
        
        //        UserProfilePhotosView()
        //            .environmentObject(photoModel)
        
    }
}

struct EditProfile_Previews: PreviewProvider {
    static var previews: some View {
        EditProfile(profileEditingToBeDone: Binding.constant(true))
            .environmentObject(PhotoModel())
    }
}
