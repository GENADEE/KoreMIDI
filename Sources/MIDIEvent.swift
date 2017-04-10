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
    let timestamp: MusicTimeStamp
    let type: MIDIEventType
    let data: Data
    
    public static func ==(lhs: MIDIEvent, rhs: MIDIEvent) -> Bool {
        fatalError()
    }
    
    public static func <(lhs: MIDIEvent, rhs: MIDIEvent) -> Bool {
        fatalError()
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

