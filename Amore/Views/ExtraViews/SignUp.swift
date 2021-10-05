//
//  SignUp.swift
//  Amore
//
//  Created by Kshitiz Sharma on 9/23/21.
//

import SwiftUI

struct SignUp: View {
    var body: some View {
        
        VStack{
                
            Spacer()
            // Heart
            Image(systemName:"heart.circle.fill")
                .resizable()
                .frame(width: 90, height: 90)
                .foregroundColor(.pink)
                .shadow(color: Color("onboarding-pink"),
                        radius: 1, x: 3, y: 3)
                .padding(.bottom, 50)
            
            // Text Info
            Text("Sign up with phone number")
                .bold()
                .padding(.bottom, 35)
            
            // Redirect to SignUp With Phone Number
            Button{
                // TODO
            } label : {
                ZStack{
                    Rectangle()
                        .frame(height:45)
                        .cornerRadius(5.0)
                        .foregroundColor(.pink)
                        .padding(.horizontal,70)
                    
                    Text("Sign Up with your phone number")
                        .foregroundColor(.white)
                        .bold()
                        .font(.BoardingButton)
                }
            }.padding(.bottom, 10)
            
            
            // Provide User To LogIn, If they already have an account
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
                        .padding(.horizontal,70)
                        
                    Text("Sign In")
                        .foregroundColor(.pink)
                        .bold()
                        .font(.BoardingButton)
                }
            }
            
            Spacer()
            
            let adaptivecolumns = Array(repeating:
                                            GridItem(.adaptive(minimum: 200),
                                             spacing: 10,
                                             alignment: .center),
                                count: 2)
            LazyVGrid(columns: adaptivecolumns, content: {
                    Text("Terms of use")
                        .foregroundColor(.pink)
                        .font(.BoardingSubHeading)
                    Text("Privacy Policy")
                        .foregroundColor(.pink)
                        .font(.BoardingSubHeading)
            }).padding(.bottom, 40)
            
        }
        
    }
}

struct SignUp_Previews: PreviewProvider {
    static var previews: some View {
        SignUp()
    }
}
