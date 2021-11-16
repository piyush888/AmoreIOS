//
//  DoYouWorkOut.swift
//  Amore
//
//  Created by Kshitiz Sharma on 11/15/21.
//

import SwiftUI

struct DoYouWorkOut: View {
    
    let workoutOption = ["Everyday", "Sometimes", "Never"]
    @State var workoutSelection: String? = nil
    
    
    var body: some View {
        
        LinearGradient(gradient: Gradient(colors: [Color.red, Color.purple]),
                       startPoint: .top,
                       endPoint: .bottom)
            .edgesIgnoringSafeArea(.vertical)
            .overlay(
                
                VStack {
                    
                    Spacer()
                    
                    Text("Do you workout?")
                        .font(.title)
                        
                    Spacer()
                    
                    ForEach(workoutOption, id: \.self) { workout in
                        Button{
                            workoutSelection = workout
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
                                    Text(workout)
                                        .font(.headline)
                                        .foregroundColor(workout == workoutSelection ? .accentColor: .white)
                                    
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

struct DoYouWorkOut_Previews: PreviewProvider {
    static var previews: some View {
        DoYouWorkOut()
    }
}
