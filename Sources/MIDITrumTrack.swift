//
//  MIDITrumTrack.swift
//  KoreMIDI
//
//  Created by Adam Nemecek on 4/3/18.
//

import Foundation


public struct MIDIDrumEvent {
    public typealias Timestamp = MIDITimestamp
}


class MIDIDrumTrack {
    public typealias Timestamp = MIDITimestamp
    public let timestamp: Timestamp

    internal init(timestamp: Timestamp, drum: Int8) {
        fatalError()
    }
}
