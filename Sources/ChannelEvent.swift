//
//  ChannelEvent.swift
//  KoreMIDI
//
//  Created by Adam Nemecek on 2/1/18.
//

import Foundation

enum ChannelEvent2 {
    case Aftertouch(channel: UInt8, key: UInt8, pressure: UInt8)
    case ControlChange(channel: UInt8, controller: UInt8, value: UInt8)
    case ProgramChange(channel: UInt8, programNumber: UInt8)
    case ChannelPressure(channel: UInt8, pressure: UInt8)
    case PitchBend(channel: UInt8, pitch: UInt16)

}
