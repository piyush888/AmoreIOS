//
//  HideKeyboardExtension.swift
//  Amore
//
//  Created by Piyush Garg on 04/03/22.
//

import Foundation
import SwiftUI

#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif
