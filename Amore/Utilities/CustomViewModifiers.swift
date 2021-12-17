//
//  DynamicViewModifier.swift
//  Amore
//
//  Created by Piyush Garg on 17/11/21.
//

import Foundation
import SwiftUI

struct PreviewProfileModifier: ViewModifier {
    
    var width: CGFloat
    var height: CGFloat
    
    func body(content: Content) -> some View {
        content
            .scaledToFill()
            .frame(width: width, height: height)
    }
}

struct UserSnapDetailsModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .scaledToFill()
            .frame(width: 200, height: 200, alignment: Alignment.center)
            .clipShape(Circle())
            .shadow(color: Color.pink, radius: 5, x: 0.5, y: 0.5)
    }
}
