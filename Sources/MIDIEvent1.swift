//
//  MIDIEvent1.swift
//  KoreMIDI
//
//  Created by Adam Nemecek on 10/22/17.
//

public struct MIDIEvent1<Event : MIDIEventConvertible> : Comparable, Hashable, Strideable, CustomStringConvertible {
    public typealias Timestamp = MIDITimestamp
    public typealias Stride = Timestamp.Stride

    public let timestamp: Timestamp
    public let event: Event

    public var description: String {
        return "\(type(of: self))(timestamp: \(timestamp), \(event)"
    }

    public var hashValue: Int {
        return timestamp.hashValue
    }

    public static func ==(lhs: MIDIEvent1, rhs: MIDIEvent1) -> Bool {
        return lhs.timestamp == rhs.timestamp && lhs.event == rhs.event
    }

    public static func <(lhs: MIDIEvent1, rhs: MIDIEvent1) -> Bool {
        return lhs.timestamp < rhs.timestamp
    }

    public func advanced(by n: Stride) -> MIDIEvent1 {
        return MIDIEvent1(timestamp: timestamp.advanced(by: n), event: event)
    }

    public func distance(to other: MIDIEvent1) -> Stride {
        return timestamp.distance(to: other.timestamp)
    }
}


