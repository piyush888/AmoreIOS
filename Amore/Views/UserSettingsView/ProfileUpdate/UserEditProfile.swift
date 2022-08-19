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
    @State var selectedTab = "Edit Info"
    
    @State var careerField: String?
    @State var religion: String?
    @State var politics: String?
    @State var education: String?
    @State var countryRaisedIn: String?
    @State var doYouSmoke: String?
    @State var doYouDrink: String?
    @State var doYouWorkOut: String?
    @State var food: String?
    
    @State var formUpdated: Bool = false
    
    
    func isAboutYouUpdated() {
        // If form was updated we need to copy the State values to the Profile Model fields
        /// Problem: Not sure which attribute was changed
        if(formUpdated) {
            print("Form was updated")
            // TODO - How to find out which profileModel field was updated?
            /// To Save time I'm currently initalizing all the profile model variables again
            profileModel.editUserProfile.careerField = careerField
            profileModel.editUserProfile.religion = religion
            profileModel.editUserProfile.politics = politics
            profileModel.editUserProfile.education = education
            profileModel.editUserProfile.countryRaisedIn = countryRaisedIn
            profileModel.editUserProfile.doYouSmoke = doYouSmoke
            profileModel.editUserProfile.doYouDrink = doYouDrink
            profileModel.editUserProfile.doYouWorkOut = doYouWorkOut
            profileModel.editUserProfile.food = food
        } else {
            print("Edit Profile was closed without updating profile")
        }
        
        // profileModel was updated
        self.formUpdated = false
    }
    
    var body: some View {
        
        GeometryReader { geometry in
            VStack {
                
                // Done Button to close the editing view
                HStack {
                    Spacer()
                    
                    Button(action: {
                        // Check if the user change the About You Prefernces
                        /// If true update the profileModel with new data
                        self.isAboutYouUpdated()
                        // Update the firestore with  new user data
                        profileModel.updateUserProfile(profileId: Auth.auth().currentUser?.uid)
                        // Close the Editing Tab
                        profileEditingToBeDone = false
                    }) {
                        Text("Done")
                    }
                }.padding(.horizontal,20)
               
                // get the tab buttons here
                // Edit Info
                // Preview
                tabButtons
                
                // Tab Views
                switch currentPage {

                    case .editProfile:
                        EditCardInfo(careerField:$careerField,
                                     religion:$religion,
                                     politics:$politics,
                                     education:$education,
                                     countryRaisedIn:$countryRaisedIn,
                                     doYouSmoke:$doYouSmoke,
                                     doYouDrink:$doYouDrink,
                                     doYouWorkOut:$doYouWorkOut,
                                     food:$food,
                                     formUpdated:$formUpdated)
                            .environmentObject(photoModel)
                            .environmentObject(profileModel)

                    case .previewProfile:
                        PreviewProfile()
                            .environmentObject(photoModel)
                            .environmentObject(profileModel)
                }

                Spacer()
            }
            .padding(.top)
            .navigationBarHidden(true)
        }
    }
    
    var tabButtons: some View {
        // Tab Buttons
        HStack {
            Spacer()

            EditProfileButtons(buttonName:"Edit Info",
                               selectedTab:$selectedTab)
            .onTapGesture {
                currentPage = .editProfile
                selectedTab = "Edit Info"
            }
            .padding(.horizontal,20)

            Spacer()

            EditProfileButtons(buttonName:"Preview",
                               selectedTab:$selectedTab)
            .onTapGesture {
                currentPage = .previewProfile
                selectedTab = "Preview"
            }
            .padding(.horizontal,20)

            Spacer()
        }

    }
}

struct EditProfileButtons: View {
    @Environment(\.colorScheme) var colorScheme
    @State var currentPage: EditOrPreviewProfile = .editProfile
    @State var buttonName: String
    @Binding var selectedTab: String
    
    var body: some View {
        
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .foregroundColor(selectedTab == buttonName ? Color.blue : (colorScheme == .dark ? Color(hex: 0x24244A) : Color(hex: 0xe8f4f8)))
                .frame(height:40)
                
            Text(buttonName)
                .font(.subheadline)
                .padding(.horizontal,20)
                .foregroundColor(selectedTab == buttonName ? Color.white : .accentColor)
        }
        
        
    }
        
}



struct EditProfile_Previews: PreviewProvider {
    static var previews: some View {
        EditProfile(profileEditingToBeDone: Binding.constant(true))
            .environmentObject(PhotoModel())
            .environmentObject(ProfileViewModel())
    }
}


