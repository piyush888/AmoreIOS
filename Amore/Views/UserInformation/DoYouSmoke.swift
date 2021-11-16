//
//  DoYouSmoke.swift
//  Amore
//
//  Created by Kshitiz Sharma on 11/15/21.
//

import SwiftUI

struct DoYouSmoke: View {
    
    let smokingOption = ["Never", "Occasionally"]
    @State var smokingSelection: String? = nil
    
    var body: some View {
    
        LinearGradient(gradient: Gradient(colors: [Color.red, Color.purple]),
                       startPoint: .top,
                       endPoint: .bottom)
            .edgesIgnoringSafeArea(.vertical)
            .overlay(
                
                VStack {
                    
                    Spacer()
                    
                    Text("Do you drink?")
                        .font(.title)
                        
                    Spacer()
                    
                    ForEach(smokingOption, id: \.self) { smoke in
                        Button{
                            smokingSelection = smoke
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
                                    Text(smoke)
                                        .font(.headline)
                                        .foregroundColor(smoke == smokingSelection ? .accentColor: .white)
                                    
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

struct DoYouSmoke_Previews: PreviewProvider {
    static var previews: some View {
        DoYouSmoke()
    }
}
