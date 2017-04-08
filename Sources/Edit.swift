//
//  File.swift
//  KoreMIDI
//
//  Created by Adam Nemecek on 4/7/17.
//
//

import Foundation


enum Edit<Element : Equatable & Hashable> : Equatable, Hashable {
    case create(Element), update(Element, Element), delete(Element)
    
    static func ==(lhs: Edit, rhs: Edit) -> Bool {
        switch (lhs, rhs) {
        case let (.create(l), .create(r)) where l == r:
            return true
        case let (.update(l0, l1), .update(r0, r1)) where (l0, l1) == (r0, r1):
            return true
        case let (.delete(l), .delete(r)) where l == r:
            return true
            
        default: return false
        }
    }
    
    var hashValue : Int {
        switch self {
        case let .create(v):
            return v.hashValue
        case let .update(l, _):
            return l.hashValue
        case let .delete(v):
            return v.hashValue
        }
    }
}

