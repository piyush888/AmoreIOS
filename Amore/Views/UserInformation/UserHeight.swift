//
//  UserHeight.swift
//  Amore
//
//  Created by Kshitiz Sharma on 11/15/21.
//

import SwiftUI
import Firebase

struct UserHeight: View {
    @EnvironmentObject var profileModel: ProfileViewModel
    @Binding var userHeight: Double
    @Binding var moreInfoView: MoreInformation
    @Binding var progressStatus: Double
    
    @State private var isEditing = false

    var body: some View {
        
        VStack {
            
            Spacer()
            
            Text("What's ur height?")
                .font(.title)
            
            Spacer()
            
            Slider(
                   value: $userHeight,
                   // In cm convert to feet for display
                   // 4 ft = 121.92
                   // 7 ft = 213.36
                   in: 121.92...213.36,
                   // 1 inch = 2.54 cm
                   // 1 feet = 30.48 cm
                   step: 2.54
               ) {
                   Text("Speed")
                       .font(.title)
               } minimumValueLabel: {
                   Text("4 ft")
               } maximumValueLabel: {
                   Text("7 ft")
               } onEditingChanged: { editing in
                   isEditing = editing
               }
               .padding(.horizontal,50)
                
            Text(String(format: "%.1f",userHeight/30.48) + " feet")
            
            Spacer()
            
            // Continue to move to next view
            Button{
                moreInfoView = .doYouWorkOutView
                progressStatus = 33.33
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
        .foregroundColor(.white)
                
        
    }
}


 
