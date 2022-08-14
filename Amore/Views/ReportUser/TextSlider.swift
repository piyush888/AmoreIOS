//
//  TextSlider.swift
//  Amore
//
//  Created by Kshitiz Sharma on 12/18/21.
//

import SwiftUI

struct SafetyIconWithMessage:Identifiable {

    var id: Int
    var image: String
    var illustration: String
    var title: String
    var safetyStatement: String
    var colorScheme: Color
    var colorSchemeCard: [Color]
    
}

var safetyMessages = [SafetyIconWithMessage(id:1,
                                        image:"shield.fill",
                                        illustration: "Illustration 3",
                                        title:"Safety",
                                        safetyStatement:"Keep your community safe & be supportive of other people choices",
                                        colorScheme: Color.green,
                                        colorSchemeCard:[Color(hex:0x61F4DE),Color(hex:0xFF6EE0)]),
                    SafetyIconWithMessage(id:2,
                                        image:"eye.circle.fill",
                                        illustration:"Illustration 2",
                                        title:"Protection",
                                        safetyStatement:"See something, Say something, Be our eyes and ears",
                                        colorScheme: Color.yellow,
                                          colorSchemeCard:[Color(hex:0x61F4DE),Color(hex:0xFF6EE0)]),
                     SafetyIconWithMessage(id:3,
                                        image:"exclamationmark.octagon.fill",
                                        illustration:"Illustration 4",
                                        title:"Report",
                                        safetyStatement:"Report fake accounts, activities & child abuse",
                                        colorScheme: Color.purple,
                                           colorSchemeCard:[Color(hex:0x61F4DE),Color(hex:0xFF6EE0)])]

struct TextSlider: View {
    
    
    @State private var selectedIndexCount = 1
    @State private var selectedTabIndex = 1
    let timer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()

    var body: some View {
        
        TabView(selection: $selectedTabIndex) {
            ForEach(safetyMessages) { safety in
                GeometryReader { proxy in
                    VStack {
                        let minX = proxy.frame(in: .global).minX
                        
                        FeaturedDescription(safety: safety)
                            .frame(maxWidth: 400)
                            .frame(maxWidth: .infinity)
                            .padding(.top, 20)
                            .rotation3DEffect(.degrees(minX / -10), axis: (x: 0, y: 1, z: 0))
//                            .shadow(color: Color("Shadow").opacity(0.3), radius: 7, x: 0, y: 7)
                            .blur(radius: abs(minX / 40))
                            .overlay(
                                Image(safety.illustration)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(height: 165)
                                    .offset(x: 60, y: -20)
                                    .offset(x: minX / 2)
                            )
                    }
                    .tag(safety.id)
                }
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .onReceive(timer) { _ in
                selectedIndexCount = selectedIndexCount+1
                selectedTabIndex = selectedIndexCount % 4
        }
        .animation(.easeInOut) // 2
        .transition(.slide) // 3
    }
}

struct TextSlider_Previews: PreviewProvider {
    static var previews: some View {
        TextSlider()
    }
}



struct FeaturedDescription: View {
    var safety: SafetyIconWithMessage = safetyMessages[0]
    
    var body: some View {
        
        
        VStack(alignment: .leading, spacing: 8.0) {
            
            Spacer()
                
            Image(systemName:safety.image)
                .resizable(resizingMode: .stretch)
                .aspectRatio(contentMode: .fit)
                .frame(width: 20.0, height: 20.0)
                .cornerRadius(10)
                .padding(9)
                .strokeStyle(cornerRadius: 16)
                .foregroundColor(safety.colorScheme)
            
            Text(safety.title)
                .font(.title2)
                .fontWeight(.bold)
                .lineLimit(1)
//            Text()
//                .font(.footnote)
//                .fontWeight(.semibold)
//                .foregroundColor(.primary)
            Text(safety.safetyStatement.uppercased())
                .font(.footnote)
                .multilineTextAlignment(.leading)
                .lineLimit(2)
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundColor(.secondary)
        }
        .padding(.horizontal, 10)
        .padding(.bottom, 15)
        .frame(height: 200)
        .background(
            RoundedRectangle(cornerRadius: 30, style: .continuous)
                .fill(LinearGradient(gradient: Gradient(colors: safety.colorSchemeCard),
                                     startPoint: .bottomLeading,
                                       endPoint: .top))
        )
//        .cornerRadius(30.0)
//        .mask(RoundedRectangle(cornerRadius: 30, style: .continuous))
        .strokeStyle()
    }
}

struct StrokeStyle: ViewModifier {
    var cornerRadius: CGFloat
    @Environment(\.colorScheme) var colorScheme
    func body(content: Content) -> some View {
        content.overlay(
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .stroke(
                    .linearGradient(
                        colors: [
                            .white.opacity(colorScheme == .dark ? 0.1 : 0.3),
                            .black.opacity(colorScheme == .dark ? 0.3 : 0.1)
                        ], startPoint: .top, endPoint: .bottom
                    )
                )
                .blendMode(.overlay)
        )
    }
}

extension View {
    func strokeStyle(cornerRadius: CGFloat = 30) -> some View {
        modifier(StrokeStyle(cornerRadius: cornerRadius))
    }
}
