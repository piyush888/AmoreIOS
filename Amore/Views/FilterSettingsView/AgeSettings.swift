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
    
    @State private var showingAlert = false
    @State private var tempMinAgeFilter: Int = 18
    @State private var tempMaxAgeFilter: Int = 60
    @State private var minAgeBoundary: Int = 18
    @State private var maxAgeBoundary: Int = 61
    
    var body: some View {
        
        GeometryReader { geometry in
            
            VStack {
                
                HStack {
                    
                    Spacer()
                    
                    AgePicker(agePickerTitle:"Min Age",
                              selectionFilter: $tempMinAgeFilter,
                              startForLoop: $minAgeBoundary,
                              endForLoop: $maxAgeBoundary,
                              geometry: geometry)
                              .onChange(of: self.tempMinAgeFilter) { _ in
                                  if self.tempMinAgeFilter < self.tempMaxAgeFilter {
                                      self.minAgeFilter =  self.tempMinAgeFilter
                                  } else {
                                      self.showingAlert = true
                                      self.tempMinAgeFilter = self.minAgeFilter
                                  }
                              }
                        
                    AgePicker(agePickerTitle:"Max Age",
                              selectionFilter: $tempMaxAgeFilter,
                              startForLoop: $minAgeBoundary,
                              endForLoop: $maxAgeBoundary,
                              geometry: geometry)
                              .onChange(of: self.tempMaxAgeFilter) { _ in
                                  if self.tempMinAgeFilter < self.tempMaxAgeFilter {
                                      self.maxAgeFilter = self.tempMaxAgeFilter
                                  } else {
                                      self.showingAlert = true
                                      self.tempMaxAgeFilter = self.maxAgeFilter
                                  }
                              }
                    
                    Spacer()
                    
                    }
                .padding(.top,5)
                
                Spacer()
            }
            .onAppear {
                self.tempMinAgeFilter = minAgeFilter
                self.tempMaxAgeFilter = maxAgeFilter
            }
        }
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("Incorrect range"),
                  message: Text("Min age should be less than max age."),
                  dismissButton: .default(Text("OK"))
            )
        }
            
    }
}

struct AgePicker : View {
        
    @State var agePickerTitle: String
    @Binding var selectionFilter: Int
    @Binding var startForLoop: Int
    @Binding var endForLoop: Int
    @State var geometry: GeometryProxy
    @State var unit = 0
    
    var body : some View {
        
        VStack {
            
            Text(self.agePickerTitle)
                .foregroundColor(Color.gray)
            
            Text("\(self.selectionFilter)")
                .foregroundColor(Color.gray)
            
            Picker(self.agePickerTitle, selection: $selectionFilter) {
                ForEach(self.startForLoop ..< self.endForLoop) { age in
                    Text("\(age)")
                        .tag(age)
                }
            }
            .pickerStyle(WheelPickerStyle())
            .frame(width: geometry.size.width/3)
            .clipped()
            .compositingGroup()
        
        }
        
    }
    
}

struct AgeSettings_Previews: PreviewProvider {
    static var previews: some View {
        AgeSettings(minAgeFilter: Binding.constant(30),
                     maxAgeFilter: Binding.constant(40))
    }
}
