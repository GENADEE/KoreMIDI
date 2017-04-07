//
//  MIDIEventType.swift
//  KoreMIDI
//
//  Created by Adam Nemecek on 4/5/17.
//  Copyright © 2017 Adam Nemecek. All rights reserved.
//

import Foundation
import AudioToolbox

enum MIDIEventType : RawRepresentable {
    /// Creates a new instance with the specified raw value.
    ///
    /// If there is no value of the type that corresponds with the specified raw
    /// value, this initializer returns `nil`. For example:
    ///
    ///     enum PaperSize: String {
    ///         case A4, A5, Letter, Legal
    ///     }
    ///
    ///     print(PaperSize(rawValue: "Legal"))
    ///     // Prints "Optional("PaperSize.Legal")"
    ///
    ///     print(PaperSize(rawValue: "Tabloid"))
    ///     // Prints "nil"
    ///
    /// - Parameter rawValue: The raw value to use for the new instance.
    
    case extendedNote, extendedTempo, user, meta, note, channel, rawData, parameter, auPreset
    init?(rawValue: MusicEventType) {
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
    
    var rawValue : UInt32 {
        switch self {
        case .note :
            return kMusicEventType_ExtendedNote
        default: fatalError()
        }
    }
}
