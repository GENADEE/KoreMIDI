//
//  MIDITimestamp.swift
//  KoreMIDI
//
//  Created by Adam Nemecek on 4/5/17.
//  Copyright © 2017 Adam Nemecek. All rights reserved.
//

import Foundation
import AudioToolbox.MusicPlayer

protocol DefaultConstructible {
    init()
}

public struct MIDITimestamp : Comparable, Hashable, Strideable, CustomStringConvertible, ExpressibleByFloatLiteral, ExpressibleByIntegerLiteral {

    public typealias Stride = MusicTimeStamp
    public typealias LiteralType = MusicTimeStamp

    /// note that beats are independent of tempo changes
    public let beats : MusicTimeStamp

    public init() {
        self = 0
    }

    public init(floatLiteral value: LiteralType) {
        self.beats = value
    }

    public init(float: Float32) {
        self.beats = MusicTimeStamp(float)
    }

    public init(beats: LiteralType) {
        self.beats = beats
    }

    public init(integerLiteral value: Int) {
        self.beats = MusicTimeStamp(value)
    }

    public var description: String {
        return "beats: \(beats)"
    }

    public static func ==(lhs: MIDITimestamp, rhs: MIDITimestamp) -> Bool {
        return lhs.beats == rhs.beats
    }

    public static func <(lhs: MIDITimestamp, rhs: MIDITimestamp) -> Bool {
        return lhs.beats < rhs.beats
    }

    public var hashValue: Int {
        return beats.hashValue
    }

    public func advanced(by n: Stride) -> MIDITimestamp {
        return MIDITimestamp(beats: beats + n)
    }

    public func distance(to other: MIDITimestamp) -> Stride {
        return other.beats - beats
    }

    public static func +(lhs: MIDITimestamp, rhs: MIDITimestamp) -> MIDITimestamp {
        return MIDITimestamp(beats: lhs.beats + rhs.beats)
    }

    public static prefix func -(_ value: MIDITimestamp) -> MIDITimestamp {
        return MIDITimestamp(beats: -value.beats)
    }

    public static func -(lhs: MIDITimestamp, rhs: MIDITimestamp) -> MIDITimestamp {
        return lhs + (-rhs)
    }
}

