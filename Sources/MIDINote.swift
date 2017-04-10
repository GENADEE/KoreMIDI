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
    
    public let timestamp: MIDITimestamp

    public var duration: Stride {
         return Stride(_msg.duration)
    }
    
    private let _msg: MIDINoteMessage
        
    public var note: UInt8 {
        return _msg.note
    }

    public var endstamp: MIDITimestamp {
        return timestamp + duration
    }
    
    public var timerange: Range<MIDITimestamp> {
        return timestamp..<endstamp
    }
    
    internal init(timestamp: MIDITimestamp, msg: MIDINoteMessage) {
        self.timestamp = timestamp
        self._msg = msg
    }
    
    public func advanced(by n: Stride) -> MIDINote {
        return MIDINote(timestamp: timestamp.advanced(by: n), msg: _msg)
    }
    
    public func distance(to other: MIDINote) -> Stride {
        fatalError()
    }
    
    public static func ==(lhs: MIDINote, rhs: MIDINote) -> Bool {
        return lhs.timestamp == rhs.timestamp && lhs._msg == rhs._msg
    }
    
    public var hashValue: Int {
        return note.hashValue
    }
    
    public var description: String {
        return "note: \(note), timestamp: \(timestamp), duration: \(duration)"
    }
}
