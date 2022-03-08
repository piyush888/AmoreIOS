//
//  DynamicViewModifier.swift
//  Amore
//
//  Created by Piyush Garg on 17/11/21.
//

import Foundation
import SwiftUI
import Combine

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


struct AdaptsToSoftwareKeyboard: ViewModifier {

    @State var currentHeight: CGFloat = 0

    func body(content: Content) -> some View {
        content
            .padding(.bottom, self.currentHeight)
            .edgesIgnoringSafeArea(self.currentHeight == 0 ? Edge.Set() : .bottom)
            .onAppear(perform: subscribeToKeyboardEvents)
    }

    private let keyboardWillOpen = NotificationCenter.default
        .publisher(for: UIResponder.keyboardWillShowNotification)
        .map { $0.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! CGRect }
        .map { $0.height }

    private let keyboardWillHide =  NotificationCenter.default
        .publisher(for: UIResponder.keyboardWillHideNotification)
        .map { _ in CGFloat.zero }

    private func subscribeToKeyboardEvents() {
        _ = Publishers.Merge(keyboardWillOpen, keyboardWillHide)
            .subscribe(on: RunLoop.main)
            .assign(to: \.self.currentHeight, on: self)
    }
}
