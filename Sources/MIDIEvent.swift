//
//  MIDIEvent.swift
//  KoreMIDI
//
//  Created by Adam Nemecek on 4/8/17.
//
//

import Foundation
import AudioToolbox

public struct MIDIEvent : Equatable, Comparable, Hashable, MIDIEventConvertible, CustomStringConvertible {
    public typealias Timestamp = MusicTimeStamp
    public let timestamp: Timestamp
    public let type: MIDIEventType
    public let data: Data
    
    public static func ==(lhs: MIDIEvent, rhs: MIDIEvent) -> Bool {
        return lhs.timestamp == rhs.timestamp &&
            lhs.type == rhs.type &&
            lhs.data == rhs.data
    
    }
    
    public var description : String {
        switch type {
        case .note:
            return "Note(timestamp : \(timestamp), \(MIDINoteMessage(event: self)!)"
        default: fatalError()
        }
    }
    
    /// Comparison is based on timestamp
    public static func <(lhs: MIDIEvent, rhs: MIDIEvent) -> Bool {
        return lhs.timestamp < rhs.timestamp
    }
    
    public var hashValue: Int {
        return (type.hashValue << 16) | timestamp.hashValue
    }
    
    public static var type : MIDIEventType {
        fatalError()
    }
    
    public init(timestamp: Timestamp, type: MIDIEventType, data: Data) {
        self.timestamp = timestamp
        self.type = type
        self.data = data
    }
    
    public init?(event: MIDIEvent) {
        self = event
    }
    
    public func insert(to: MIDITrack, at timestamp: MusicTimeStamp) {
        
        switch type {
        case .extendedNote:
            fatalError()
        case .extendedTempo:
            fatalError()
        case .user:
            fatalError()
        case .meta:
            fatalError()
        case .note:
            MIDINoteMessage(event: self)!.insert(to: to, at: timestamp)
        case .channel:
            fatalError()
        case .rawData:
            fatalError()
        case .parameter:
            fatalError()
        case .auPreset:
            fatalError()
            
        default: fatalError()
        }
        
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

