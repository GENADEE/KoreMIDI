//
//  MIDIEventType.swift
//  KoreMIDI
//
//  Created by Adam Nemecek on 4/5/17.
//  Copyright © 2017 Adam Nemecek. All rights reserved.
//

import AudioToolbox.MusicPlayer



public enum MIDIEventType : RawRepresentable, CustomStringConvertible {

    case extendedNote, extendedTempo, user, meta, note, channel, rawData, parameter, auPreset

    public init?(rawValue: MusicEventType) {
        switch rawValue {
//        case kMusicEventType_NULL: fatalError()
        case kMusicEventType_ExtendedNote: self = .extendedNote
        case kMusicEventType_ExtendedTempo: fatalError()
        case kMusicEventType_User: fatalError()
        case kMusicEventType_Meta: fatalError()
        case kMusicEventType_MIDINoteMessage: self = .note
        case kMusicEventType_MIDIChannelMessage: fatalError()
        case kMusicEventType_MIDIRawData: fatalError()
        case kMusicEventType_Parameter: fatalError()
        case kMusicEventType_AUPreset: fatalError()
        default: fatalError()
        }
    }
    
    public var description : String {
        switch self {
        case .extendedNote: return ".extendedNote"
        case .note: return ".note"
        default: fatalError()
        }
    }
    
    public var rawValue : UInt32 {
        switch self {
        case .note :
            return kMusicEventType_ExtendedNote
        default: fatalError()
        }
    }
    
    init<T: MIDIEventConvertible>(type: T.Type) {
        //    let types: [T.Type: ATMIDIType] = [:]
        //    switch type {
        //      case MIDIChannelMessage.self: break
        //      default: break
        //    }
        //    switch type {
        //      case MIDIChannelMessage.self: break
        //      default: break
        //    }
        
        if type == ExtendedNoteOnEvent.self {
            self = .extendedNote
        }
        else if type == ExtendedTempoEvent.self {
            self = .extendedTempo
        }
        else if type == MusicEventUserData.self {
            self = .user
        }
        else if type == MIDIMetaEvent.self {
            self = .meta
        }
        else if type == MIDINoteMessage.self {
            self = .note
        }
        else if type == MIDIChannelMessage.self {
            self = .channel
        }
        else if type == MIDIRawData.self {
            self = .rawData
        }
        else if type == ParameterEvent.self {
            self = .parameter
        }
        else if type == AUPresetEvent.self {
            self = .auPreset
        }
        else {
            fatalError()
        }
    }
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
