//
//  HighestEducation.swift
//  Amore
//
//  Created by Kshitiz Sharma on 11/15/21.
//

import SwiftUI

struct HighestEducation: View {
    
    let educationOptions = ["Doctor PhD", "Masters", "Professional Degree","Bachelors","High School"]
    @State var educationSelection: String? = nil
    
    
    var body: some View {
        
        LinearGradient(gradient: Gradient(colors: [Color.red, Color.purple]),
                       startPoint: .top,
                       endPoint: .bottom)
            .edgesIgnoringSafeArea(.vertical)
            .overlay(
                
                VStack {
                    
                    Spacer()
                    
                    Text("What's your highest education")
                        .font(.title)
                        
                    Spacer()
                    
                    ForEach(educationOptions, id: \.self) { education in
                        Button{
                            educationSelection = education
                        } label : {
                            
                            ZStack{
                                Capsule()
                                    .fill(LinearGradient(
                                        gradient: Gradient(colors: [Color.yellow, Color.red]),
                                        startPoint: .leading,
                                        endPoint: .trailing)
                                    )
                                    .frame(height:45)
                                
                                HStack {
                                    Text(education)
                                        .font(.headline)
                                        .foregroundColor(education == educationSelection ? .accentColor: .white)
                                    
                                }
                            }
                            .foregroundColor(.white)
                            
                        }
                        .padding(.horizontal,50)
                    }
                    
                    Spacer()
                    
                    // Continue to move to next view
                    Button{
                        // TODO
                    } label : {
                        ZStack{
                            Rectangle()
                                .frame(height:45)
                                .cornerRadius(5.0)
                                .foregroundColor(.pink)
                                .padding(.horizontal,70)
                            
                            Text("Continue")
                                .foregroundColor(.white)
                                .bold()
                                .font(.BoardingButton)
                        }
                    }
                    
                    Spacer()
                }
                .foregroundColor(.white)
                
            )
        
    }
}

struct HighestEducation_Previews: PreviewProvider {
    static var previews: some View {
        HighestEducation()
    }
}
