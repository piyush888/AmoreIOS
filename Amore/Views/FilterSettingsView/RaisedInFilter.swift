//
//  GenderSettings.swift
//  Amore
//
//  Created by Kshitiz Sharma on 10/19/21.
//

import SwiftUI

struct RaisedInFilter: View {
    
    @Binding var countryPreference: String
    
    var body: some View {
        
            NavigationLink(
              destination: ShowCountries(countryPreference:$countryPreference),
              label: {
                  ZStack{
                  CommonContainer()
                  HStack {
                      
                      Text("Raised In")
                          .font(.subheadline)
                          .foregroundColor(Color.black)
                      
                      Spacer()
                      
                      Text("\(self.countryPreference)")
                  }
                  .padding(.horizontal,20)
              }
          })
        
    }
}


struct ShowCountries : View {
    
    @Binding var countryPreference: String
    
    var body: some View {
        
        VStack {
                
            Text("Raised In")
                .font(.title)
            
            ForEach(["Any", "United States", "Canada", "United Kingdom", "Australia", "India", "United Arab Emirates", "Other"], id: \.self) { gender in
                Button{
                    countryPreference = gender
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
                            
                            if gender == countryPreference {
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

struct RaisedInFilter_Previews: PreviewProvider {
    static var previews: some View {
        RaisedInFilter(countryPreference:Binding.constant("India"))
    }
}
