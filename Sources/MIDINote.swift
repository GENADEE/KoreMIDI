//
//  MIDINote.swift
//  KoreMIDI
//
//  Created by Adam Nemecek on 4/7/17.
//
//

import AudioToolbox.MusicPlayer

public struct MIDINote : Equatable, Hashable, CustomStringConvertible {
    let note: UInt8
    let timestamp: MIDITimestamp
    
    let duration: Float32
    
//    private weak let parent : MIDITrackImpl?

    var endstamp: MIDITimestamp {
        return timestamp.advanced(by: MIDITimestamp.Stride(duration))
    }
    
    var timerange: ClosedRange<MIDITimestamp> {
        return timestamp...endstamp
    }
    
    internal init(timestamp: MIDITimestamp, msg: MIDINoteMessage) {
        self.timestamp = timestamp
        self.note = msg.note
        self.duration = msg.duration
    }
    
    public static func ==(lhs: MIDINote, rhs: MIDINote) -> Bool {
        return lhs.note == rhs.note && lhs.timestamp == rhs.timestamp && lhs.duration == rhs.duration
    }
    
    public var hashValue: Int {
        return note.hashValue
    }
    
    public var description: String {
        return "note: \(note), timestamp: \(timestamp), duration: \(duration)"
    }
}
