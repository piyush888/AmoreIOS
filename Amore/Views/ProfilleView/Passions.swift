//
//  Passions.swift
//  Amore
//
//  Created by Kshitiz Sharma on 9/28/21.
//

import SwiftUI

struct Passions: View {
    
    var passions = ["Photography", "Shopping", "Yoga","Cooking",
                    "Travelling","Cricket","Running","Swimming","Art","Extreme",
                    "Music","Drink","Gaming","Partying","Workout","Pets","Sports",
                    "Reading","Volunteering","Singing","Movies","Nature","Entrepreneurship",
                    "Programming"]
    
    @State var passionSelected = [String]()
    
    let adaptivecolumns = Array(repeating:
                                    GridItem(.adaptive(minimum: 150),
                                             spacing: 5,
                                             alignment: .center),count: 2)
    
    var body: some View {
        
        VStack(alignment:.leading) {
            
            HStack {
                Text("Choose 5 interest")
                    .font(.BoardingTitle)
                    .padding(.bottom, 10)
                Spacer()
            }
            
            Text("Select a few of your interests and let everyone know what you're passionate about")
                .font(.BoardingSubHeading)
                .padding(.bottom,40)
            
            // LazyVGrid
            ScrollView(showsIndicators:false) {
                
                LazyVGrid(columns: adaptivecolumns, content: {
                    
                    ForEach(passions, id: \.self) { item in
                        
                        let passionChoosen = passionSelected.contains("\(item)")
                        
                        Button(action: {
                            // Add/Remove to passionSelected
                            if passionSelected.contains("\(item)") {
                                // Remove if button clicked again
                                if let index = passionSelected.firstIndex(of: item) {
                                    passionSelected.remove(at: index)
                                }
                            } else if(passionSelected.count < 5) {
                                // Add if passion doesn't exist in list
                                passionSelected.append(item)
                            }
                            
                            print(passionSelected)
                            
                            // Load the passionSelected to firebase
                        }) {
                            ZStack {
                                Rectangle()
                                    .frame(height:45)
                                    .cornerRadius(5.0)
                                    .foregroundColor(passionChoosen == true ? .pink : .white)
                                    .overlay(RoundedRectangle(cornerRadius: 5)
                                            .stroke(Color.pink, lineWidth: 1))
                                    
                                
                                Text("\(item)")
                                    .foregroundColor(passionChoosen == true ? .white : .pink)
                                    .bold()
                                    .font(.BoardingSubHeading)
                            }
                        }
                    }
                })
            }.padding(.bottom,85)
            
            Spacer()
            
            // Continue to next view
            Button{
                // TODO
                // Save the passions to firebase
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
        .padding(20)
    }
}

struct Passions_Previews: PreviewProvider {
    static var previews: some View {
        Passions()
    }
}
