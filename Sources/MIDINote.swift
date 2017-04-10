//
//  MIDINote.swift
//  KoreMIDI
//
//  Created by Adam Nemecek on 4/7/17.
//
//

import AudioToolbox.MusicPlayer

public struct MIDINote : Equatable, Hashable, CustomStringConvertible, Strideable {
    public typealias Stride = MIDITimestamp.Stride
    
    public let note: UInt8
    public let timestamp: MIDITimestamp

    public let duration: Stride
    
//    private weak let parent : MIDITrackImpl?

    public var endstamp: MIDITimestamp {
        return timestamp + duration
    }
    
    public var timerange: Range<MIDITimestamp> {
        return timestamp..<endstamp
    }
    
    internal init(timestamp: MIDITimestamp, msg: MIDINoteMessage) {
        self.timestamp = timestamp
        self.note = msg.note
        self.duration = Stride(msg.duration)
    }
    
    public func advanced(by n: Stride) -> MIDINote {
        fatalError()
    }
    
    public func distance(to other: MIDINote) -> Stride {
        fatalError()
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
