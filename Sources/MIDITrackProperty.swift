//
//  MIDITrackProperty.swift
//  KoreMIDI
//
//  Created by Adam Nemecek on 4/7/17.
//  Copyright © 2017 Adam Nemecek. All rights reserved.
//

import Foundation
import AudioToolbox.MusicPlayer

internal enum MIDITrackProp : RawRepresentable {
    
    case loopInfo, offsetTime, muted, soloed, automatedParams, length, resolution
    
    public init?(rawValue: UInt32) {
        switch rawValue {
        case kSequenceTrackProperty_LoopInfo: self = .loopInfo
        case kSequenceTrackProperty_OffsetTime: self = .offsetTime
        case kSequenceTrackProperty_MuteStatus: self = .muted
        case kSequenceTrackProperty_SoloStatus: self = .soloed
        case kSequenceTrackProperty_AutomatedParameters: self = .automatedParams
        case kSequenceTrackProperty_TrackLength: self = .length
        case kSequenceTrackProperty_TimeResolution: self = .resolution
        default: fatalError()
        }
    }
    
    public var rawValue : UInt32 {
        switch self {
        case .loopInfo: return kSequenceTrackProperty_LoopInfo
        case .offsetTime: return kSequenceTrackProperty_OffsetTime
        case .muted: return kSequenceTrackProperty_MuteStatus
        case .soloed: return kSequenceTrackProperty_SoloStatus
        case .automatedParams: return kSequenceTrackProperty_AutomatedParameters
        case .length: return kSequenceTrackProperty_TrackLength
        case .resolution: return kSequenceTrackProperty_TimeResolution
        }
    }
    

}
