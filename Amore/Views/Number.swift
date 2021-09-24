//
//  Number.swift
//  Amore
//
//  Created by Kshitiz Sharma on 9/24/21.
//

import iPhoneNumberField
import PhoneNumberKit
import SwiftUI


struct Number: View {
    
    var viewType: String
    
    @State var phoneNumber = String()
    let phoneNumberKit = PhoneNumberKit()
    @State private var validationError = false
    @State private var errorDesc = Text("")
    
    var body: some View {
        
        VStack(alignment:.leading) {
            Text(viewType)
                .font(.BoardingTitle)
                .padding(.bottom,20)
            
            Text("Please enter your valid phone number. We will send you a 4-digit code to verify your account")
                .font(.BoardingSubHeading)
                .padding(.bottom,40)
            
            
            VStack{
                iPhoneNumberField(text: $phoneNumber)
                    .flagHidden(false)
                    .flagSelectable(true)
                    .font(UIFont(size: 20, design: .rounded))
                    .padding()
                    .overlay(RoundedRectangle(cornerRadius: 5)
                                .stroke(Color.pink, lineWidth: 1))
                
                Button(action: {
                    do {
                        _ = try self.phoneNumberKit.parse(self.phoneNumber)
                        print(self.phoneNumber)
                        // Integrate with firebase signup/login system here when no error occurs
                        
                    } catch {
                        self.validationError = true
                        self.errorDesc = Text("Please enter a valid phone number")
                    }
                }) {
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
                .padding(.top, 80)
            }
            .alert(isPresented: self.$validationError) {
                Alert(title: Text(""), message: self.errorDesc, dismissButton: .default(Text("OK")))
            }
            
        }.padding(.horizontal,40)
    }
}


struct Number_Previews: PreviewProvider {
    static var previews: some View {
        Number(viewType:"Sign Up")
    }
}
