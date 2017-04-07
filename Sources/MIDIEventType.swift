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
}
