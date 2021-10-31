//
//  PlatinumCard.swift
//  Amore
//
//  Created by Kshitiz Sharma on 10/30/21.
//

import SwiftUI

struct PlatinumCard: View {
    
    @Binding var showModal: Bool

    var body: some View {
        
        ZStack{
            Rectangle()
                .fill(LinearGradient(
                    gradient: Gradient(colors: [Color.black,Color.white]),
                    startPoint: .top,
                    endPoint: .bottom)
                )
                .frame(width: UIScreen.main.bounds.width-50, height: 500)
                .cornerRadius(20)
                
                
            VStack(alignment:.center) {
               
                Spacer()
                
                Group {
                
                    Image(systemName: "bolt.heart.fill")
                        .resizable()
                        .frame(width:60, height:60)
                        .foregroundColor(Color.white)
                    
                    Text("Tinder Platinum")
                        .font(.title2)
                        .foregroundColor(Color.white)
                    
                    Group {
                        Text("Top Picks")
                        Text("Unlimited Likes")
                        Text("5 super likes everyday")
                        Text("5 boost a month")
                        Text("4 messages every week")
                    }
                    .font(.subheadline)
                    .foregroundColor(Color.white)
                    
                }
                
                Spacer()
                
                HStack {
                    
                    VStack {
                        Text("1")
                            .font(.title)
                        Text("Month")
                            .font(.subheadline)
                        Divider()
                        Text("Inr 450")
                            .bold()
                    }
                    
                    Divider()
                    
                    VStack {
                        Text("3")
                            .font(.title)
                        Text("Months")
                            .font(.subheadline)
                        Divider()
                        Text("Inr 1050")
                            .bold()
                    }
                    
                    Divider()
                    
                    VStack {
                        Text("6")
                            .font(.title)
                        Text("Months")
                            .font(.subheadline)
                        Divider()
                        Text("Inr 2300")
                            .bold()
                    }
                }
                .padding(.top,10)
                .foregroundColor(Color.white)
                
                Spacer()
                
                Group {
                    ZStack{
                        Capsule()
                            .fill(LinearGradient(
                                gradient: Gradient(colors: [Color.green, Color.purple]),
                                startPoint: .leading,
                                endPoint: .trailing)
                            )
                            .frame(width:UIScreen.main.bounds.width - 150, height:50)
                        
                        VStack {
                            Text("Buy Amore Platinum")
                                .foregroundColor(Color.white)
                                .font(.headline)
                        }
                    }
                    .padding(.top,15)
                    
                    Spacer()
                    
                    
                    Spacer()
                    
                    
                Text("No thanks")
                        .foregroundColor(Color.black)
                    .onTapGesture {
                        showModal.toggle()
                    }
                    .padding(.top,10)
                }
                
                
            }
            .padding(10)
            .cornerRadius(12)
            .clipped()
            .frame(width: UIScreen.main.bounds.width-50, height: 400)
        }
}
}

struct PlatinumCard_Previews: PreviewProvider {
    static var previews: some View {
        PlatinumCard(showModal:Binding.constant(false))
    }
}
