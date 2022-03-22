//
//  ViewExtensions.swift
//  Amore
//
//  Created by Piyush Garg on 21/03/22.
//

import Foundation
import SwiftUI

extension View {
    
    func performOnChange<T: Equatable>(of inPutValue: T, withKey key: String, capturedValues: @escaping (ReturnValueType<T>) -> Void) -> some View {
        
        return self
            .preference(key: OptionalGenericPreferenceKey<T>.self, value: inPutValue)
            .onPreferenceChange(OptionalGenericPreferenceKey<T>.self) { newValue in
                
                if let unwrappedNewValue: T = newValue {
                    
                    if let unwrappedOldValue: T = backupDictionary[key] as? T { capturedValues((oldValue: unwrappedOldValue, newValue: unwrappedNewValue)) }
                    
                }
                
                backupDictionary[key] = newValue
                
            }
        
    }
    
}


typealias ReturnValueType<T: Equatable> = (oldValue: T, newValue: T)

var backupDictionary: [String: Any] = [String: Any]()

struct OptionalGenericPreferenceKey<T: Equatable>: PreferenceKey {
    
    static var defaultValue: T? { get { return nil } }
    
    static func reduce(value: inout T?, nextValue: () -> T?) { value = nextValue() }
    
}
