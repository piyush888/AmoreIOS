//
//  OptionalExtension.swift
//  Amore
//
//  Created by Piyush Garg on 28/10/21.
//

import Foundation
import UIKit

extension Optional where Wrapped == String {
    var _bound: String? {
        get {
            return self
        }
        set {
            self = newValue
        }
    }
    public var bound: String {
        get {
            return _bound ?? ""
        }
        set {
            _bound = newValue.isEmpty ? nil : newValue
        }
    }
}

extension Optional where Wrapped == CGFloat {
    var _boundCGFloat: CGFloat? {
        get {
            return self
        }
        set {
            self = newValue
        }
    }
    public var boundCGFloat: CGFloat {
        get {
            return _boundCGFloat ?? 0.0
        }
        set {
            _boundCGFloat = newValue.isFinite ? newValue : nil
        }
    }
}

extension Optional where Wrapped == Bool {
    var _boundBool: Bool? {
        get {
            return self
        }
        set {
            self = newValue
        }
    }
    public var boundBool: Bool {
        get {
            return _boundBool ?? false
        }
        set {
            _boundBool = newValue ? newValue : nil
        }
    }
}

extension Optional where Wrapped == Double {
    var _boundDouble: Double? {
        get {
            return self
        }
        set {
            self = newValue
        }
    }
    public var boundDouble: Double {
        get {
            return _boundDouble ?? 0
        }
        set {
            _boundDouble = newValue.isFinite ? newValue : nil
        }
    }
}

extension Optional where Wrapped == [String] {
    var _boundStringArray: [String]? {
        get {
            return self
        }
        set {
            self = newValue
        }
    }
    public var boundStringArray: [String] {
        get {
            return _boundStringArray ?? []
        }
        set {
            _boundStringArray = newValue.isEmpty ? nil : newValue
        }
    }
}

extension Optional where Wrapped == Int {
    var _boundInt: Int? {
        get {
            return self
        }
        set {
            self = newValue
        }
    }
    public var boundInt: Int {
        get {
            return _boundInt ?? 0
        }
        set {
            _boundInt = Int(newValue) != nil ? Int(newValue) : nil
        }
    }
}

extension Optional where Wrapped == Photo {
    var _boundPhoto: Photo? {
        get {
            return self
        }
        set {
            self = newValue
        }
    }
    internal var boundPhoto: Photo {
        get {
            return _boundPhoto ?? Photo()
        }
        set {
            _boundPhoto = newValue != nil ? newValue : nil
        }
    }
}

extension Optional where Wrapped == Date {
    var _boundDate: Date? {
        get {
            return self
        }
        set {
            self = newValue
        }
    }
    internal var boundDate: Date {
        get {
            return _boundDate ?? Date()
        }
        set {
            _boundDate = newValue != nil ? newValue : nil
        }
    }
}
