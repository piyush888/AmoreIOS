//
//  NoPhotoProvided.swift
//  Amore
//
//  Created by Kshitiz Sharma on 11/19/21.
//

import SwiftUI

struct NoPhotoProvided: View {
    
    @State var imageWidth: CGFloat
    @State var imageHeight: CGFloat
    
    var body: some View {
        
        ZStack{
            Rectangle()
                .cornerRadius(5.0)
                .frame(height: imageHeight/1.5)
                .foregroundColor(.white)
                .overlay(RoundedRectangle(cornerRadius: 5)
                        .stroke(Color.clear, lineWidth: 1))
                
            VStack(alignment: .center) {
                Spacer()
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .frame(width:60, height:60)
            
                Text("No photo provided")
                    .padding(.top,5)
                Spacer()
            }.foregroundColor(.pink)
        }
        .padding()
        .cornerRadius(10.0)
        
    }
}
