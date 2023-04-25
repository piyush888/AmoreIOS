//
//  ContentView.swift
//  lol
//
//  Created by Somil Sharma on 25/04/23.
//

import SwiftUI

struct SplashView: View {
    
    @State private var isShowing = false
    
    var body: some View {
        ZStack {
            Color(hex: 0x10094f)
                .edgesIgnoringSafeArea(.all)
                .overlay(
                    ZStack {
                        LinearGradient(
                            gradient: Gradient(colors: [.clear, Color(hex: 0xEB1F31).opacity(1)]),
                            startPoint:  UnitPoint.topTrailing,
                            endPoint:  UnitPoint.bottomLeading
                        )
                        LinearGradient(
                            gradient: Gradient(colors: [.clear, Color(hex: 0x0200d6).opacity(0.8)]),
                            startPoint:  UnitPoint.topLeading,
                            endPoint:  UnitPoint.topTrailing
                        )
                    }
                )
            VStack(spacing:-20)  {
                Spacer()
                
                HStack{
                    Spacer()
                    Image("LuvAmoreIconWhite")
                        .resizable()
                        .frame(width: 140, height: 140)
                    Spacer()
                }
                
                
                Text("Luv Amore")
                    .font(.custom("Questrial", size: 20))
                    .fontWeight(.heavy)
                    .foregroundColor(.white)
                Spacer()
            }
        }
        .ignoresSafeArea()
    }
        
}

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView()
    }
}

