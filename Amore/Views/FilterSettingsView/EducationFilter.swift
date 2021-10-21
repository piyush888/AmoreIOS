//
//  GenderSettings.swift
//  Amore
//
//  Created by Kshitiz Sharma on 10/19/21.
//

import SwiftUI

struct EducationFilter: View {
    
    @Binding var educationPreference: String
    
    var body: some View {
        
            NavigationLink(
              destination: ShowEducationClasses(educationPreference:$educationPreference),
              label: {
                  ZStack{
                  CommonContainer()
                  HStack {
                      
                      Text("Education")
                          .font(.subheadline)
                          .foregroundColor(Color.black)
                      
                      Spacer()
                      
                      Text("\(self.educationPreference)")
                  }
                  .padding(.horizontal,20)
              }
          })
        
    }
}


struct ShowEducationClasses : View {
    
    @Binding var educationPreference: String
    
    var body: some View {
        
        VStack {
                
            Text("Education")
                .font(.title)
            
            ForEach(["Any", "Doctorate", "Masters", "Bachelors", "Associates", "Trade School", "High School", "No Education"], id: \.self) { gender in
                Button{
                    educationPreference = gender
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
                            
                            if gender == educationPreference {
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

struct EducationFilter_Previews: PreviewProvider {
    static var previews: some View {
        EducationFilter(educationPreference:Binding.constant("Masters"))
    }
}
