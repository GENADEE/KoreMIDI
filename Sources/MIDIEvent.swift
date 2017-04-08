//
//  MIDIEvent.swift
//  KoreMIDI
//
//  Created by Adam Nemecek on 4/8/17.
//
//

import Foundation
import AudioToolbox

struct MIDIEvent {
    let timestamp: MusicTimeStamp
    let type: MIDIEventType
    let data: Data
}
