//
//  PaymentComplete.swift
//  Amore
//
//  Created by Kshitiz Sharma on 4/17/22.
//
import SwiftUI

struct PaymentComplete: View {
        
    @EnvironmentObject var storeManager: StoreManager
    @State var subscriptionTypeId: String
    @State var time = 0.0
    @State var scale = 0.1
    
    @Environment(\.colorScheme) var colorScheme
    
    let duration = 5.0
    
    var subscriptionDetailColor: Binding<Color> {
        return colorScheme == .dark ? Binding.constant(Color(hex: 0x24244A)): Binding.constant(Color(hex: 0xe8f4f8))
    }
    
    var body: some View {
        
        ZStack {
           
            VStack {
                
                // Thank the user for buying the application
                thanksForBuying
                
                // Describe the plan user has or ofer them to upgrade it to a better plan
                planDescription
                
                SubscriptionDetails(popUpCardSelection:Binding.constant(PopUpCards.myAmorecards),
                                    showModal:Binding.constant(false),
                                    backgroundColor:subscriptionDetailColor)
                    .frame(width: UIScreen.main.bounds.width-50, height:90)
                    .padding(.horizontal,30)
                
                
                HStack {
                    Spacer()
                    
                    // Rate Us
                    Button("Rate us") {
                        storeManager.writeReview()
                    }
                    .buttonStyle(GrowingButton(buttonColor:Color.pink, fontColor: Color.white))
                    
                    Spacer()
                    
                    Button("Keep Swiping") {
                        storeManager.paymentCompleteDisplayMyAmore = false
                    }
                    .buttonStyle(GrowingButton(buttonColor:Color.blue, fontColor: Color.white))
                    
                    Spacer()
                }
                .padding()
                
            }
            
            // Particle modifiers
            Image(systemName: "heart.fill")
                .frame(width:60, height:60)
                    .foregroundColor(.pink)
                    .modifier(ParticlesModifier())
                    .offset(x: -100, y : -50)
            
            // Particle modifiers
            Image(systemName: "heart.fill")
                    .frame(width:60, height:60)
                    .foregroundColor(.blue)
                    .modifier(ParticlesModifier())
                    .offset(x: 60, y : 70)
            
        }
        
    }
    
    var thanksForBuying: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .foregroundColor(colorScheme == .dark ? Color(hex: 0x24244A): Color(hex: 0xe8f4f8))
            
            VStack {
                Image(systemName: "gift.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                    .foregroundColor(.blue)
                
                Text("Thanks for being part of community, Purchase was complete.")
                    .padding(20)
                    .multilineTextAlignment(.center)
            }
        }
        .padding(.horizontal,30)
        .frame(height:180)
    }
    
    
    var planDescription: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .foregroundColor(colorScheme == .dark ? Color(hex: 0x24244A): Color(hex: 0xe8f4f8))
            
            VStack {
                Image(systemName: "bolt.heart.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
                    .foregroundColor(.red)
                
                if subscriptionTypeId.contains("Free") {
                    Text("If you like Amore Free").font(.title2)
                    Text("Consider upgrading to Amore Gold").font(.caption)
                } else if subscriptionTypeId.contains("Gold") {
                    Text("Amore \(subscriptionTypeId.components(separatedBy: ".")[2]) Gold plan").font(.title2)
                    Text("We hope you are enjoying the app").font(.caption)
                }
            }
        }
        .padding(.horizontal,30)
        .frame(height:180)
    }
    
    
}

struct PaymentComplete_Previews: PreviewProvider {
    
    static var previews: some View {
        PaymentComplete(subscriptionTypeId:"Amore.ProductId.12M.Platinum.v1")
            .environmentObject(StoreManager())
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

