//
//  MIDIEvent.swift
//  KoreMIDI
//
//  Created by Adam Nemecek on 4/8/17.
//
//

import Foundation
import AudioToolbox

public struct MIDIEvent : Equatable, Comparable, Hashable {
    public typealias Timestamp = MusicTimeStamp
    public let timestamp: Timestamp
    public let type: MIDIEventType
    public let data: Data
    
    public static func ==(lhs: MIDIEvent, rhs: MIDIEvent) -> Bool {
        return lhs.timestamp == rhs.timestamp &&
                lhs.type == rhs.type &&
                lhs.data == rhs.data
    }
    
    /// Comparison is based on timestamp
    public static func <(lhs: MIDIEvent, rhs: MIDIEvent) -> Bool {
        return lhs.timestamp < rhs.timestamp
    }
    
    public var hashValue: Int {
        return (type.hashValue << 16) | timestamp.hashValue
    }
}


extension Sequence where Iterator.Element : Comparable {
    func range() -> Range<Iterator.Element>? {
        var min : Iterator.Element? = nil
        var max : Iterator.Element? = nil
        for e in self {
            min = Swift.min(e, min ?? e)
            max = Swift.max(e, max ?? e)
        }
        return min.map { $0..<max! }
    }
}

