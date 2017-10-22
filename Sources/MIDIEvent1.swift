//
//  MIDIEvent1.swift
//  KoreMIDI
//
//  Created by Adam Nemecek on 10/22/17.
//

import Foundation


public struct MIDIEvent1<Event : MIDIEventConvertible> : Comparable, Hashable, Strideable, CustomStringConvertible {
    public typealias Timestamp = MIDITimestamp
    public typealias Stride = Timestamp.Stride

    public let timestamp: Timestamp
    public let event: Event

    public var description: String {
        fatalError()
    }

    public var hashValue: Int {
        return timestamp.hashValue
    }

    public static func ==(lhs: MIDIEvent1, rhs: MIDIEvent1) -> Bool {
        return lhs.timestamp == rhs.timestamp
    }

    public static func <(lhs: MIDIEvent1, rhs: MIDIEvent1) -> Bool {
        return lhs.timestamp < rhs.timestamp
    }
}
