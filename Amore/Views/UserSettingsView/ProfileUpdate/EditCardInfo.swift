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
    
    var formDataObj = LoadEditProfileFormData()
    
    // About You Variables
    @Binding var careerField: String?
    @Binding var religion: String?
    @Binding var politics: String?
    @Binding var education: String?
    @Binding var countryRaisedIn: String?
    @Binding var doYouSmoke: String?
    @Binding var doYouDrink: String?
    @Binding var doYouWorkOut: String?
    @Binding var formUpdated: Bool
    
    
    func aboutYouVariablesBinding(formName:String) -> Binding<String> {
        switch formName {
            
            case "Career":
                return $careerField.bound
            
            case "Religion":
                return $religion.bound
            
            case "Political":
                return $politics.bound
            
            case "Education":
                return $education.bound
            
            case "Raised In":
                return $countryRaisedIn.bound
            
            case "Smoking":
                return $doYouSmoke.bound
            
            case "Drinks":
                return $doYouDrink.bound
            
            case "Workout":
                return $doYouWorkOut.bound

            default:
                return Binding.constant("")
        }
    }
    
    var body: some View {
        
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
            
                // Please update this About You List every time a field is added or removed
                /// Career, Religion, Political, Education,Raised In, Smoking, Drinks, Workout
                Section(header: Text("About you")) {
                    ForEach(0..<formDataObj.editCardFormData.count) { index in
                        SelectionForm(selection:self.aboutYouVariablesBinding(formName: formDataObj.editCardFormData[index].selectionFormName),
                                      formName: formDataObj.editCardFormData[index].selectionFormName,
                                      selectionsList: formDataObj.editCardFormData[index].selectionLists,
                                      formUpdated:$formUpdated)
                                    .environmentObject(profileModel)
                    }
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

    }
}

struct EditCardInfo_Previews: PreviewProvider {
    static var previews: some View {
        EditCardInfo(careerField:Binding.constant("Fashion"),
                     religion:Binding.constant("Atheism"),
                     politics:Binding.constant("Far Left"),
                     education:Binding.constant("High School"),
                     countryRaisedIn:Binding.constant("India"),
                     doYouSmoke:Binding.constant("Socially"),
                     doYouDrink:Binding.constant("Socially"),
                     doYouWorkOut:Binding.constant("Socially"),
                     formUpdated:Binding.constant(false))
            .environmentObject(PhotoModel())
            .environmentObject(ProfileViewModel())
    
    }
}
