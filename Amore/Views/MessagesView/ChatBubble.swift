//
//  ChatBubble.swift
//  Amore
//
//  Created by Kshitiz Sharma on 10/17/21.
//

import SwiftUI

struct ChatBubble: Shape {

    var corners: UIRectCorner
    
    func path(in rect: CGRect) -> Path {
        
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: 13, height: 13))
        
        return Path(path.cgPath)
    }
}
