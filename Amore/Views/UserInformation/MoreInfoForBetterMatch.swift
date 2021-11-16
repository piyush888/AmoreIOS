//
//  MoreInfoForBetterMatch.swift
//  Amore
//
//  Created by Kshitiz Sharma on 11/15/21.
//

import SwiftUI

struct MoreInfoForBetterMatch: View {
    var body: some View {
        
        LinearGradient(gradient: Gradient(colors: [Color.red, Color.purple]),
                       startPoint: .top,
                       endPoint: .bottom)
            .edgesIgnoringSafeArea(.vertical)
            .overlay(
                VStack(alignment: .leading) {
                    
                    MoreInfoForBetterMatchChild(iconName:"heart.fill",
                                                title: "Complete your profile",
                                                description: "Users with 100% profile completion have better matches",
                                                color:Color.red)
                    
                    MoreInfoForBetterMatchChild(iconName:"message.fill",
                                                title: "Be in their DM",
                                                description: "Match faster with your future partner",
                                                color:Color.blue)
                    
                    MoreInfoForBetterMatchChild(iconName:"bonjour",
                                                title: "Be on top of deck",
                                                description: "Our matching algorithm priortizes verified & completed profiles",
                                                color:Color.green)
                
                   
                    // Let's get started with filling in user details
                    Button{
                        // TODO
                    } label : {
                        ZStack{
                            Rectangle()
                                .frame(height:45)
                                .cornerRadius(5.0)
                                .foregroundColor(.pink)
                                .padding(.horizontal,70)
                            
                            Text("Get me more matches")
                                .foregroundColor(.white)
                                .bold()
                                .font(.BoardingButton)
                        }
                    }
                    .padding(.top, 30)
                    .padding(.bottom, 10)
                    
                    
                    // Do it later
                    Button{
                        // TODO
                    } label : {
                        ZStack{
                            Rectangle()
                                .cornerRadius(5.0)
                                .frame(height:45)
                                .foregroundColor(.white)
                                .overlay(RoundedRectangle(cornerRadius: 5)
                                        .stroke(Color.pink, lineWidth: 1))
                                .padding(.horizontal,70)
                                
                            Text("Not feeling the vibe")
                                .foregroundColor(.pink)
                                .bold()
                                .font(.BoardingButton)
                        }
                    }
                }
                
            )
        
    }
}



struct MoreInfoForBetterMatchChild : View {
    
    @State var iconName : String
    @State var title: String
    @State var description: String
    @State var color: Color
    
    var body: some View {
        
        HStack(alignment: .center)  {
            HStack {
                Image(systemName: iconName)
                    .font(.system(size: 30))
                    .frame(width: 30)
                    .foregroundColor(color)
                    .padding()

                VStack(alignment: .leading) {
                    Text(title)
                        .font(.title2)
                        .bold()
                        .foregroundColor(Color.white)
                    
                    Text(description)
                        .fixedSize(horizontal: false, vertical: true)
                        .foregroundColor(Color.white)
                }
            }
            .padding()
        }
        
    }
}


struct MoreInfoForBetterMatch_Previews: PreviewProvider {
    static var previews: some View {
        MoreInfoForBetterMatch()
    }
}
