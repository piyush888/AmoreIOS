//
//  Passions.swift
//  Amore
//
//  Created by Kshitiz Sharma on 9/28/21.
//

import SwiftUI
import FirebaseFirestoreSwift


var passionsList = ["Animals", "Art", "Business", "Comedy", "Community Service", "Cooking", "Cricket", "Dancing", "Drink", "Entrepreneurship", "Extreme", "Fashion", "Fitness", "Introvert", "Gaming", "Gardening", "Healthy Eating", "Hiking", "Meditation", "Movies", "Music", "Nature", "Nature", "Partying", "Personal Growth", "Pets", "Photography", "Programming", "Reading", "Relationship", "Relaxation", "Running", "Shopping", "Singing", "Social Engagement", "Social Media", "Spirituality", "Sports", "Swimming", "Travelling", "Trekking", "Volunteering", "Walking", "Workout", "Yoga", "Sleeping","Other"]

struct Passions: View {
    
    @EnvironmentObject var profileModel: ProfileViewModel
    @State var isPassionsSelectionDone: Bool = false
    @State var showAlert: Bool = false
    @State var errorDesc: String = ""
    @Environment(\.colorScheme) var colorScheme
    
    
    @State var passionSelected = [String]()
    
    
    func checkPassionsSelectionDone() {
        self.errorDesc = ""
        showAlert = false
        if (passionSelected.count > 2) {
            profileModel.userProfile.interests = passionSelected
            isPassionsSelectionDone = true
        }
        else {
            isPassionsSelectionDone = false
            self.errorDesc =  "Please choose atleast 3 passions"
            self.showAlert = true
        }
    }
    
    
    var body: some View {
        
        VStack(alignment:.leading) {
            
            Text("Select a few of your interests and let everyone know what you're passionate about")
                .padding(.top,5)
                .padding(.horizontal,30)
                .foregroundColor(colorScheme == .dark ? Color.white: Color.gray)
                .font(.caption)
            
            SelectMultipleItems(selectionList:$passionSelected,
                        optionsList:passionsList,
                        filterName:"Passions")
                .padding(.horizontal,20)
                
    
            // Continue to next view
            navigationButton
                .padding(.horizontal,20)
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Alert"),
                  message: Text("\(self.errorDesc)"), dismissButton: .default(Text("OK"))
            )
        }
    }
    
    var navigationButton: some View {
        NavigationLink(
            destination: Gender()
                .environmentObject(profileModel),
            isActive: $isPassionsSelectionDone,
            label: {
                Button{
                    checkPassionsSelectionDone()
                } label : {
                    ContinueButtonDesign(buttonText:"Continue")
                }
                .padding(.horizontal,30)
                .padding(.bottom, 10)
            })
    }
}


struct Passions_Previews: PreviewProvider {
    static var previews: some View {
        Passions()
            .environmentObject(ProfileViewModel())
    }
}
