//
//  NavigationBar.swift
//  iOS15
//
//  Created by Kshitiz Sharma on 7/15/22.
//

import SwiftUI

struct NavigationBar: View {
    var title = ""
    @Binding var contentHasScrolled: Bool
    
    var body: some View {
        ZStack {
            if #available(iOS 15.0, *) {
                Rectangle()
                    .frame(maxWidth: .infinity)
                    .frame(height: 100)
                    .background(.ultraThinMaterial)
                    .ignoresSafeArea()
                    .frame(maxHeight: .infinity, alignment: .top)
                    .blur(radius: contentHasScrolled ? 10 : 0)
                    .opacity(contentHasScrolled ? 1 : 0)
                
                Text(title)
                    .foregroundStyle(.primary)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                    .padding(.horizontal, 20)
                    .padding(.top, 24)
                    .opacity(contentHasScrolled ? 0.7 : 1)
                
                } else {
                    // Fallback on earlier versions
                    Rectangle()
                        .frame(maxWidth: .infinity)
                        .frame(height: 100)
                        .background(
                            RoundedRectangle(cornerRadius: 30, style: .continuous)
                                .fill(LinearGradient(gradient: Gradient(colors: [Color(hex:0x61F4DE),Color(hex:0xFF6EE0)]),
                                                     startPoint: .bottomLeading,
                                                       endPoint: .top))
                        )
                        .ignoresSafeArea()
                        .frame(maxHeight: .infinity, alignment: .top)
                        .blur(radius: contentHasScrolled ? 10 : 0)
                        .opacity(contentHasScrolled ? 1 : 0)
                    
                    Text(title)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                        .padding(.horizontal, 20)
                        .padding(.top, 24)
                        .opacity(contentHasScrolled ? 0.7 : 1)
                }
            
        }
        .offset(y:true ? 0 : -120)
        .offset(y: contentHasScrolled ? -16 : 0)
    }
    
}

struct NavigationBar_Previews: PreviewProvider {
    static var previews: some View {
        NavigationBar(contentHasScrolled: .constant(false))
            .preferredColorScheme(.dark)
    }
}

