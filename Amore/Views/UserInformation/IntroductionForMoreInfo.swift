//
//  IntroductionOption.swift
//  Amore
//
//  Created by Kshitiz Sharma on 11/17/21.
//

import SwiftUI

struct IntroductionOption: View {
    
    @Binding var moreInfoView: MoreInformation
    @Binding var progressStatus: Double
    @Binding var allcardsActiveSheet: AllCardsActiveSheet?
    
    
    var body: some View {
        
        VStack(alignment: .leading) {
            
            MoreInfoForBetterMatchChild(iconName:"speedometer",
                                        title: "Complete your profile",
                                        description: "Users with 100% profile completion have better matches",
                                        color:Color.yellow)
            
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
                moreInfoView = .userHeightView
                progressStatus = 16.67
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
                self.allcardsActiveSheet =  .none
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

