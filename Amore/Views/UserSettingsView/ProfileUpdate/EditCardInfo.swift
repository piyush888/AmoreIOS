//
//  EditCardInfo.swift
//  Amore
//
//  Created by Kshitiz Sharma on 10/24/21.
//

import SwiftUI
import SDWebImageSwiftUI

struct EditCardInfo: View {
    @EnvironmentObject var photoModel: PhotoModel
    @EnvironmentObject var profileModel: ProfileViewModel
    
    func populateImages() {
        if photoModel.downloadedPhotos.count<2 {
            photoModel.populatePhotos()
        }
        photoModel.downloadedPhotos.sort { $0.id! < $1.id! }
        photoModel.photosForUploadUpdate = photoModel.downloadedPhotos
    }
    
    let adaptivecolumns = Array(repeating:
                                    GridItem(.adaptive(minimum: 150),spacing: 5,
                                             alignment: .center),count: 3)
    
    var body: some View {
        
        ScrollView(.vertical, showsIndicators: false, content: {
            VStack {
                
                // Display Photos
                LazyVGrid(columns: adaptivecolumns, content: {
                    UploadWindowsGroup()
                        .environmentObject(photoModel)
                }).onAppear {
                    populateImages()
                }
                
                
                
                Group {
                    // Edit Headline
                    EditCardForm(formHeight: 40.0,
                                 formHeadLine: "Headline",
                                 formInput: $profileModel.editUserProfile.headline)
                    
                    // Edit About Me
                    EditCardForm(formHeight: 100.0,
                                 formHeadLine: "About Me",
                                 formInput: $profileModel.editUserProfile.description)
                    
                    // Job title
                    EditCardForm(formHeight: 40.0,
                                 formHeadLine: "Job Title",
                                 formInput: $profileModel.editUserProfile.jobTitle)
                    
                    
                    // Add Company
                    EditCardForm(formHeight: 40.0,
                                 formHeadLine: "Add Company",
                                 formInput: $profileModel.editUserProfile.work)
                    
                    // Add School
                    EditCardForm(formHeight: 40.0,
                                 formHeadLine: "Add School",
                                 formInput: $profileModel.editUserProfile.school)
                }
                
                Group {
                    // Basic Info
                    HStack {
                        Text("Basic Info")
                            .font(.headline)
                            .frame(alignment: .leading)
                        Spacer()
                    }
                    
                    UserProfileBasicInfo(genderPreference: $profileModel.editUserProfile.genderIdentity, religionPreference: $profileModel.editUserProfile.religion, communityPreference: $profileModel.editUserProfile.community, careerPreference: $profileModel.editUserProfile.workType, educationPreference: $profileModel.editUserProfile.education, countryPreference: $profileModel.editUserProfile.country)
                }
                
                Group {
                    // Discovery
                    VStack(alignment: .leading) {
                        Toggle(isOn: $profileModel.editUserProfile.discoveryStatus.boundBool) {
                            Text("Discovery")
                                .font(.subheadline)
                            Image(systemName: "magnifyingglass")
                        }
                        Text("Found someone? Take a break, hide your card. You can still chat with your matches")
                            .font(.caption2)
                    }.padding([.top,.bottom],10)
                    
                    
                    // Notifications
                    VStack(alignment: .leading) {
                        Toggle(isOn: $profileModel.editUserProfile.notificationsStatus.boundBool) {
                            Text("Notifications")
                                .font(.subheadline)
                            Image(systemName: "bell.fill")
                        }
                        Text("Want to be notified when you find a match, turn on that notification?")
                            .font(.caption2)
                    }.padding([.top,.bottom],10)
                }
                
                Group {
                    // Contact Support
                    ContactSupport()
                    
                    // Delete Profile
                    DeleteProfileButton()
                }
                .padding(.top,40)
                
                
            }.padding(.horizontal,20)
        })
    }
}

struct EditCardInfo_Previews: PreviewProvider {
    static var previews: some View {
        EditCardInfo()
            .environmentObject(PhotoModel())
            .environmentObject(ProfileViewModel())
    }
}
