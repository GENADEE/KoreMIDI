//
//  MIDIEvent.swift
//  KoreMIDI
//
//  Created by Adam Nemecek on 4/8/17.
//
//

import Foundation
import AudioToolbox

//protocol Temporal {
//    associatedtype Timestamp : Comparable, Strideable
//}

//struct Event<Element : Temporan> {
//    
//}

//public struct MIDIEvent<Timestamp : Comparable & Hashable> : Equatable, Comparable, Hashable, MIDIEventConvertible, CustomStringConvertible {
////    public typealias Timestamp = MusicTimeStamp
//    public let timestamp: Timestamp
//    public let type: MIDIEventType
//    public let data: Data
//    
//    public static func ==(lhs: MIDIEvent, rhs: MIDIEvent) -> Bool {
//        return lhs.timestamp == rhs.timestamp &&
//            lhs.type == rhs.type &&
//            lhs.data == rhs.data
//    
//    }
//    
//    /// Comparison is based on timestamp
//    public static func <(lhs: MIDIEvent, rhs: MIDIEvent) -> Bool {
//        return lhs.timestamp < rhs.timestamp
//    }
//    
//    public var description : String {
//        switch type {
//        case .note:
//            return "Note(timestamp : \(timestamp), \(MIDINoteMessage(data: data)))"
//        default: fatalError()
//        }
//    }
//
//    public var hashValue: Int {
//        return (type.hashValue << 16) | timestamp.hashValue
//    }
//    
//    public static var type : MIDIEventType {
//        fatalError()
//    }
//    
//    public init(timestamp: Timestamp, type: MIDIEventType, data: Data) {
//        self.timestamp = timestamp
//        self.type = type
//        self.data = data
//    }
//    
//    public init?(event: MIDIEvent) {
//        self = event
//    }
//    
//    public func insert(to: MIDITrack, at timestamp: MusicTimeStamp) {
//        
//        switch type {
//        case .extendedNote:
//            fatalError()
//        case .extendedTempo:
//            fatalError()
//        case .user:
//            fatalError()
//        case .meta:
//            fatalError()
//        case .note:
//            MIDINoteMessage(event: self)!.insert(to: to, at: timestamp)
//        case .channel:
//            fatalError()
//        case .rawData:
//            fatalError()
//        case .parameter:
//            fatalError()
//        case .auPreset:
//            fatalError()
//            
//        default: fatalError()
//        }
//        
//    }
//}


