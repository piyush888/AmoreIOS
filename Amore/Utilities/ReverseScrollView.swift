//
//  ReverseScrollView.swift
//  Amore
//
//  Created by Piyush Garg on 14/06/22.
//

import SwiftUI
import Foundation

struct ReverseScrollView<Content: View>: View {
    var axis: Axis.Set
    var content: Content
    
    func minWidth(in proxy: GeometryProxy, for axis: Axis.Set) -> CGFloat? {
        axis.contains(.horizontal) ? proxy.size.width : nil
    }
    
    func minHeight(in proxy: GeometryProxy, for axis: Axis.Set) -> CGFloat? {
        axis.contains(.vertical) ? proxy.size.height : nil
    }
    
    init(_ axis: Axis.Set = .horizontal, @ViewBuilder builder: @escaping () -> Content) {
        self.axis = axis
        self.content = builder()
    }
    
    @State var count1 = 100
    
    var body: some View {
        GeometryReader { proxy in
            ScrollView(axis) {
                Stack(axis) {
                    if axis == .horizontal {
                        LazyHStack(alignment: .center, spacing: nil, pinnedViews: [], content: {
                            content
                        })
                    }
                    else {
                        LazyVStack(alignment: .center, spacing: nil, pinnedViews: [], content: {
                            content
                        })
                    }
                }
                .frame(
                    minWidth: minWidth(in: proxy, for: axis),
                    minHeight: minHeight(in: proxy, for: axis),
                    alignment:.bottom
                )
                
            }
            .rotationEffect(Angle(degrees: 180)).scaleEffect(x: -1.0, y: 1.0, anchor: .center)
        }
    }
}

struct Stack<Content: View>: View {
    var axis: Axis.Set
    var content: Content
    
    init(_ axis: Axis.Set = .vertical, @ViewBuilder builder: @escaping () -> Content) {
        self.axis = axis
        self.content = builder()
    }
    
    var body: some View {
        switch axis {
        case .horizontal:
            HStack {
                content
            }
        case .vertical:
            VStack {
                content
            }
        default:
            VStack {
                content
            }
        }
    }
}


struct ReverseScrollView_Previews: PreviewProvider {
    static var previews: some View {
        ReverseScrollView(.vertical) {
            ForEach(0..<1) { item in
                Text("\(item)")
                    .padding()
                    .background(Color.gray.opacity(0.5))
                    .cornerRadius(6)
                    .rotationEffect(Angle(degrees: 180)).scaleEffect(x: -1.0, y: 1.0, anchor: .center)
            }
            .frame(maxWidth: .infinity)
        }
    }
}
