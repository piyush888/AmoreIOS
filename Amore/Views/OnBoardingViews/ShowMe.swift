//
//  ShowMe.swift
//  Amore
//
//  Created by Kshitiz Sharma on 9/29/21.
//

// Show me Male, Female or Both

import SwiftUI

struct ShowMe: View {
    @EnvironmentObject var profileModel: ProfileViewModel
    
    let showMeList = ["Women", "Men", "Non Binary","Everyone"]
    @State var selectShowMe: String? = nil
    @State var formComplete: Bool = false
    @State var showAlert: Bool = false
    @State var errorDesc: String = ""
    
    func checkShowMeIsNil () {
        if let showMeTemp = selectShowMe {
            profileModel.userProfile.showMePreference = showMeTemp
            formComplete = true
        }
        else {
            formComplete = false
            self.showAlert =  true
            self.errorDesc = "Please select atleast one Show Me gender types"
        }
    }
    
    
    var body: some View {
        
        VStack(alignment:.leading) {
            
            SelectSingleItem(selection: $selectShowMe.bound,
                             optionsList: showMeList,
                             filterName: "Show Me")
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
            destination: WorkSchoolCareer()
                .environmentObject(profileModel),
            isActive: $formComplete,
            label: {
                Button{
                    self.checkShowMeIsNil()
                } label : {
                    ContinueButtonDesign()
                }
                .padding(.horizontal,30)
                .padding(.bottom, 10)
            })
    }
}


struct ShowMe_Previews: PreviewProvider {
    static var previews: some View {
        ShowMe()
            .environmentObject(ProfileViewModel())
    }
}
