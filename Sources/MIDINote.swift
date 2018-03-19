//
//  MIDINote.swift
//  KoreMIDI
//
//  Created by Adam Nemecek on 4/7/17.
//
//

import AVFoundation

public struct MIDINote: Equatable, Hashable, CustomStringConvertible, Strideable {
    public typealias Timestamp = MIDITimestamp
    public typealias Stride = Timestamp.Stride

    public let timestamp: Timestamp

    internal let msg: MIDINoteMessage

    internal init(timestamp: Timestamp, msg: MIDINoteMessage) {
        self.timestamp = timestamp
        self.msg = msg
    }

    public func advanced(by n: Stride) -> MIDINote {
        return MIDINote(timestamp: timestamp.advanced(by: n), msg: msg)
    }

    public func distance(to other: MIDINote) -> Stride {
        return timestamp.distance(to: other.timestamp)
    }

    public static func ==(lhs: MIDINote, rhs: MIDINote) -> Bool {
        return lhs.timestamp == rhs.timestamp && lhs.msg == rhs.msg
    }

    public var hashValue: Int {
        return timestamp.hashValue ^ msg.hashValue
    }

    public var description: String {
        return "timestamp: \(timestamp), duration: \(msg)"
    }
}

