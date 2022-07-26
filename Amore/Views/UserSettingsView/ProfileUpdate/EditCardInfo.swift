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
    
    let adaptivecolumns = Array(repeating:
                                    GridItem(.adaptive(minimum: 150),spacing: 5,
                                             alignment: .center),count: 3)
    
    @StateObject var formDataObj = LoadEditProfileFormData()
    
    func returnFilterBinding(formName:String) -> Binding<String?> {
        switch formName {
            
            case "Career":
                return $profileModel.editUserProfile.careerField
            
            case "Religion":
                return $profileModel.editUserProfile.religion
            
            case "Political":
                return $profileModel.editUserProfile.politics
            
            case "Education":
                return $profileModel.editUserProfile.education
            
            case "Raised In":
                return $profileModel.editUserProfile.countryRaisedIn
        
            default:
                return Binding.constant("")
        }
    }
    
    var body: some View {
        
//        ScrollView(.vertical, showsIndicators: false, content: {
            Form {
                
                // Photos only
                Section(header: Text("Photos")) {
                    ZStack{
                        // Display Photos
                        LazyVGrid(columns: adaptivecolumns, content: {
                            UploadWindowsGroup()
                                .environmentObject(photoModel)
                        })
                        .disabled(photoModel.photoAction)
                        .grayscale(photoModel.photoAction ? 0.5 : 0)
                    
                        if photoModel.photoAction {
                            ProgressView()
                                .scaleEffect(x: 3, y: 3, anchor: .center)
                        }
                    }
                    .padding(.vertical,10)
                }
                
                
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
                
                // Add Education
                EditCardForm(formHeight: 40.0,
                                formHeadLine: "Add Education",
                                formInput: $profileModel.editUserProfile.education)
                
                // Add School
                EditCardForm(formHeight: 40.0,
                                formHeadLine: "Add School",
                                formInput: $profileModel.editUserProfile.school)
            
                
                ForEach(0..<formDataObj.editCardFormData.count) { index in
                    
                    SelectionForm(selection: returnFilterBinding(formName: formDataObj.editCardFormData[index].selectionFormName),
                                  formName: formDataObj.editCardFormData[index].selectionFormName,
                                  selectionsList: formDataObj.editCardFormData[index].selectionLists)
                }
                
                Section(header: Text("Basic Info")) {
                    UserProfileBasicInfo(genderPreference: $profileModel.editUserProfile.genderIdentity,
                                         religionPreference: $profileModel.editUserProfile.religion,
                                         communityPreference: $profileModel.editUserProfile.community,
                                         careerPreference: $profileModel.editUserProfile.careerField,
                                         countryRaisedIn: $profileModel.editUserProfile.countryRaisedIn)
                }
                
                
                // Discoverty and Notifications
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
                
                    
                    // Contact Support or Delete Acccount
                    Group {
                        // Contact Support
                        ContactSupport()
                        
                        // Delete Profile
                        DeleteProfileButton()
                    }
                    .padding(.top,40)
                }
                
            }
//        })
    }
}

struct EditCardInfo_Previews: PreviewProvider {
    static var previews: some View {
        EditCardInfo()
            .environmentObject(PhotoModel())
            .environmentObject(ProfileViewModel())
    }
}
