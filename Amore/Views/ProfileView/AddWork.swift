//
//  AddWork.swift
//  Amore
//
//  Created by Kshitiz Sharma on 9/29/21.
//

import SwiftUI

struct AddWork: View {
    
    @ObservedObject var profileModel: ProfileViewModel
    @State var workName : String = ""
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
        if (workName.count > 0) {
            profileModel.userProfile?.work = workName
        }
        continueToNext = true
    }
    
    var body: some View {
        
        VStack(alignment:.leading) {
//            HStack {
//                Text("I work at")
//                    .font(.BoardingTitle)
//                    .padding(.bottom, 10)
//                Spacer()
//            }
//            .padding(.bottom,80)
            // School Name
            ZStack{
                Rectangle()
                    .cornerRadius(5.0)
                    .frame(height:45)
                    .foregroundColor(.white)
                    .overlay(RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.pink, lineWidth: 1))
                    
                TextField("Add Work", text: $workName)
                    .padding()
            }
            
            Spacer()
            
            // Continue to next view
            NavigationLink(destination: AddSchool(profileModel: profileModel),
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
        AddWork(profileModel: ProfileViewModel())
    }
}
