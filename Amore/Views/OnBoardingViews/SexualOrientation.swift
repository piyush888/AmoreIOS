//
//  SexualOrientation.swift
//  Amore
//
//  Created by Kshitiz Sharma on 9/29/21.
//

import SwiftUI

struct SexualOrientation: View {
    
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var profileModel: ProfileViewModel
    
    @State var errorDesc: String = ""
    @State var showAlert: Bool = false

    var selectionOrientationList = ["Straight","Gay","Lesbian","Bisexual",
                                    "Asexual","Demisexual","Pansexual",
                                    "Queer","Questioning","Other"]
    
    @State var orientationsSelected = [String]()
    @State var showMyOrientation: Bool = false
    @State var sexualOrientationDataTaken: Bool = false
    
    func checkSexualOrientation () {
        if (orientationsSelected.count > 0) {
            sexualOrientationDataTaken = true
            profileModel.userProfile.sexualOrientation = orientationsSelected
            profileModel.userProfile.sexualOrientationVisible = showMyOrientation
        }
        else {
            sexualOrientationDataTaken = false
            self.showAlert = true
            self.errorDesc = "Please select atleast one Sexual Orientation"
        }
    }
    
    var body: some View {
        
        VStack(alignment:.leading) {
            
            SelectMultipleItems(selectionList:$orientationsSelected,
                        optionsList:selectionOrientationList,
                        filterName:"Sexual Orientation")
                .padding(.horizontal,20)
            
            
            Spacer()
            
            // Ask user if they want to show the orientation on profile
            Toggle(isOn: $showMyOrientation, label: {
                Text("Show my orientation on my profile")
                    .foregroundColor(.gray)
                    .font(.system(size: 15, design: .default))
            })
            .padding()
            .toggleStyle(CheckboxStyle())
            
            // Continue to next view
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
            destination: ShowMe()
                .environmentObject(profileModel),
            isActive: $sexualOrientationDataTaken,
            label: {
                Button{
                    checkSexualOrientation()
                } label : {
                    ContinueButtonDesign()
                }
                .padding(.horizontal,30)
                .padding(.top,10)
            })
    }
}

struct CheckboxStyle: ToggleStyle {
    
    func makeBody(configuration: Self.Configuration) -> some View {
        
        return HStack {
            
            configuration.label
            
            Spacer()
            
            Image(systemName: configuration.isOn ? "checkmark.circle.fill" : "circle")
                .resizable()
                .frame(width: 16, height: 16)
                .foregroundColor(.gray)
                .font(.system(size: 15, design: .default))
                .onTapGesture {
                    configuration.isOn.toggle()
                }
        }
        
    }
}

struct SexualOrientation_Previews: PreviewProvider {
    static var previews: some View {
        SexualOrientation()
            .environmentObject(ProfileViewModel())
    }
}
