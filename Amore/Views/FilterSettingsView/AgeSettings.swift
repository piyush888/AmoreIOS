//
//  AgeSettings2.swift
//  Amore
//
//  Created by Kshitiz Sharma on 12/22/21.
//

import SwiftUI


struct AgeSettings: View {
    
    @Binding var minAgeFilter: Int
    @Binding var maxAgeFilter: Int
    
    var body: some View {
        
            NavigationLink(
              destination: ShowAge(minAgeFilter:$minAgeFilter,
                                   maxAgeFilter:$maxAgeFilter),
              label: {
                  ZStack{
                      CommonContainer()
                      HStack {
                          
                          Text("Select age filters")
                              .font(.subheadline)
                              .foregroundColor(Color.black)
                          
                          Spacer()
                          
                          Text("\(self.minAgeFilter) - \(self.maxAgeFilter)")
                      }
                      .padding(.horizontal,20)
                  }
                  .navigationBarHidden(true)
              })
        }
}


struct ShowAge: View {
    
    @Binding var minAgeFilter: Int
    @Binding var maxAgeFilter: Int
    
    @State private var minAgeBoundary: Int = 18
    @State private var maxAgeBoundary: Int = 60
    
    var body: some View {
        
        GeometryReader { geometry in
            
            VStack {
                
                Spacer()
                
                HStack {
                    
                    Spacer()
                    
                    VStack {
                    
                        Text("Min Age")
                            .foregroundColor(Color.gray)
                        
                        Picker("Min Age", selection: $minAgeFilter) {
                            ForEach(self.minAgeBoundary ..< self.maxAgeBoundary) { age in
                                Text("\(age)")
                                    .tag(age)
                            }
                        }
                        .pickerStyle(WheelPickerStyle())
                        .frame(width: geometry.size.width/3)
                        .clipped()
                        .compositingGroup()
                    }
                    
                    VStack {
                    
                        Text("Max Age")
                            .foregroundColor(Color.gray)
                        
                        Picker("Max Age", selection: $maxAgeFilter) {
                            ForEach(self.minAgeBoundary+1 ..< self.maxAgeBoundary+1) { age in
                                Text("\(age)")
                                    .tag(age)
                            }
                        }
                        .pickerStyle(WheelPickerStyle())
                        .frame(width: geometry.size.width/3)
                        .clipped()
                        .compositingGroup()
                    }
                    
                    
                    Spacer()
                    
                }
            
                Spacer()
            }
        }
        
    }
}

struct AgeSettings_Previews: PreviewProvider {
    static var previews: some View {
        AgeSettings(minAgeFilter: Binding.constant(30),
                     maxAgeFilter: Binding.constant(40))
    }
}
