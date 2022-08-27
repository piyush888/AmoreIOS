//
//  BackGroundGraphics.swift
//  Amore
//
//  Created by Kshitiz Sharma on 8/27/22.
//

import SwiftUI

// Struct used for making background graphics
struct BGGraphics:Hashable {
    var imageName: String
    var height: CGFloat
    var width: CGFloat
    var color: Color
    var x: CGFloat
    var y: CGFloat
    var rotationAngle: CGFloat
    var blur: CGFloat
}
