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
    @Binding var food: String?
    
    @Binding var formUpdated: Bool
    // User Height
    @State var height: Double = 0.0
    
    
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
            
            case "Food":
                return $food.bound
            
            default:
                return Binding.constant("")
        }
    }
    
    var body: some View {
        GeometryReader { geo in
            Form {
                // Photos only
                Section(header: Text("Photos")) {
                    ZStack{
                        // Display Photos
                        LazyVGrid(columns: adaptivecolumns, content: {
                            UploadWindowsGroup(width:geo.size.width/3.8,
                                               height:geo.size.height/4.8)
                                .environmentObject(profileModel)
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
                .navigationBarTitle("Upload Photos")
                .navigationBarTitleDisplayMode(.inline)
                
                // Edit Headline
                Section(header: Text("Headline")) {
                    EditCardForm(formHeight: 40.0,
                                    formHeadLine: "Headline",
                                    formInput: $profileModel.editUserProfile.headline)
                }
                .navigationBarTitle("Headline")
                .navigationBarTitleDisplayMode(.inline)
                
                
                // Edit About Me
                Section(header: Text("About Me")) {
                    EditCardForm(formHeight: 100.0,
                                    formHeadLine: "About Me",
                                    formInput: $profileModel.editUserProfile.description)
                }
                .navigationBarTitle("About Me")
                .navigationBarTitleDisplayMode(.inline)
                
                
                // Job title
                Section(header: Text("Work")) {
                    EditCardForm(formHeight: 40.0,
                                    formHeadLine: "Job Title",
                                    formInput: $profileModel.editUserProfile.jobTitle)
                    
                    // Add Company
                    EditCardForm(formHeight: 40.0,
                                    formHeadLine: "Company Name",
                                    formInput: $profileModel.editUserProfile.work)
                }
                .navigationBarTitle("Work")
                .navigationBarTitleDisplayMode(.inline)
                
                
                Section(header: Text("Education")) {
//                    // Add Education
//                    EditCardForm(formHeight: 40.0,
//                                    formHeadLine: "Highest Education",
//                                    formInput: $profileModel.editUserProfile.education)
//
                    // 3 corresponds to Education field
                    SelectionForm(selection:$education.bound,
                                  formName: "Education",
                                  selectionsList: ["Doctorate", "Masters", "Bachelors", "Associates", "Trade School", "High School", "No Education"],
                                  formUpdated:$formUpdated)
                                .environmentObject(profileModel)
                    
                    // Add School
                    EditCardForm(formHeight: 40.0,
                                    formHeadLine: "School Name",
                                    formInput: $profileModel.editUserProfile.school)
                }
                .navigationBarTitle("Education")
                .navigationBarTitleDisplayMode(.inline)
                
            
                // User Height
                Section(header: Text("Height")) {
                    UserHeight(height: $profileModel.editUserProfile.height.boundDouble)
                }
                .navigationBarTitle("Height")
                .navigationBarTitleDisplayMode(.inline)
                
            
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
                .navigationBarTitle("About you")
                .navigationBarTitleDisplayMode(.inline)
                
                    

                // Height
                // Passion or Interests
                
                // Discoverty and Notifications
                Section(header: Text("Card Settings")) {
                    // Discovery
                    VStack(alignment: .leading) {
                        Toggle(isOn: $profileModel.editUserProfile.discoveryStatus.boundBool) {
                            Image(systemName: "magnifyingglass")
                            Text("Discovery")
                        }
                        Text("Found someone? Take a break, hide your card. You can still chat with your matches")
                            .font(.caption2)
                    }.padding([.top,.bottom],10)
                    
                    
                    // Notifications
                    VStack(alignment: .leading) {
                        Toggle(isOn: $profileModel.editUserProfile.notificationsStatus.boundBool) {
                            Image(systemName: "bell.fill")
                            Text("Notifications")
                        }
                        Text("Want to be notified when you find a match, turn on that notification?")
                            .font(.caption2)
                    }.padding([.top,.bottom],10)
                }
                .navigationBarTitle("Card Settings")
                .navigationBarTitleDisplayMode(.inline)
                
                
                
                Section(header: Text("Others")) {
                    // Contact Support
                    ContactSupport()
                    
                    // Delete Profile
                    DeleteProfileButton()
                }
                .navigationBarTitle("Others")
                .navigationBarTitleDisplayMode(.inline)
            }
        }
    }
}

struct EditCardInfo_Previews: PreviewProvider {
    static var previews: some View {
        
        EditCardInfo(careerField:Binding.constant("Company Name"),
                     religion:Binding.constant("Atheism"),
                     politics:Binding.constant("Far Left"),
                     education:Binding.constant("High School"),
                     countryRaisedIn:Binding.constant("India"),
                     doYouSmoke:Binding.constant("Socially"),
                     doYouDrink:Binding.constant("Socially"),
                     doYouWorkOut:Binding.constant("Socially"),
                     food:Binding.constant("Vegetarian"),
                     formUpdated:Binding.constant(false))
            .environmentObject(PhotoModel())
            .environmentObject(ProfileViewModel())
            .previewDisplayName("iPhone 13 Pro Max")
            .previewDevice("iPhone 13 Pro Max")
        
        
        
        EditCardInfo(careerField:Binding.constant("Company Name"),
                     religion:Binding.constant("Atheism"),
                     politics:Binding.constant("Far Left"),
                     education:Binding.constant("High School"),
                     countryRaisedIn:Binding.constant("India"),
                     doYouSmoke:Binding.constant("Socially"),
                     doYouDrink:Binding.constant("Socially"),
                     doYouWorkOut:Binding.constant("Socially"),
                     food:Binding.constant("Vegetarian"),
                     formUpdated:Binding.constant(false))
            .environmentObject(PhotoModel())
            .environmentObject(ProfileViewModel())
            .previewDisplayName("iPhone 13 Mini")
            .previewDevice("iPhone 13 Mini")
        
        
        
        EditCardInfo(careerField:Binding.constant("Company Name"),
                     religion:Binding.constant("Atheism"),
                     politics:Binding.constant("Far Left"),
                     education:Binding.constant("High School"),
                     countryRaisedIn:Binding.constant("India"),
                     doYouSmoke:Binding.constant("Socially"),
                     doYouDrink:Binding.constant("Socially"),
                     doYouWorkOut:Binding.constant("Socially"),
                     food:Binding.constant("Vegetarian"),
                     formUpdated:Binding.constant(false))
            .environmentObject(PhotoModel())
            .environmentObject(ProfileViewModel())
            .previewDisplayName("iPhone 12 Pro")
            .previewDevice("iPhone 12 Pro")
        
        
        
        EditCardInfo(careerField:Binding.constant("Company Name"),
                     religion:Binding.constant("Atheism"),
                     politics:Binding.constant("Far Left"),
                     education:Binding.constant("High School"),
                     countryRaisedIn:Binding.constant("India"),
                     doYouSmoke:Binding.constant("Socially"),
                     doYouDrink:Binding.constant("Socially"),
                     doYouWorkOut:Binding.constant("Socially"),
                     food:Binding.constant("Vegetarian"),
                     formUpdated:Binding.constant(false))
            .environmentObject(PhotoModel())
            .environmentObject(ProfileViewModel())
            .previewDisplayName("iPhone 11")
            .previewDevice("iPhone 11")
    

    }
}
