//
//  WorkSchoolCareer.swift
//  Amore
//
//  Created by Kshitiz Sharma on 9/29/21.
//

import SwiftUI

struct WorkSchoolCareer: View {
    
    var careerList = ["Accommodation and Food Services", "Arts, Entertainment and Recreation", "Automobile", "Construction", "Consumer Services", "Education", "Energy", "Fashion", "Finance", "Government", "Healthcare", "Information", "Law Professional", "Manufacturing", "Media & Entertainment", "Mining", "Real Estate", "Retail Trade", "Space", "Start Up", "Student", "Technology", "Transportation", "Other", "No Industry"]
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @EnvironmentObject var profileModel: ProfileViewModel
    
    @State var jobTitle : String? = ""
    @State var companyName : String? = ""
    @State var industry : String = ""
    @State var education : String = ""
    @State var schoolName : String? = ""
    
    @State var showAlert: Bool = false
    @State var errorDesc: String = ""
    @State var finishOnboarding: Bool = false
    
    
    func checkWorkSchoolCareerFilled () {
        if (self.industry != "") && (self.education != "") {
            DispatchQueue.main.async {
                profileModel.userProfile.careerField = industry
                
                profileModel.userProfile.jobTitle = jobTitle
                profileModel.userProfile.work = companyName
                
                profileModel.userProfile.education = education
                profileModel.userProfile.school = schoolName
                
                // Execute "Create Profile Document in Firestore"
                profileModel.calculateProfileCompletion()
                let status = profileModel.createUserProfile()
                print("Profile Saved: \(status)")
                self.finishOnboarding = true
            }
        } else {
            self.errorDesc = "Please atleast provide Industry & Education."
            self.showAlert = true
        }
    }
    
    var body: some View {
        
        VStack(alignment:.leading) {
            
            Form {
                Group {
                    
                    // Industry
                    Section(header: Text("Your Industry")) {
                        // Career Filter
                        SelectionForm(selection:$industry,
                                  formName: "Industry",
                                  selectionsList: careerList,
                                  formUpdated: Binding.constant(false))
                    }
                    
                    
                    // Work
                    Section(header: Text("Work")) {
                            EditCardForm(formHeight: 40.0,
                                    formHeadLine: "Position Title: Sr Manager",
                                    formInput: $jobTitle,
                                    maxChars:30)
                        
                            EditCardForm(formHeight: 40.0,
                                        formHeadLine: "Company Name e.g. Google",
                                        formInput: $companyName,
                                        maxChars:30)
                    }
                    
                    // Education
                    Section(header: Text("Education")) {
                          SelectionForm(selection:$education,
                                  formName: "Education",
                                  selectionsList: ["Doctorate", "Masters",
                                                   "Bachelors", "Associates",
                                                   "Trade School", "High School",
                                                   "No Education"],
                                        formUpdated: Binding.constant(false))
                        
                            EditCardForm(formHeight: 40.0,
                                        formHeadLine: "School Name e.g. Harvard",
                                        formInput: $schoolName,
                                         maxChars:30)
                    }
                }
                //Form
                
            }
            
            // Continue/Skip to next view
            Button{
                // Chek if client has atleast provide Industry & School
                self.checkWorkSchoolCareerFilled()
            } label : {
                ZStack{
                    ContinueButtonDesign(buttonText:"Continue")
                }
            }
            .padding(.horizontal,30)
            .padding(.bottom, 10)
        }
        .navigationBarTitle("My School is")
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Alert"),
                  message: Text("\(errorDesc)"), dismissButton: .default(Text("OK"))
            )
        }
    }
}

struct AddSchool_Previews: PreviewProvider {
    static var previews: some View {
        WorkSchoolCareer()
            .environmentObject(ProfileViewModel())
    }
}


