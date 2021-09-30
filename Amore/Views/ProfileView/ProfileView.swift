//
//  ProfileView.swift
//  Amore
//
//  Created by Kshitiz Sharma on 9/25/21.
//

import SwiftUI

struct ProfileView: View {
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }
//    @State var userProfile: Profile
    @State var lastName: String = ""
    @State var firstName: String = ""
    @State var userEmail: String = ""
    @State var birthDate: Date = Date()
    @State var allFieldsFilled: Bool = false
    @State var errorDesc: String?
    
    var isEmailValid: Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: userEmail)
    }
    
    func whitespaceTrimmer (str: String) -> String {
        return str.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    func checkallFieldsFilled () {
        firstName = whitespaceTrimmer(str: firstName)
        lastName = whitespaceTrimmer(str: lastName)
        userEmail = whitespaceTrimmer(str: userEmail)
        if lastName=="" || firstName=="" || userEmail=="" {
            allFieldsFilled = false
            errorDesc = "Please fill all the above details"
        }
        else if !isEmailValid {
            allFieldsFilled = false
            errorDesc = "Invalid Email"
        }
        else {
            errorDesc = nil
            allFieldsFilled = true
        }
    }
    
    var body: some View {
        
        NavigationView {
            VStack {
                
                Text("Let's create your profile")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.BoardingTitle)
                    .padding(.bottom, 50)
                
                Spacer()
                
                // Upload a pic
                VStack {
                    
                    Image(systemName: "person.crop.circle")
                        .resizable()
                        .frame(width: 100, height: 100)
                        .foregroundColor(.pink)
                    
                    // Provide User To LogIn, If they already have an account
                    Button{
                        // TODO
                    } label : {
                        ZStack{
                            Rectangle()
                                .cornerRadius(5.0)
                                .frame(height:30)
                                .foregroundColor(.white)
                                .overlay(RoundedRectangle(cornerRadius: 5)
                                            .stroke(Color.pink, lineWidth: 1))
                                .padding(.horizontal,90)
                            
                            Text("Upload a photo")
                                .foregroundColor(.pink)
                                .bold()
                                .font(.BoardingButton)
                        }
                    }
                }
                .padding(.bottom, 20)
                
                Spacer()
                
                // First Name
                ZStack{
                    Rectangle()
                        .cornerRadius(5.0)
                        .frame(height:45)
                        .foregroundColor(.white)
                        .overlay(RoundedRectangle(cornerRadius: 5)
                                    .stroke(Color.pink, lineWidth: 1))
                    
                    TextField("First name", text: $firstName)
                        .textContentType(.givenName)
                        .padding()
                }
                
                // Second Name
                ZStack{
                    Rectangle()
                        .cornerRadius(5.0)
                        .frame(height:45)
                        .foregroundColor(.white)
                        .overlay(RoundedRectangle(cornerRadius: 5)
                                    .stroke(Color.pink, lineWidth: 1))
                    
                    TextField("Last name", text: $lastName)
                        .textContentType(.familyName)
                        .padding()
                }
                
                // User Email
                ZStack{
                    Rectangle()
                        .cornerRadius(5.0)
                        .frame(height:45)
                        .foregroundColor(.white)
                        .overlay(RoundedRectangle(cornerRadius: 5)
                                    .stroke(Color.pink, lineWidth: 1))
                    
                    TextField("Email", text: $userEmail)
                        .textContentType(.emailAddress)
                        .padding()
                }
                
                // Birthday picker
                VStack {
                    ZStack{
                        Rectangle()
                            .cornerRadius(5.0)
                            .frame(height:45)
                            .foregroundColor(.white)
                            .overlay(RoundedRectangle(cornerRadius: 5)
                                        .stroke(Color.pink, lineWidth: 1))
                        
                        DatePicker(selection: $birthDate, in: ...Date(), displayedComponents: .date) {
                            
                            HStack {
                                Image(systemName:"calendar")
                                    .foregroundColor(.pink)
                                Text("Choose Birth Date")
                                    .foregroundColor(.secondary)
                            }
                            
                        }
                        .padding()
                    }
                    Spacer()
                    if errorDesc != nil {
                        Section {
                            Text(errorDesc!)
                        }
                    }
                }
                
                Spacer()
                
                NavigationLink(
                    destination: Passions(),
                    isActive: $allFieldsFilled,
                    label: {
                        Button{
                            // TODO
                            checkallFieldsFilled()
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
            .padding(40)
            .navigationBarHidden(true)
        }
        
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
