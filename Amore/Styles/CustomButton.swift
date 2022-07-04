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

struct ReportProfileButton: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(20)
            .frame(maxWidth: .infinity)
            .background(LinearGradient(gradient: Gradient(colors: [Color(hex: 0xFF5F6D),
                                                                   Color(hex: 0xFFC371)]), startPoint: .topLeading, endPoint: .bottomTrailing))
            .foregroundColor(.white)
            .mask(RoundedCorner(radius: 20, corners: [.topRight, .bottomLeft, .bottomRight]))
            .mask(RoundedRectangle(cornerRadius: 8))
            .shadow(color: Color(hex: 0xC9D6FF).opacity(0.5), radius: 20, x: 0, y: 10)
    }
}


extension View {
    func reportProfileButton() -> some View {
        modifier(ReportProfileButton())
    }
}



struct DoneButton: View {
    var body: some View {
        Text("Done")
            .fontWeight(.bold)
            .font(.footnote)
            .padding()
            .foregroundColor(.white)
            .background(LinearGradient(gradient: Gradient(colors: [Color("dark-green"), Color("light-green")]), startPoint: .leading, endPoint: .trailing))
            .cornerRadius(20)
        
    }
}
