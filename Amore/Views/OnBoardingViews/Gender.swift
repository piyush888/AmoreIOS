//
//  IAmA.swift
//  Amore
//
//  Created by Kshitiz Sharma on 9/25/21.
//

import SwiftUI

struct Gender: View {
    @EnvironmentObject var profileModel: ProfileViewModel
    
    let genders = ["Male", "Female", "Non Binary"]
    @State var selectedGender: String? = nil
    @State var customGender: String = ""
    @State var showAlert: Bool = false
    
    @State private var validationError = false
    @State var errorDesc: String = ""
    @State var isGenderSet = false
    
    func addInputToProfile() {
        self.errorDesc = ""
        self.showAlert = false
        if(selectedGender != nil) {
            profileModel.userProfile.genderIdentity = selectedGender
            self.isGenderSet = true
        } else {
            self.errorDesc =  "Please choose atleast one gender"
            self.showAlert = true
        }
    }
    
    var body: some View {
        
        VStack(alignment:.leading) {
            
            SelectSingleItem(selection: $selectedGender.bound,
                             optionsList: genders,
                             filterName: "Gender")
                .padding(.vertical,10)
                .padding(.horizontal,20)
                
            navigationButton
                .padding(.horizontal,20)
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Alert"),
                  message: Text("\(errorDesc)"), dismissButton: .default(Text("OK"))
            )
        }
        
    }
    
    var navigationButton: some View {
        NavigationLink(
            destination: SexualOrientation()
                .environmentObject(profileModel),
            isActive: $isGenderSet,
            label: {
                Button{
                    self.addInputToProfile()
                } label : {
                    ContinueButtonDesign(buttonText:"Continue")
                }
                .padding(.horizontal,30)
                .padding(.bottom, 10)
            })
    }
    
}

struct Gender_Previews: PreviewProvider {
    static var previews: some View {
        Gender()
            .environmentObject(ProfileViewModel())
    }
}
