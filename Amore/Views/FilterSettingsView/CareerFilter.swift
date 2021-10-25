//
//  CommunityFilter.swift
//  Amore
//
//  Created by Piyush Garg on 21/10/21.
//

import SwiftUI

struct CareerFilter: View {
    
    @Binding var careerPreference: [String]
    @State var displayCareerInTab : String = "Modify career"
    
    var body: some View {
        NavigationLink(
            destination: CareerOptions(careerPreference:$careerPreference,
                                         displayCareerInTab: $displayCareerInTab),
            label: {
                ZStack{
                    CommonContainer()
                    HStack {
                        
                        Text("Career")
                            .font(.subheadline)
                            .foregroundColor(Color.black)
                        
                        Spacer()
                        
                        Text("\(self.displayCareerInTab)")
                    }
                    .padding(.horizontal,20)
                }
            })
    }
}

struct CareerOptions : View {
    
    var religionsList = ["Any","Account Executive","Accountant","Actor","Aerospace Engineer","Agriculturist","Analyst","Anesthesiologist","Archeologist","Architect", "Artist", "Attorney", "Aviation Professional", "Banker"]
    @Binding var careerPreference: [String]
    @Binding var displayCareerInTab: String
    
    func updateDisplayReligionInFilter () {
        if(self.careerPreference.count >= 2) {
            self.displayCareerInTab = self.careerPreference[0...1].joined(separator: ", ")
        } else if(self.careerPreference.count == 1) {
            self.displayCareerInTab = self.careerPreference[0]
        } else {
            self.careerPreference = ["Any"]
        }
    }
    
    var body: some View {
        
        VStack {
            
            Text("Career")
                .font(.title)
            ScrollView {
                ForEach(religionsList, id: \.self) { religion in
                    
                    Button(action: {
                        // Add/Remove to passionSelected
                        if self.careerPreference.contains("\(religion)") {
                            // Remove if button clicked again
                            if let index = self.careerPreference.firstIndex(of: religion) {
                                self.careerPreference.remove(at: index)
                            }
                        } else {
                            // Add if passion doesn't exist in list
                            self.careerPreference.append(religion)
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
                                
                                if self.careerPreference.contains("\(religion)") {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(.accentColor)
                                        .padding(.horizontal,10)
                                }
                                
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

struct CareerFilter_Previews: PreviewProvider {
    static var previews: some View {
        CareerFilter(careerPreference: Binding.constant(["Analyst"]))
    }
}
