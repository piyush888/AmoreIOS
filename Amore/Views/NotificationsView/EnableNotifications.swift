//
//  EnableNotifications.swift
//  Amore
//
//  Created by Kshitiz Sharma on 10/2/21.
//

import SwiftUI

struct EnableNotifications: View {
    var body: some View {
        VStack {
            
            HStack {
                // For Horizontal spacing
                Spacer()
                
                Button {
                    // TO DO - skip
                } label :{
                    Text("Skip")
                        .foregroundColor(.pink)
                }
                
            }.padding(.horizontal,20)
            
            Spacer()
            
            Image(systemName: "captions.bubble.fill")
                .resizable()
                .frame(width:140, height:120)
                .foregroundColor(.pink)
                .padding(.bottom, 20)
            
            Text("Enable notification's")
                .font(.BoardingTitle)
                .padding(.bottom, 20)
            
            Text("Get push-notification when you get the match or receive a message")
                .font(.BoardingSubHeading)
                .padding(.horizontal,20)
                .multilineTextAlignment(.center)
                .padding(.bottom, 400)
            
            Spacer()
            
            Button{
                // TODO-
            } label : {
                ZStack{
                    Rectangle()
                        .frame(height:45)
                        .cornerRadius(5.0)
                        .foregroundColor(.pink)
                        
                    Text("I want to be notified")
                        .font(.BoardingButton)
                        .foregroundColor(.white)
                        .bold()
                }
            }.padding(.horizontal, 50)
            
            Spacer()
        }
        .padding(20)
    }
}

struct EnableNotifications_Previews: PreviewProvider {
    static var previews: some View {
        EnableNotifications()
    }
}
