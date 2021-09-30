//
//  IAmA.swift
//  Amore
//
//  Created by Kshitiz Sharma on 9/25/21.
//

import SwiftUI

struct IAmA: View {
    
    let genders = ["male", "female", "other"]
    @State var selectedGender: String? = nil
    @State var customGender: String = ""
    
    @State private var validationError = false
    @State private var errorDesc = Text("")
    
    var body: some View {
        
        VStack(alignment:.leading) {
            HStack {
                Text("I am a")
                    .font(.BoardingTitle)
                    .padding(.bottom, 10)
                Spacer()
            }
            
            List {
                ForEach(genders, id: \.self) { item in
                    SelectionCell(
                        gender: item,
                        selectedGender: self.$selectedGender)
                }
                //.listRowSeparator(.hidden) - Uncomment for iOS 15
            }.frame(height:180)
            
            // Show this view if user chooses other
            if selectedGender == "other" {
                ZStack{
                    Rectangle()
                        .cornerRadius(5.0)
                        .frame(height:45)
                        .foregroundColor(.white)
                        .overlay(RoundedRectangle(cornerRadius: 5)
                                    .stroke(Color.pink, lineWidth: 1))
                    
                    TextField("Please fill in your gender", text: $customGender)
                        .padding()
                }.padding(.horizontal,25)
            }
            
            Spacer()
            
            Button{
                // Store the gender in the firebase
                if selectedGender != nil {
                    if selectedGender == "other" {
                        if customGender != "" {
                            // Store the customGender in the firebase
                            print(customGender)
                        } else {
                            self.validationError = true
                            self.errorDesc = Text("Other gender can't be empty")
                            print("Other gender can't be empty")
                        }
                    } else {
                        // Store the customGender in the firebase
                        print(selectedGender!)
                    }
                } else {
                    self.validationError = true
                    self.errorDesc = Text("Please select genders")
                    print("Please select genders")
                }
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
            }
            .padding(.bottom, 10)
            
        }
        .alert(isPresented: self.$validationError) {
            Alert(title: Text(""), message: self.errorDesc, dismissButton: .default(Text("OK")))
        }
        .padding(20)
    }
}

struct SelectionCell: View {
    
    let gender: String
    @Binding var selectedGender: String?
    
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
                    
                    if gender == selectedGender {
                        Image(systemName: "checkmark")
                            .foregroundColor(.accentColor)
                            .padding(.horizontal,10)
                    }
                    
                }
                
            }
        }
        .onTapGesture {
            self.selectedGender = self.gender
        }
    }
}

struct IAmA_Previews: PreviewProvider {
    static var previews: some View {
        IAmA()
    }
}