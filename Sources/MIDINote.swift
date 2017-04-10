//
//  MIDINote.swift
//  KoreMIDI
//
//  Created by Adam Nemecek on 4/7/17.
//
//

import AudioToolbox.MusicPlayer

public struct MIDINote <Element : MIDIEventConvertible>: Equatable, Hashable, CustomStringConvertible, Strideable {
    public typealias Stride = MIDITimestamp.Stride
    
    public let timestamp: MIDITimestamp
    
    internal let _msg: Element
    
    internal init(timestamp: MIDITimestamp, msg: Element) {
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
        return timestamp.hashValue
    }
    
    public var description: String {
        return "timestamp: \(timestamp), duration: \(_msg)"
    }
}

extension MIDINote where Element == MIDINoteMessage {
    public var timerange: Range<MIDITimestamp> {
        return timestamp..<endstamp
    }
    public var endstamp: MIDITimestamp {
        return timestamp + duration
    }

    public var duration: Stride {
        return Stride(_msg.duration)
    }
    
    public var note: UInt8 {
        return _msg.note
    }
}
