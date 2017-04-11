//
//  Timer.swift
//  KoreMIDI
//
//  Created by Adam Nemecek on 4/7/17.
//
//

import Foundation

import QuartzCore

struct TimerIterator : IteratorProtocol {
    typealias Element = CFTimeInterval
    func next() ->  Element? {
        return CACurrentMediaTime()
    }
}

struct Timer : Sequence {
    func makeIterator() -> TimerIterator {
        return TimerIterator()
    }
}


//struct MIDIEvent2<Event : MIDIEventConvertible>: Comparable, Hashable {
//    public let timestamp : MIDITimestamp
//    
//    public var type : MIDIEventType {
//        fatalError()
//    }
//    
//    public let event : Event
//    
//    public static func ==(lhs: MIDIEvent2, rhs: MIDIEvent2) -> Bool {
//        return lhs.timestamp == rhs.timestamp && lhs.event == rhs.event
//    }
//    
//    /// Comparison is based on timestamp
//    public static func <(lhs: MIDIEvent2, rhs: MIDIEvent2) -> Bool {
//        return lhs.timestamp < rhs.timestamp
//    }
//    
//    public var hashValue: Int {
//        return (timestamp.hashValue << 16)
//    }
//    
//    public static var type : MIDIEventType {
//        fatalError()
//    }
//    
//    public init(timestamp: MIDITimestamp, event: Event) {
//        self.timestamp = timestamp
//        self.event = event
//    }
//    
//}
