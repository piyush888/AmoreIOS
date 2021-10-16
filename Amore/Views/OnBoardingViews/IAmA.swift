//
//  IAmA.swift
//  Amore
//
//  Created by Kshitiz Sharma on 9/25/21.
//

import SwiftUI

struct IAmA: View {
    @EnvironmentObject var profileModel: ProfileViewModel
    
    let genders = ["male", "female", "other"]
    @State var selectedGender: String? = nil
    @State var customGender: String = ""
    
    @State private var validationError = false
    @State private var errorDesc = Text("")
    @State var isGenderSet = false
    
    func addInputToProfile() {
        if let selected_Gender = selectedGender {
            if selected_Gender == "other" {
                if customGender != "" {
                    // Store the customGender in the firebase
                    print(customGender)
                    profileModel.userProfile.genderIdentity = customGender
                    isGenderSet = true
                } else {
                    self.validationError = true
                    self.errorDesc = Text("Other gender can't be empty")
                    print("Other gender can't be empty")
                }
            } else {
                // Store the customGender in the firebase
                print(selected_Gender)
                profileModel.userProfile.genderIdentity = selected_Gender
                isGenderSet = true
            }
        }
        else {
            self.validationError = true
            self.errorDesc = Text("Please select genders")
            print("Please select genders")
        }
    }
    
    var body: some View {
        
        VStack(alignment:.leading) {

            ForEach(genders, id: \.self) { gender in
                Button{
                    self.selectedGender = gender
                } label : {
                    ZStack{
                        Rectangle()
                            .cornerRadius(5.0)
                            .frame(height:45)
                            .foregroundColor(.white)
                            .overlay(RoundedRectangle(cornerRadius: 5)
                                        .stroke(Color.pink, lineWidth: 1))
                        
                        HStack {
                            Text(gender)
                                .foregroundColor(.black)
                                .font(.BoardingSubHeading)
                                .padding(.horizontal,10)
                            
                            Spacer()
                            
                            if gender == self.selectedGender {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.accentColor)
                                    .padding(.horizontal,10)
                            }
                            
                        }
                        
                    }
                }
            }
        
            // Show this view if user chooses other
            if selectedGender == "other" {
                ZStack{
                    Rectangle()
                        .cornerRadius(5.0)
                        .frame(height:45)
                        .foregroundColor(.white)
                        .overlay(RoundedRectangle(cornerRadius: 5)
                                    .stroke(Color.pink, lineWidth: 1))
                    
                    TextField("Please fill in your gender", text: $customGender)
                        .padding()
                }.padding(.horizontal,25)
            }
            
            Spacer()
            
            NavigationLink(destination: SexualOrientation()
                            .environmentObject(profileModel),
                           isActive: $isGenderSet,
                           label: {
                Button{
                    addInputToProfile()
                } label : {
                    ZStack{
                        Rectangle()
                            .frame(height:45)
                            .cornerRadius(5.0)
                            .foregroundColor(.pink)
                        
                        Text("Continue")
                            .foregroundColor(.white)
                            .bold()
                            .font(.BoardingButton)
                    }
                }
                .padding(.bottom, 10)
            })
            
        }
        .alert(isPresented: self.$validationError) {
            Alert(title: Text(""), message: self.errorDesc, dismissButton: .default(Text("OK")))
        }
        .padding(40)
        .navigationBarTitle("I am a")
    }
}

struct IAmA_Previews: PreviewProvider {
    static var previews: some View {
        IAmA()
            .environmentObject(ProfileViewModel())
    }
}
