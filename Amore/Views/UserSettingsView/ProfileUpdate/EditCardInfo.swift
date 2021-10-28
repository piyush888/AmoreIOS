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
    @State var images = [UIImage?](repeating: nil, count: 6)
    
    func populateImages() {
        if photoModel.downloadedPhotos.count<2 {
            photoModel.populatePhotos()
        }
        for (index, photo) in photoModel.downloadedPhotos.enumerated() {
            self.images[index] = photo.image
        }
    }
    
    let adaptivecolumns = Array(repeating:
                                    GridItem(.adaptive(minimum: 150),spacing: 5,
                                             alignment: .center),count: 3)
    
    var body: some View {
        
        ScrollView(.vertical, showsIndicators: false, content: {
            VStack {
                
                // Display Photos
                LazyVGrid(columns: adaptivecolumns, content: {
                    UploadPhotoWindow(image: self.$images[0])
                    UploadPhotoWindow(image: self.$images[1])
                    UploadPhotoWindow(image: self.$images[2])
                    UploadPhotoWindow(image: self.$images[3])
                    UploadPhotoWindow(image: self.$images[4])
                    UploadPhotoWindow(image: self.$images[5])
                }).onAppear {
                    populateImages()
                }
                
                
                
                Group {
                    // Edit Headline
                    EditCardForm(formHeight: 40.0,
                                 formHeadLine: "Headline",
                                 formInput: $profileModel.userProfile.headline)
                    
                    // Edit About Me
                    EditCardForm(formHeight: 100.0,
                                 formHeadLine: "About Me",
                                 formInput: $profileModel.userProfile.description)
                    
                    // Job title
                    EditCardForm(formHeight: 40.0,
                                 formHeadLine: "Job Title",
                                 formInput: $profileModel.userProfile.jobTitle)
                    
                    
                    // Add Company
                    EditCardForm(formHeight: 40.0,
                                 formHeadLine: "Add Company",
                                 formInput: $profileModel.userProfile.work)
                    
                    // Add School
                    EditCardForm(formHeight: 40.0,
                                 formHeadLine: "Add School",
                                 formInput: $profileModel.userProfile.school)
                }
                
                Group {
                    // Basic Info
                    Text("Basic Info")
                        .font(.headline)
                    UserProfileBasicInfo(genderPreference: $profileModel.userProfile.genderIdentity, religionPreference: $profileModel.userProfile.religion, communityPreference: $profileModel.userProfile.community, careerPreference: $profileModel.userProfile.workType, educationPreference: $profileModel.userProfile.education, countryPreference: $profileModel.userProfile.country)
                }
                
                Group {
                    // Discovery
                    VStack(alignment: .leading) {
                        Toggle(isOn: $profileModel.userProfile.discoveryStatus.boundBool) {
                            Text("Discovery")
                                .font(.subheadline)
                            Image(systemName: "magnifyingglass")
                        }
                        Text("Found someone? Take a break, hide your card. You can still chat with your matches")
                            .font(.caption2)
                    }.padding([.top,.bottom],10)
                    
                    
                    // Notifications
                    VStack(alignment: .leading) {
                        Toggle(isOn: $profileModel.userProfile.notificationsStatus.boundBool) {
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
