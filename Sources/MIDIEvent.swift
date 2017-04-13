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

public enum MIDIEvent<Timestamp: Comparable & Strideable & Hashable & TimestampType> : Comparable, Strideable, Hashable, CustomStringConvertible {
    public typealias Stride = Timestamp.Stride
    
    case note(Timestamp, MIDINoteMessage), other
    
    public init(timestamp: Timestamp, type: MIDIEventType, data: Data) {
        switch type {
        case .note:
            self = .note(timestamp, MIDINoteMessage(data: data))
        default:
            self = .other
        }
    }
    
    public var description: String {
        switch self {
        case let .note(ts, e):
            return ".note(timestamp: \(ts), \(e))"
        default: return "other"
        }
    }
    
    public var data : Data {
        switch self {
        case let .note(_, e):
            return Data(encode: e)
        default:
            return Data()
        }
    }
    
    public var type : MIDIEventType {
        switch self {
        case .note:
            return .note
        default:
            fatalError()
        }
    }
    
    public var timestamp: Timestamp {
        switch self {
        case let .note(ts, _):
            return ts
        default:
            fatalError()
        }
    }
    
    public var hashValue: Int {
        switch self {
        case let .note(ts, _):
            return ts.hashValue
        default:
            fatalError()
        }
    }
    
    public func advanced(by n: Timestamp.Stride) -> MIDIEvent<Timestamp> {
        return MIDIEvent(timestamp: timestamp.advanced(by: n), type: type, data: data)
    }
    
    public func distance(to other: MIDIEvent) -> Timestamp.Stride {
        return timestamp.distance(to: other.timestamp)
    }
    
    public static func ==(lhs: MIDIEvent, rhs: MIDIEvent) -> Bool {
        switch (lhs, rhs) {
        case let (.note(rt, re), .note(lt, le)):
            return rt == lt && re == le
        default:
            fatalError()
        }
    }
    
    public static func <(lhs: MIDIEvent, rhs: MIDIEvent) -> Bool {
        return lhs.timestamp < rhs.timestamp
    }
}

