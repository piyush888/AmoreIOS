//
//  Completed.swift
//  Amore
//
//  Created by Kshitiz Sharma on 11/17/21.
//

import SwiftUI

struct Completed: View {
    
    @State var time = 0.0
    @State var scale = 0.1
    let duration = 5.0
    
    var body: some View {
        
        ZStack {
                Circle()
                    .fill(Color.blue)
                    .frame(width: 12, height: 12)
                    .modifier(ParticlesModifier())
                    .offset(x: -100, y : -50)
                
                Circle()
                    .fill(Color.red)
                    .frame(width: 12, height: 12)
                    .modifier(ParticlesModifier())
                    .offset(x: 60, y : 70)
            
            VStack {
                Text("Get ready for more matches !!!")
                    .font(.title2)
                    .padding(.bottom,40)
                    .foregroundColor(.white)
                
                // Continue to move to next view
                Button{
                    // Close the view
                    
                } label : {
                    ZStack{
                        Rectangle()
                            .frame(height:45)
                            .cornerRadius(5.0)
                            .foregroundColor(.pink)
                            .padding(.horizontal,70)
                        
                        Text("Keep Swiping")
                            .foregroundColor(.white)
                            .bold()
                            .font(.BoardingButton)
                    }
                }
                
            }
        }
        
    }
}

struct Completed_Previews: PreviewProvider {
    static var previews: some View {
        Completed()
    }
}


struct ParticlesModifier: ViewModifier {
    @State var time = 0.0
    @State var scale = 0.1
    let duration = 5.0
    
    func body(content: Content) -> some View {
        ZStack {
            ForEach(0..<80, id: \.self) { index in
                content
                    .hueRotation(Angle(degrees: time * 80))
                    .scaleEffect(scale)
                    .modifier(FireworkParticlesGeometryEffect(time: time))
                    .opacity(((duration-time) / duration))
            }
        }
        .onAppear {
            withAnimation (.easeOut(duration: duration)) {
                self.time = duration
                self.scale = 1.0
            }
        }
    }
}


struct FireworkParticlesGeometryEffect : GeometryEffect {
    var time : Double
    var speed = Double.random(in: 20 ... 200)
    var direction = Double.random(in: -Double.pi ...  Double.pi)
    
    var animatableData: Double {
        get { time }
        set { time = newValue }
    }
    func effectValue(size: CGSize) -> ProjectionTransform {
        let xTranslation = speed * cos(direction) * time
        let yTranslation = speed * sin(direction) * time
        let affineTranslation =  CGAffineTransform(translationX: xTranslation, y: yTranslation)
        return ProjectionTransform(affineTranslation)
    }
}
