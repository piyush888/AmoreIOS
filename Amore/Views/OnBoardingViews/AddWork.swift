//
//  AddWork.swift
//  Amore
//
//  Created by Kshitiz Sharma on 9/29/21.
//

import SwiftUI

struct AddWork: View {
    @EnvironmentObject var profileModel: ProfileViewModel
//    @EnvironmentObject var streamModel: StreamViewModel
    
    @State var workName : String = ""
    @State var jobTitle : String = ""
    
    @State var continueToNext: Bool = false
    var buttonText: String {
        if (workName.count > 0) {
            return "Continue"
        }
        else {
            return "Skip"
        }
    }
    
    func addInputToProfile () {
        profileModel.userProfile.work = workName.count > 0 ? workName : ""
        profileModel.userProfile.jobTitle = jobTitle.count > 0 ? jobTitle : ""
        continueToNext = true
    }
    
    var body: some View {
        
        VStack(alignment:.leading) {

            // Work Office Name
            ZStack{
                Rectangle()
                    .cornerRadius(5.0)
                    .frame(height:45)
                    .foregroundColor(.white)
                    .overlay(RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.pink, lineWidth: 1))
                    
                TextField("Job role title", text: $jobTitle)
                    .padding()
            }
            
            // Work Office Name
            ZStack{
                Rectangle()
                    .cornerRadius(5.0)
                    .frame(height:45)
                    .foregroundColor(.white)
                    .overlay(RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.pink, lineWidth: 1))
                    
                TextField("Company Name", text: $workName)
                    .padding()
            }
            
            Spacer()
            
            // Continue to next view
            NavigationLink(destination: AddSchool()
                            .environmentObject(profileModel),
//                            .environmentObject(streamModel),
                           isActive: $continueToNext,
                           label: {
                Button{
                    addInputToProfile()
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
            })
            
            
        }
        .padding(20)
        .navigationBarTitle("I Work at")
        
    }
}

struct AddWork_Previews: PreviewProvider {
    static var previews: some View {
        AddWork()
            .environmentObject(ProfileViewModel())
    }
}
