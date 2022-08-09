//
//  AddSchool.swift
//  Amore
//
//  Created by Kshitiz Sharma on 9/29/21.
//

import SwiftUI

struct AddSchool: View {
    
    var careerList = ["Accommodation and Food Services", "Arts, Entertainment and Recreation", "Automobile", "Construction", "Consumer Services", "Education", "Energy", "Fashion", "Finance", "Government", "Healthcare", "Information", "Law Professional", "Manufacturing", "Media & Entertainment", "Mining", "Real Estate", "Retail Trade", "Space", "Start Up", "Student", "Technology", "Transportation", "Other", "No Industry"]
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @EnvironmentObject var profileModel: ProfileViewModel
    
    @State var schoolName : String? = ""
    @State var companyName : String? = ""
    @State var jobTitle : String? = ""
    
    @State var industry : String = ""
    @State var industryCompleted : Bool = false
    
    @State var education : String = ""
    @State var educationCompleted : Bool = false
    
    
    
    @State var continueToNext: Bool = false
    
    var buttonText: String {
        if industry != "" || education != "" {
                return "Continue"
            }
            else {
                return "Skip"
            }
    }
        
    func addInputToProfile () {
        profileModel.userProfile.education = education.count > 0 ? education : ""
        profileModel.userProfile.school = schoolName.bound.count > 0 ? schoolName.bound : ""
        continueToNext = true
    }
    
    var body: some View {
        
        VStack(alignment:.leading) {
            
            Form {
                Group {
                    
                    // Education
                    Section(header: Text("Your Industry")) {
                        // Career Filter
                        SelectionForm(selection:$industry,
                                  formName: "Industry",
                                  selectionsList: careerList,
                                  formUpdated: $industryCompleted)
                                                                                
                    }
                    
                    // Education
                    Section(header: Text("Education")) {
                          SelectionForm(selection:$education,
                                  formName: "Education",
                                  selectionsList: ["Doctorate", "Masters",
                                                   "Bachelors", "Associates",
                                                   "Trade School", "High School",
                                                   "No Education"],
                                      formUpdated: $educationCompleted)
                        
                            EditCardForm(formHeight: 40.0,
                                        formHeadLine: "School Name",
                                         formInput: $schoolName)
                    }
                    
                    // Education
                    Section(header: Text("Work")) {
                            EditCardForm(formHeight: 40.0,
                                    formHeadLine: "Position Title: Sr Manager",
                                    formInput: $jobTitle)
                        
                            EditCardForm(formHeight: 40.0,
                                        formHeadLine: "Company Name e.g. Google",
                                        formInput: $companyName)
                    }
                    
                }
                
            }
            
            // Continue/Skip to next view
            Button{
                addInputToProfile()
                // Execute "Create Profile Document in Firestore"
                profileModel.calculateProfileCompletion()
                let status = profileModel.createUserProfile()
                continueToNext = status
                print("Profile Saved: \(status)")
            } label : {
                ZStack{
                    
                    ContinueButtonDesign()
                        
                    Text(buttonText)
                        .foregroundColor(.white)
                        .bold()
                        .font(.BoardingButton)
                }
            }
            .padding(.horizontal,30)
            .padding(.bottom, 10)
        }
        .navigationBarTitle("My School is")
    }
}

struct AddSchool_Previews: PreviewProvider {
    static var previews: some View {
        AddSchool()
            .environmentObject(ProfileViewModel())
    }
}


