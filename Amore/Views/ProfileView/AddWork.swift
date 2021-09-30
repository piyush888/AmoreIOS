//
//  AddWork.swift
//  Amore
//
//  Created by Kshitiz Sharma on 9/29/21.
//

import SwiftUI

struct AddWork: View {
    
    @State var workName : String = ""
    
    var body: some View {
        
        VStack(alignment:.leading) {
            HStack {
                Text("I work at")
                    .font(.BoardingTitle)
                    .padding(.bottom, 10)
                Spacer()
            }
            .padding(.bottom,80)
            // School Name
            ZStack{
                Rectangle()
                    .cornerRadius(5.0)
                    .frame(height:45)
                    .foregroundColor(.white)
                    .overlay(RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.pink, lineWidth: 1))
                    
                TextField("Add Work", text: $workName)
                    .padding()
            }
            
            // Skip this information
            Button{
                // TODO
                // Save the Show me
                print("Skip this information")
            } label : {
                ZStack{
                    Rectangle()
                        .frame(height:45)
                        .cornerRadius(5.0)
                        .foregroundColor(.white)
                        
                    Text("Skip")
                        .foregroundColor(.gray)
                        .bold()
                        .font(.BoardingButton)
                }
            }.padding(.bottom, 10)
            
            Spacer()
            
            
            // Continue to next view
            Button{
                // TODO
                // Save the Show me
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
            
        }
        .padding(20)
        
    }
}

struct AddWork_Previews: PreviewProvider {
    static var previews: some View {
        AddWork()
    }
}
