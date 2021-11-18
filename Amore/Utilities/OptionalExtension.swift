//
//  OptionalExtension.swift
//  Amore
//
//  Created by Piyush Garg on 28/10/21.
//

import Foundation

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
