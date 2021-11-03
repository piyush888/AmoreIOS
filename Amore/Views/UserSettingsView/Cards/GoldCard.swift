//
//  GoldCard.swift
//  Amore
//
//  Created by Kshitiz Sharma on 10/30/21.
//

import SwiftUI

struct GoldCard: View {
    
        @Binding var showModal: Bool
    
        var body: some View {
            
            ZStack{
                Rectangle()
                    .fill(LinearGradient(
                        gradient: Gradient(colors: [Color.orange,Color.orange, Color.yellow, Color.white]),
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
                            .foregroundColor(Color("gold-star"))
                        
                        Text("Amore Gold")
                            .font(.title2)
                            .foregroundColor(Color.white)
                        
                        Group {
                            Text("Unlimited Likes")
                            Text("5 super likes everyday")
                            Text("2 boost a month")
                            Text("2 messages every week")
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
                            Text("Inr 300")
                                .bold()
                        }
                        
                        Divider()
                        
                        VStack {
                            Text("3")
                                .font(.title)
                            Text("Months")
                                .font(.subheadline)
                            Divider()
                            Text("Inr 800")
                                .bold()
                        }
                        
                        Divider()
                        
                        VStack {
                            Text("6")
                                .font(.title)
                            Text("Months")
                                .font(.subheadline)
                            Divider()
                            Text("Inr 1500")
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
                                Text("Buy Amore Gold")
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
                                   gradient: Gradient(colors: [Color.green, Color.blue]),
                                    startPoint: .leading,
                                    endPoint: .trailing)
                                )
                                .frame(width:UIScreen.main.bounds.width - 150, height:50)
                            
                            VStack {
                                Text("Amore Platinum")
                                    .foregroundColor(Color.white)
                                    .font(.headline)
                                
                                Text("Top picks, super stars, boosts, messages")
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

struct GoldCard_Previews: PreviewProvider {
    static var previews: some View {
        GoldCard(showModal:Binding.constant(false))
    }
}
