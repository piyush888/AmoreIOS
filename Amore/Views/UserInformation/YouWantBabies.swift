//
//  YouWantBabies.swift
//  Amore
//
//  Created by Kshitiz Sharma on 11/15/21.
//

import SwiftUI

struct YouWantBabies: View {
    
    let babiesOptions = ["Yes", "Maybe Someday","Never"]
    @State var babiesSelection: String? = nil
    
    
    var body: some View {
        
        LinearGradient(gradient: Gradient(colors: [Color.red, Color.purple]),
                       startPoint: .top,
                       endPoint: .bottom)
            .edgesIgnoringSafeArea(.vertical)
            .overlay(
                
                VStack {
                    
                    Spacer()
                    
                    Text("Do you ever want kids?")
                        .font(.title)
                        
                    Spacer()
                    
                    ForEach(babiesOptions, id: \.self) { baby in
                        Button{
                            babiesSelection = baby
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
                                    Text(baby)
                                        .font(.headline)
                                        .foregroundColor(baby == babiesSelection ? .accentColor: .white)
                                    
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

struct YouWantBabies_Previews: PreviewProvider {
    static var previews: some View {
        YouWantBabies()
    }
}
