//
//  MIDIPitch.swift
//  KoreMIDI
//
//  Created by Adam Nemecek on 4/9/17.
//
//

import Foundation

public struct MIDIPitch : Comparable, Hashable {
    public typealias Interval = Int
    private let range = 0..<UInt8.max

    private let content: UInt8

    public static func +(lhs: MIDIPitch, rhs: MIDIPitch) -> MIDIPitch? {
        fatalError()
    }
    
    public static func ==(lhs: MIDIPitch, rhs: MIDIPitch) -> Bool {
        return lhs.content == rhs.content
    }

    public static func <(lhs: MIDIPitch, rhs: MIDIPitch) -> Bool {
        return lhs.content < rhs.content
    }

    public var hashValue: Int {
        return content.hashValue
    }
}
