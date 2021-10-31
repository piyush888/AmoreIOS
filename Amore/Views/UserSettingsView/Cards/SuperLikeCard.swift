//
//  SuperLikeCard.swift
//  Amore
//
//  Created by Kshitiz Sharma on 10/30/21.
//

import SwiftUI

struct SuperLikeCard: View {
     
     @Binding var showModal: Bool
     
     var body: some View {
         
         ZStack{
             Rectangle()
                 .fill(LinearGradient(
                     gradient: Gradient(colors: [Color.purple, Color.blue, Color.white]),
                     startPoint: .top,
                     endPoint: .bottom)
                 )
                 .frame(width: UIScreen.main.bounds.width-50, height: 500)
                 .cornerRadius(20)
                 
                 
             VStack(alignment:.center) {
                
                 Spacer()
                 
                 Group {
                 
                     Image(systemName: "star.circle")
                         .resizable()
                         .frame(width:50, height:50)
                         .foregroundColor(Color("gold-star"))
                     
                     Text("Stand out with Super Like")
                         .font(.title2)
                         .foregroundColor(Color.white)
                     
                     Text("You're 3x likely to get a match!!")
                         .font(.headline)
                         .foregroundColor(Color.white)
                 }
                 
                 Spacer()
                 
                 HStack {
                     
                     VStack {
                         Text("5")
                             .font(.title)
                         Text("Super Likes")
                             .font(.subheadline)
                         Divider()
                         Text("Inr 30/ea")
                             .bold()
                     }
                     
                     Divider()
                     
                     VStack {
                         Text("25")
                             .font(.title)
                         Text("Super Likes")
                             .font(.subheadline)
                         Divider()
                         Text("Inr 20/ea")
                             .bold()
                     }
                     
                     Divider()
                     
                     VStack {
                         Text("60")
                             .font(.title)
                         Text("Super Likes")
                             .font(.subheadline)
                         Divider()
                         Text("Inr 17/ea")
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
                             Text("Get Super Likes")
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
                             
                             Text("Get 5 Super Likes every day")
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
