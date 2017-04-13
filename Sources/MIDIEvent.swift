//
//  MIDIEvent.swift
//  KoreMIDI
//
//  Created by Adam Nemecek on 4/8/17.
//
//

import Foundation
import AudioToolbox


public protocol TimestampType : Comparable, Strideable, Hashable {
    var beats: MusicTimeStamp { get }
}

extension MIDITimestamp : TimestampType { }

public enum MIDIEvent<Timestamp: TimestampType> : Comparable, Strideable, Hashable, CustomStringConvertible {
    public typealias Stride = Timestamp.Stride
    
    case extendedNote(Timestamp, ExtendedNoteOnEvent)
    case extendedTempo(Timestamp, ExtendedTempoEvent)
    case user(Timestamp, MusicEventUserData)
    case meta(Timestamp, MIDIMetaEvent)
    case note(Timestamp, MIDINoteMessage)
    case channel(Timestamp, MIDIChannelMessage)
    case rawData(Timestamp, MIDIRawData)
    case parameter(Timestamp, ParameterEvent)
    case auPreset(Timestamp, AUPresetEvent)
    
    public init(timestamp: Timestamp, type: MIDIEventType, data: Data) {
        switch type {
        case .extendedNote:
            self = .extendedNote(timestamp, data.decode())
        case .extendedTempo:
            self = .extendedTempo(timestamp, data.decode())
        case .user:
            self = .user(timestamp, data.decode())
        case .meta:
            self = .meta(timestamp, data.decode())
        case .note:
            self = .note(timestamp, data.decode())
        case .channel:
            self = .channel(timestamp, data.decode())
        case .rawData:
            self = .rawData(timestamp, data.decode())
        case .parameter:
            self = .parameter(timestamp, data.decode())
        case .auPreset:
            self = .auPreset(timestamp, data.decode())
        }
    }
    
    func map<U : TimestampType>(transform: (Timestamp) -> U) -> MIDIEvent<U> {
        return MIDIEvent<U>(timestamp: transform(timestamp), type: type, data: data)
    }
    
    public var description : String {
        switch self {
        case let .extendedNote(ts, e):
            return "\(type)(timestamp: \(ts), \(e))"
        case let .extendedTempo(ts, e):
            return "\(type)(timestamp: \(ts), \(e))"
        case let .user(ts, e):
            return "\(type)(timestamp: \(ts), \(e))"
        case let .meta(ts, e):
            return "\(type)(timestamp: \(ts), \(e))"
        case let .note(ts, e):
            return "\(type)(timestamp: \(ts), \(e))"
        case let .channel(ts, e):
            return "\(type)(timestamp: \(ts), \(e))"
        case let .rawData(ts, e):
            return "\(type)(timestamp: \(ts), \(e))"
        case let .parameter(ts, e):
            return "\(type)(timestamp: \(ts), \(e))"
        case let .auPreset(ts, e):
            return "\(type)(timestamp: \(ts), \(e))"
        }
    }
    
    public var timestamp : Timestamp {
        switch self {
        case let .extendedNote(ts, _):
            return ts
        case let .extendedTempo(ts, _):
            return ts
        case let .user(ts, _):
            return ts
        case let .meta(ts, _):
            return ts
        case let .note(ts, _):
            return ts
        case let .channel(ts, _):
            return ts
        case let .rawData(ts, _):
            return ts
        case let .parameter(ts, _):
            return ts
        case let .auPreset(ts, _):
            return ts
        }
    }
    
    public var data : Data {
        switch self {
        case let .extendedNote(_, data):
            return Data(encode: data)
        case let .extendedTempo(_, data):
            return Data(encode: data)
        case let .user(_, data):
            return Data(encode: data)
        case let .meta(_, data):
            return Data(encode: data)
        case let .note(_, data):
            return Data(encode: data)
        case let .channel(_, data):
            return Data(encode: data)
        case let .rawData(_, data):
            return Data(encode: data)
        case let .parameter(_, data):
            return Data(encode: data)
        case let .auPreset(_, data):
            return Data(encode: data)
        }
    }
    
    public var type : MIDIEventType {
        switch self {
        case .extendedNote:
            return .extendedNote
        case .extendedTempo:
            return .extendedTempo
        case .user:
            return .user
        case .meta:
            return .meta
        case .note:
            return .note
        case .channel:
            return .channel
        case .rawData:
            return .rawData
        case .parameter:
            return .parameter
        case .auPreset:
            return .auPreset
        }
    }
    
    public var hashValue: Int {
        return timestamp.hashValue ^ type.hashValue
    }
    
    public func advanced(by n: Timestamp.Stride) -> MIDIEvent<Timestamp> {
        return MIDIEvent(timestamp: timestamp.advanced(by: n), type: type, data: data)
    }
    
    public func distance(to other: MIDIEvent) -> Timestamp.Stride {
        return timestamp.distance(to: other.timestamp)
    }
    
    public static func ==(lhs: MIDIEvent, rhs: MIDIEvent) -> Bool {
        return lhs.timestamp == rhs.timestamp &&
                lhs.type == rhs.type &&
                lhs.data == rhs.data
    }
    
    public static func <(lhs: MIDIEvent, rhs: MIDIEvent) -> Bool {
        return lhs.timestamp < rhs.timestamp
    }
}

