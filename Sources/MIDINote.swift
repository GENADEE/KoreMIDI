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
         return Stride(msg.duration)
    }
    
    private let msg: MIDINoteMessage
        
    public var note: UInt8 {
        return msg.note
    }

    public var endstamp: MIDITimestamp {
        return timestamp + duration
    }
    
    public var timerange: Range<MIDITimestamp> {
        return timestamp..<endstamp
    }
    
    internal init(timestamp: MIDITimestamp, msg: MIDINoteMessage) {
        self.timestamp = timestamp
        self.msg = msg
       
    }
    
    public func advanced(by n: Stride) -> MIDINote {
//        MIDINote(timestamp: timestamp, msg: <#T##MIDINoteMessage#>)
//        var cp = self
//        cp.timestamp = cp.timestamp.advanced(by: n)
//        return cp
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
