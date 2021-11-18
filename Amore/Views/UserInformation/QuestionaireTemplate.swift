//
//  QuestionaireTemplate.swift
//  Amore
//
//  Created by Kshitiz Sharma on 11/17/21.
//

import SwiftUI
import Firebase

struct QuestionaireTemplate: View {
    @EnvironmentObject var profileModel: ProfileViewModel
    @State var question: String
    @State var listOfOptions: [String]
    @Binding var userChoice: String?
    
    @Binding var moreInfoView: MoreInformation
    @State var moreInfoViewStatus: MoreInformation
    
    @Binding var progressStatus: Double
    
    @State private var showingAlert = false
    
    var body: some View {
        
        
        VStack {
            
            Spacer()
            
            Text(question)
                .font(.title)
                
            Spacer()
            
            ForEach(listOfOptions, id: \.self) { foreach in
                Button{
                    userChoice = foreach
                } label : {
                    
                    ZStack{
                        Capsule()
                            .fill(LinearGradient(
                                gradient: Gradient(colors: [Color.yellow, Color.red]),
                                startPoint: .leading,
                                endPoint: .trailing)
                            )
                            .frame(height:45)
                        
                        HStack {
                            Text(foreach)
                                .font(.headline)
                                .foregroundColor(userChoice == foreach ? .accentColor: .white)
                            
                        }
                    }
                    .foregroundColor(.white)
                    
                }
                .padding(.horizontal,50)
            }
            
            Spacer()
            
            // Continue to move to next view
            Button{
                
                guard let myString = userChoice, !myString.isEmpty else {
                    // User choice is nil, raise an error
                    showingAlert = true
                    return
                }
                profileModel.updateUserProfile(profileId: Auth.auth().currentUser?.uid)
                moreInfoView = moreInfoViewStatus
                progressStatus = progressStatus + 100.0/6.0
                
            } label : {
                ZStack{
                    Rectangle()
                        .frame(height:45)
                        .cornerRadius(5.0)
                        .foregroundColor(.pink)
                        .padding(.horizontal,70)
                    
                    Text("Continue")
                        .foregroundColor(.white)
                        .bold()
                        .font(.BoardingButton)
                }
            }
            
            Spacer()
        }
        .alert(isPresented: $showingAlert) {
               Alert(
                   title: Text(""),
                   message: Text("Please select an option")
               )
           }
        .foregroundColor(.white)
        
        
    }
}


