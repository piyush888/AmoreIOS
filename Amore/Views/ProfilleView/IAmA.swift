//
//  IAmA.swift
//  Amore
//
//  Created by Kshitiz Sharma on 9/25/21.
//

import SwiftUI

struct IAmA: View {
    
    let fruit = ["male", "female", "other"]
    @State var selectedFruit: String? = nil
    
    var body: some View {
        
        VStack(alignment:.leading) {
            HStack {
                Text("I am a")
                    .font(.BoardingTitle)
                    .padding(.bottom, 10)
                Spacer()
            }
            
            List {
                ForEach(fruit, id: \.self) { item in
                    SelectionCell(
                         fruit: item,
                         selectedFruit: self.$selectedFruit)
                    }
                    //.listRowSeparator(.hidden) - Uncomment for iOS 15
            }
            
            
           
            Spacer()
            
            Button{
                // TODO
            } label : {
                ZStack{
                    Rectangle()
                        .frame(height:45)
                        .cornerRadius(5.0)
                        .foregroundColor(.pink)
                        
                    Text("Continue")
                        .foregroundColor(.white)
                        .bold()
                        .font(.BoardingButton)
                }
            }.padding(.bottom, 10)
            
        }
        .padding(20)
    }
}

struct SelectionCell: View {

    let fruit: String
    @Binding var selectedFruit: String?

    var body: some View {
        
            
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
                        
                    HStack {
                        Text(fruit)
                            .foregroundColor(.pink)
                            .bold()
                            .font(.BoardingButton)
                            .padding(.horizontal,10)
                        
                        Spacer()
                        
                        if fruit == selectedFruit {
                            Image(systemName: "checkmark")
                                .foregroundColor(.accentColor)
                                .padding(.horizontal,10)
                        }
                        
                    }
                    
                }
            }
            .onTapGesture {
                self.selectedFruit = self.fruit
            }
    }
}

struct IAmA_Previews: PreviewProvider {
    static var previews: some View {
        IAmA()
    }
}
