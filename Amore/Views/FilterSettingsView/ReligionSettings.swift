//
//  ReligionFilter.swift
//  Amore
//
//  Created by Kshitiz Sharma on 10/21/21.
//

import SwiftUI

struct ReligionFilter: View {
    
    @Binding var religionPreference: [String]
    @State var displayReligionInTab : String = ""
    
    var body: some View {
        
        NavigationLink(
            destination: ReligionOptions(religionPreference:$religionPreference,
                                         displayReligionInTab: $displayReligionInTab),
            label: {
                ZStack{
                    CommonContainer()
                    HStack {
                        
                        Text("Religion")
                            .font(.subheadline)
                            .foregroundColor(Color.black)
                        
                        Spacer()
                        
                        Text("\(self.displayReligionInTab)")
                    }
                    .padding(.horizontal,20)
                }
            })
    }
}

struct ReligionOptions : View {
    
    var religionsList = ["Any","Sikh","Hindu","Islam","Jain","Christian","Buddhist","Spiritual","Other","No Religion"]
    @Binding var religionPreference: [String]
    @Binding var displayReligionInTab: String
    
    func updateDisplayReligionInFilter () {
        if(self.religionPreference.count >= 2) {
            self.displayReligionInTab = self.religionPreference[0...1].joined(separator: ", ")
        } else if(self.religionPreference.count == 1) {
            self.displayReligionInTab = self.religionPreference[0]
        } else {
            self.religionPreference = ["Any"]
        }
    }
    
    var body: some View {
        
        VStack {
            
            Text("Religion")
                .font(.title)
            
            ForEach(religionsList, id: \.self) { religion in
                
                Button(action: {
                    // Add/Remove to passionSelected
                    if self.religionPreference.contains("\(religion)") {
                        // Remove if button clicked again
                        if let index = self.religionPreference.firstIndex(of: religion) {
                            self.religionPreference.remove(at: index)
                        }
                    } else {
                        // Add if passion doesn't exist in list
                        self.religionPreference.append(religion)
                    }
                    updateDisplayReligionInFilter()
                }) {
                    
                    ZStack{
                        Rectangle()
                            .cornerRadius(5.0)
                            .frame(height:45)
                            .foregroundColor(.white)
                            .overlay(RoundedRectangle(cornerRadius: 5)
                                        .stroke(Color.pink, lineWidth: 1))
                        
                        HStack {
                            Text(religion)
                                .foregroundColor(.black)
                                .font(.BoardingSubHeading)
                                .padding(.horizontal,10)
                            
                            Spacer()
                            
                            if self.religionPreference.contains("\(religion)") {
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

