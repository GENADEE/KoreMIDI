//
//  MIDIEventType.swift
//  KoreMIDI
//
//  Created by Adam Nemecek on 4/5/17.
//  Copyright © 2017 Adam Nemecek. All rights reserved.
//

import AudioToolbox.MusicPlayer


public protocol TimestampType : Comparable, Strideable {
    var beats: MusicTimeStamp { get }
}

extension MIDITimestamp : TimestampType { }

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
        case .note: return .note
        default: fatalError()
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
        case let .note(ts, e):
            fatalError()
        default:
            fatalError()
        }
    }
    
//    var event : MIDIEvent<Timestamp> {
//        switch self {
//        case let .note(ts, e):
//            return MIDIEvent(timestamp: ts, type: .note, data: Data(encode: e))
//        default:
//            fatalError()
//        }
//    }
    
//    public func insert(to track: MIDITrack, at timestamp: MusicTimeStamp) {
//        switch self {
//        case let .note(ts, e):
//            var cpy = e
//            MusicTrackNewMIDINoteEvent(track._impl.ref, at, &e)
//        default: fatalError()midi
//        }
//    }
    
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

public enum MIDIEventType : RawRepresentable, CustomStringConvertible {

    case extendedNote, extendedTempo, user, meta, note, channel, rawData, parameter, auPreset

    public init?(rawValue: MusicEventType) {
        switch rawValue {
//        case kMusicEventType_NULL: fatalError()
        case kMusicEventType_ExtendedNote:
            self = .extendedNote
        case kMusicEventType_ExtendedTempo:
            self = .extendedTempo
            
        case kMusicEventType_User:
            self = .user
        case kMusicEventType_Meta:
            self = .meta
        case kMusicEventType_MIDINoteMessage:
            self = .note
        case kMusicEventType_MIDIChannelMessage:
            self = .channel
        case kMusicEventType_MIDIRawData:
            self = .rawData
        case kMusicEventType_Parameter:
            self = .parameter
        case kMusicEventType_AUPreset:
            self = .auPreset
        default: fatalError()
        }
    }
    
    public var description : String {
        switch self {
        case .extendedNote: return ".extendedNote"
        
        case .note: return ".note"
        default: return "other"
        }
    }
    
    public var rawValue : UInt32 {
        switch self {
        case .extendedNote:
            return kMusicEventType_ExtendedNote
        case .extendedTempo:
            return kMusicEventType_ExtendedTempo
        case .user:
            return kMusicEventType_User
        case .meta:
            return kMusicEventType_Meta
        case .note:
            return kMusicEventType_MIDINoteMessage
        case .channel:
            return kMusicEventType_MIDIChannelMessage
        case .rawData:
            return kMusicEventType_MIDIRawData
        case .parameter:
            return kMusicEventType_Parameter
        case .auPreset:
            return kMusicEventType_AUPreset
        }
    }
    
//    init<T: MIDIEventConvertible>(type: T.Type) {
//        //    let types: [T.Type: ATMIDIType] = [:]
//        //    switch type {
//        //      case MIDIChannelMessage.self: break
//        //      default: break
//        //    }
//        //    switch type {
//        //      case MIDIChannelMessage.self: break
//        //      default: break
//        //    }
//        
//        if type == ExtendedNoteOnEvent.self {
//            self = .extendedNote
//        }
//        else if type == ExtendedTempoEvent.self {
//            self = .extendedTempo
//        }
//        else if type == MusicEventUserData.self {
//            self = .user
//        }
//        else if type == MIDIMetaEvent.self {
//            self = .meta
//        }
//        else if type == MIDINoteMessage.self {
//            self = .note
//        }
//        else if type == MIDIChannelMessage.self {
//            self = .channel
//        }
//        else if type == MIDIRawData.self {
//            self = .rawData
//        }
//        else if type == ParameterEvent.self {
//            self = .parameter
//        }
//        else if type == AUPresetEvent.self {
//            self = .auPreset
//        }
//        else {
//            fatalError()
//        }
//    }
}


//public struct MIDIEventType: OptionSet, Hashable {
//    public let rawValue: UInt32
//
//    public init(rawValue: UInt32) {
//        self.rawValue = rawValue
//    }
//    
//    public static func ==(lhs: MIDIEventType, rhs: MIDIEventType) -> Bool {
//        return lhs.rawValue == rhs.rawValue
//    }
//    
//    public var hashValue: Int {
//        return rawValue.hashValue
//    }
//    
//    public static let extendedNote = MIDIEventType(rawValue: kMusicEventType_ExtendedNote)
//    public static let extendedTempo = MIDIEventType(rawValue: kMusicEventType_ExtendedTempo)
//    public static let user = MIDIEventType(rawValue: kMusicEventType_User)
//    public static let meta = MIDIEventType(rawValue: kMusicEventType_Meta)
//    public static let note = MIDIEventType(rawValue: kMusicEventType_MIDINoteMessage)
//    public static let channel = MIDIEventType(rawValue: kMusicEventType_MIDIChannelMessage)
//    public static let rawData = MIDIEventType(rawValue: kMusicEventType_MIDIRawData)
//    public static let parameter = MIDIEventType(rawValue: kMusicEventType_Parameter)
//    public static let auPreset = MIDIEventType(rawValue: kMusicEventType_AUPreset)
//    public static let none = MIDIEventType(rawValue: kMusicEventType_NULL)
//
//    init<T: MIDIEventConvertible>(type: T.Type) {
//        if type == ExtendedNoteOnEvent.self {
//            self = .extendedNote
//        }
//        else if type == ExtendedTempoEvent.self {
//            self = .extendedTempo
//        }
//        else if type == MusicEventUserData.self {
//            self = .user
//        }
//        else if type == MIDIMetaEvent.self {
//            self = .meta
//        }
//        else if type == MIDINoteMessage.self {
//            self = .note
//        }
//        else if type == MIDIChannelMessage.self {
//            self = .channel
//        }
//        else if type == MIDIRawData.self {
//            self = .rawData
//        }
//        else if type == ParameterEvent.self {
//            self = .parameter
//        }
//        else if type == AUPresetEvent.self {
//            self = .auPreset
//        }
////        else if type == MIDIEvent.self {
////            self = .none
////        }
//        else {
//            fatalError()
//        }
//    }
//}
