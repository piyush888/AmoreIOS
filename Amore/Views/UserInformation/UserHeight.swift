//
//  UserHeight.swift
//  Amore
//
//  Created by Kshitiz Sharma on 11/15/21.
//

import SwiftUI

struct UserHeight: View {
    
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
                   in: 4...7,
                   step: 0.1
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
                
            Text(String(format: "%.1f",userHeight) + " feet")
            
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


 
