//
//   BoostCard.swift
//  Amore
//
//  Created by Kshitiz Sharma on 10/30/21.
//

import SwiftUI

struct BoostCard: View {
    
    @Binding var showModal: Bool
    
    var body: some View {
        
        ZStack{
            Rectangle()
                .fill(LinearGradient(
                    gradient: Gradient(colors: [Color.yellow, Color.orange, Color.white]),
                    startPoint: .top,
                    endPoint: .bottom)
                )
                .frame(width: UIScreen.main.bounds.width-50, height: 500)
                .cornerRadius(20)
                
                
            VStack(alignment:.center) {
               
                Spacer()
                
                Group {
                
                    Image(systemName: "bolt.circle.fill")
                        .resizable()
                        .frame(width:50, height:50)
                        .foregroundColor(.blue)
                    
                    Text("Skip the queue")
                        .font(.title2)
                        .foregroundColor(Color.white)
                    
                    Text("Be on top of the deck for 30 minutes to get more matches")
                        .font(.headline)
                        .foregroundColor(Color.white)
                }
                
                Spacer()
                
                HStack {
                    
                    VStack {
                        Text("1")
                            .font(.title)
                        Text("Boosts")
                            .font(.subheadline)
                        Divider()
                        Text("Inr 10/ea")
                            .bold()
                    }
                    
                    Divider()
                    
                    VStack {
                        Text("5")
                            .font(.title)
                        Text("Boosts")
                            .font(.subheadline)
                        Divider()
                        Text("Inr 8/ea")
                            .bold()
                    }
                    
                    Divider()
                    
                    VStack {
                        Text("10")
                            .font(.title)
                        Text("Boosts")
                            .font(.subheadline)
                        Divider()
                        Text("Inr 5/ea")
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
                                gradient: Gradient(colors: [Color.purple, Color.blue]),
                                startPoint: .leading,
                                endPoint: .trailing)
                            )
                            .frame(width:UIScreen.main.bounds.width - 150, height:50)
                        
                        VStack {
                            Text("Boost me")
                                .foregroundColor(Color.white)
                                .font(.headline)
                        }
                    }
                    .padding(.top,15)
                    
                    Spacer()
                    
                    Text("Or")
                        .font(.headline)
                        .foregroundColor(Color.gray)
                    
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
                    .foregroundColor(Color.gray)
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

