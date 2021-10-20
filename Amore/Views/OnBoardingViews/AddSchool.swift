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
    @EnvironmentObject var streamModel: StreamViewModel
    
    @State var schoolName : String = ""
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
        if (schoolName.count > 0) {
            profileModel.userProfile.school = schoolName
        }
        else {
            profileModel.userProfile.school = "NA"
        }
    }
    
    var body: some View {
        
        VStack(alignment:.leading) {
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
                let status = profileModel.createUserProfile()
                // Create Stream Chat User Profile - Only called once during profile creation
                streamModel.createUserProfileInStream(userName: profileModel.userProfile.firstName ?? "No Name")
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
