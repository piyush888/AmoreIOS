//
//  ShowMe.swift
//  Amore
//
//  Created by Kshitiz Sharma on 9/29/21.
//

import SwiftUI

struct ShowMe: View {
    
    @ObservedObject var profileModel: ProfileViewModel
    let showMeList = ["Women", "Men", "Everyone"]
    @State var userChoice: String? = nil
    @State var inputTaken: Bool = false
    
    func checkInputTaken () {
        if let userChoice = userChoice {
            profileModel.userProfile?.showMePreference = userChoice
            inputTaken = true
        }
        else {
            inputTaken = false
        }
    }
    
    
    var body: some View {
        
        
        VStack(alignment:.leading) {
//            HStack {
//                Text("Show Me")
//                    .font(.BoardingTitle)
//                    .padding(.bottom, 10)
//                Spacer()
//            }
            
            List {
                ForEach(showMeList, id: \.self) { item in
                    SelectionCellShowMe(
                        gender: item,
                        userChoice: self.$userChoice)
                }
                //.listRowSeparator(.hidden) - Uncomment for iOS 15
            }.frame(height:180)
            
            Spacer()
            
            // Continue to next view
            NavigationLink(destination: AddWork(profileModel: profileModel),
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


struct SelectionCellShowMe: View {
    
    let gender: String
    @Binding var userChoice: String?
    
    var body: some View {
        
        Button{
            // TODO
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
                        .foregroundColor(.pink)
                        .bold()
                        .font(.BoardingButton)
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
        .onTapGesture {
            self.userChoice = self.gender
        }
    }
}


struct ShowMe_Previews: PreviewProvider {
    static var previews: some View {
        ShowMe(profileModel: ProfileViewModel())
    }
}