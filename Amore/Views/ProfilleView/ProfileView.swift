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
    
    @State var lastName: String = ""
    @State var firstName: String = ""
    @State var birthDate = Date()
    
    var body: some View {
        
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
            
            // Last Name
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
            
            Button{
                // TODO
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
        .padding(40)
        
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
