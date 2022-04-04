//
//  AddSchool.swift
//  Amore
//
//  Created by Kshitiz Sharma on 9/29/21.
//

import SwiftUI

struct AddSchool: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @EnvironmentObject var profileModel: ProfileViewModel
    
    @State var schoolName : String = ""
    @State var education : String = ""
    
    @State var continueToNext: Bool = false
    var buttonText: String {
        if (schoolName.count > 0) {
            return "Continue"
        }
        else {
            return "Skip"
        }
    }
    
    func addInputToProfile () {
        profileModel.userProfile.education = education.count > 0 ? education : ""
        profileModel.userProfile.school = schoolName.count > 0 ? schoolName : ""
        continueToNext = true
    }
    
    var body: some View {
        
        VStack(alignment:.leading) {
            
            // Degree
            ZStack{
                Rectangle()
                    .cornerRadius(5.0)
                    .frame(height:45)
                    .foregroundColor(.white)
                    .overlay(RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.pink, lineWidth: 1))
                    
                TextField("Education", text: $education)
                    .padding()
            }
            
            // School Name
            ZStack{
                Rectangle()
                    .cornerRadius(5.0)
                    .frame(height:45)
                    .foregroundColor(.white)
                    .overlay(RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.pink, lineWidth: 1))
                    
                TextField("School Name", text: $schoolName)
                    .padding()
            }
            
            
            
            Spacer()
            
            
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
                    Rectangle()
                        .frame(height:45)
                        .cornerRadius(5.0)
                        .foregroundColor(.pink)
                        
                    Text(buttonText)
                        .foregroundColor(.white)
                        .bold()
                        .font(.BoardingButton)
                }
            }.padding(.bottom, 10)
        }
        .padding(20)
        .navigationBarTitle("My School is")
    }
}

struct AddSchool_Previews: PreviewProvider {
    static var previews: some View {
        AddSchool()
            .environmentObject(ProfileViewModel())
    }
}
