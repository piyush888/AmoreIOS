//
//  GenderSettings.swift
//  Amore
//
//  Created by Kshitiz Sharma on 10/19/21.
//

import SwiftUI

struct GenderSettings: View {
    
    @Binding var genderPreference: String
    
    var body: some View {
        
            NavigationLink(
              destination: ShowGenders(genderPreference:$genderPreference),
              label: {
                  ZStack{
                      CommonContainer()
                      HStack {
                          
                          Text("Gender")
                              .font(.subheadline)
                              .foregroundColor(Color.black)
                          
                          Spacer()
                          
                          Text("\(self.genderPreference)")
                      }
                      .padding(.horizontal,20)
                  }
                  .navigationBarHidden(true)
              })
        }
}


struct ShowGenders : View {
    
    @Binding var genderPreference: String
    
    var body: some View {
        
        VStack {
                
            Text("Gender")
                .font(.title)
            
            ForEach(["Male", "Female", "All"], id: \.self) { gender in
                Button{
                    genderPreference = gender
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
                                .foregroundColor(.black)
                                .font(.BoardingSubHeading)
                                .padding(.horizontal,10)
                            
                            Spacer()
                            
                            if gender == genderPreference {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.accentColor)
                                    .padding(.horizontal,10)
                            }
                            
                        }
                        
                    }
                }
            }
            
            Spacer()
            
        }
        .padding(.horizontal,20)
    }
}

struct GenderSettings_Previews: PreviewProvider {
    static var previews: some View {
        GenderSettings(genderPreference:Binding.constant("Male"))
    }
}
