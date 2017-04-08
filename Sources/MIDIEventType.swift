//
//  MIDIEventType.swift
//  KoreMIDI
//
//  Created by Adam Nemecek on 4/5/17.
//  Copyright © 2017 Adam Nemecek. All rights reserved.
//

import AudioToolbox.MusicPlayer

public enum MIDIEventType : RawRepresentable {

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

