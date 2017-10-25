//
//  MIDIEvent1.swift
//  KoreMIDI
//
//  Created by Adam Nemecek on 10/22/17.
//

public struct MIDIEvent<Event : MIDIEventConvertible> : Comparable, Hashable, Strideable, CustomStringConvertible {
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

    public static func ==(lhs: MIDIEvent, rhs: MIDIEvent) -> Bool {
        return lhs.timestamp == rhs.timestamp && lhs.event == rhs.event
    }

    public static func <(lhs: MIDIEvent, rhs: MIDIEvent) -> Bool {
        return lhs.timestamp < rhs.timestamp
    }

    public func advanced(by n: Stride) -> MIDIEvent {
        return .init(timestamp: timestamp.advanced(by: n), event: event)
    }

    public func distance(to other: MIDIEvent) -> Stride {
        return timestamp.distance(to: other.timestamp)
    }
}
