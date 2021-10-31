//
//  MessageCard.swift
//  Amore
//
//  Created by Kshitiz Sharma on 10/30/21.
//

import SwiftUI

struct MessageCard: View {
    
    @Binding var showModal: Bool
    
    var body: some View {
        
        ZStack{
            Rectangle()
                .fill(LinearGradient(
                    gradient: Gradient(colors: [Color.white, Color.pink, Color.red]),
                    startPoint: .top,
                    endPoint: .bottom)
                )
                .frame(width: UIScreen.main.bounds.width-50, height: 500)
                .cornerRadius(20)
                
                
            VStack(alignment:.center) {
               
                Spacer()
                
                Group {
                
                    Image(systemName: "message.circle.fill")
                        .resizable()
                        .frame(width:50, height:50)
                        .foregroundColor(.pink)
                    
                    Text("Be in her DM")
                        .font(.title2)
                        .foregroundColor(Color.white)
                    
                    Text("Get noticed, say something nice to him/her")
                        .font(.headline)
                        .foregroundColor(Color.white)
                }
                
                Spacer()
                
                HStack {
                    
                    VStack {
                        Text("1")
                            .font(.title)
                        Text("Messages")
                            .font(.subheadline)
                        Divider()
                        Text("Inr 15/ea")
                            .bold()
                    }
                    
                    Divider()
                    
                    VStack {
                        Text("5")
                            .font(.title)
                        Text("Messages")
                            .font(.subheadline)
                        Divider()
                        Text("Inr 12/ea")
                            .bold()
                    }
                    
                    Divider()
                    
                    VStack {
                        Text("10")
                            .font(.title)
                        Text("Messages")
                            .font(.subheadline)
                        Divider()
                        Text("Inr 10/ea")
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
                                gradient: Gradient(colors: [Color.orange]),
                                startPoint: .leading,
                                endPoint: .trailing)
                            )
                            .frame(width:UIScreen.main.bounds.width - 150, height:50)
                        
                        VStack {
                            Text("Buy Messages")
                                .foregroundColor(Color.white)
                                .font(.headline)
                        }
                    }
                    .padding(.top,15)
                    
                    Spacer()
                    
                    Text("Or")
                        .font(.headline)
                        .foregroundColor(Color.white)
                    
                    Spacer()
                    
                    ZStack{
                        Capsule()
                            .fill(LinearGradient(
                               gradient: Gradient(colors: [Color.yellow, Color.red]),
                                startPoint: .leading,
                                endPoint: .trailing)
                            )
                            .frame(width:UIScreen.main.bounds.width - 150, height:50)
                        
                        VStack {
                            Text("Amore Gold")
                                .foregroundColor(Color.white)
                                .font(.headline)
                            
                            Text("Get 2 boosts every month")
                                .foregroundColor(Color.white)
                                .font(.caption)
                        }
                    }
                    
                Text("No thanks")
                        .foregroundColor(.white)
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

