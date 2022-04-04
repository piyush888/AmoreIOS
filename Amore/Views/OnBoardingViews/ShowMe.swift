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
    
    let showMeList = ["Women", "Men", "Everyone"]
    @State var userChoice: String? = nil
    @State var inputTaken: Bool = false
    
    func checkInputTaken () {
        if let userChoice = userChoice {
            profileModel.userProfile.showMePreference = userChoice
            inputTaken = true
        }
        else {
            inputTaken = false
        }
    }
    
    
    var body: some View {
        
        
        VStack(alignment:.leading) {
            
                ForEach(showMeList, id: \.self)  { gender in
                    Button{
                        userChoice = gender
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
                                
                                if gender == userChoice {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(.accentColor)
                                        .padding(.horizontal,10)
                                }
                                
                            }
                            
                        }
                    }
                }
            
            Spacer()
            
            // Continue to next view
            NavigationLink(destination: AddWork()
                            .environmentObject(profileModel),
                           isActive: $inputTaken,
                           label: {
                Button{
                    checkInputTaken()
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
                }.padding(.bottom, 10)
            })
            
        }
        .padding(20)
        .navigationBarTitle("Show me")
    }
}


struct ShowMe_Previews: PreviewProvider {
    static var previews: some View {
        ShowMe()
            .environmentObject(ProfileViewModel())
    }
}
