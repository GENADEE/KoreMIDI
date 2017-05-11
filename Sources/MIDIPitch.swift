//
//  MIDIPitch.swift
//  KoreMIDI
//
//  Created by Adam Nemecek on 4/9/17.
//
//

import Foundation

public struct MIDIPitch : Comparable, Hashable, RawRepresentable, Strideable {
    public typealias Interval = Int
    private static let range = 0..<UInt8.max

    public let rawValue: UInt8

    public init?(rawValue: UInt8) {
        self.rawValue = rawValue
    }

    public static func +(lhs: MIDIPitch, rhs: Interval) -> MIDIPitch {
        fatalError()
    }

    public func advanced(by n: Interval) -> MIDIPitch {
        return self + n
    }

    public func distance(to other: MIDIPitch) -> Interval {
        return rawValue.distance(to: other.rawValue)
    }

    public static func ==(lhs: MIDIPitch, rhs: MIDIPitch) -> Bool {
        return lhs.rawValue == rhs.rawValue
    }

    public static func <(lhs: MIDIPitch, rhs: MIDIPitch) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }

    public var hashValue: Int {
        return rawValue.hashValue
    }
}
