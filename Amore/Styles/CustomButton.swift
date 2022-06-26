//
//  CustomButton.swift
//  Amore
//
//  Created by Kshitiz Sharma on 6/25/22.
//

import SwiftUI

struct LargeButton: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(20)
            .frame(maxWidth: .infinity)
            .background(Color(hex: 0xF77D8E))
            .foregroundColor(.white)
            .mask(RoundedCorner(radius: 20, corners: [.topRight, .bottomLeft, .bottomRight]))
            .mask(RoundedRectangle(cornerRadius: 8))
            .shadow(color: Color(hex: 0xF77D8E).opacity(0.5), radius: 20, x: 0, y: 10)
    }
}

extension View {
    func largeButton() -> some View {
        modifier(LargeButton())
    }
}


struct PurchaseButton: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(20)
            .frame(maxWidth: .infinity)
            .background(LinearGradient(gradient: Gradient(colors: [Color(hex:0x4e54c8), Color(hex:0x8f94fb)]), startPoint: .top, endPoint: .bottom))
            .background(Color(hex: 0xF77D8E))
            .foregroundColor(.white)
            .mask(RoundedCorner(radius: 20, corners: [.topRight, .bottomLeft, .bottomRight]))
            .mask(RoundedRectangle(cornerRadius: 8))
            .shadow(color: Color(hex: 0xF77D8E).opacity(0.5), radius: 20, x: 0, y: 10)
    }
}

extension View {
    func purcahseButton() -> some View {
        modifier(PurchaseButton())
    }
}
