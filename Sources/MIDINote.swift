//
//  MIDINote.swift
//  KoreMIDI
//
//  Created by Adam Nemecek on 4/7/17.
//
//

import AudioToolbox.MusicPlayer

public struct MIDINote: Equatable, Hashable, CustomStringConvertible, Strideable {
    public typealias Timestamp = MIDITimestamp
    public typealias Stride = Timestamp.Stride
    
    public let timestamp: Timestamp
    
    internal let _msg: MIDINoteMessage
    
    internal init(timestamp: Timestamp, msg: MIDINoteMessage) {
        self.timestamp = timestamp
        self._msg = msg
    }
    
    public func advanced(by n: Stride) -> MIDINote {
        return MIDINote(timestamp: timestamp.advanced(by: n), msg: _msg)
    }
    
    public func distance(to other: MIDINote) -> Stride {
        return timestamp.distance(to: other.timestamp)
    }
    
    public static func ==(lhs: MIDINote, rhs: MIDINote) -> Bool {
        return lhs.timestamp == rhs.timestamp && lhs._msg == rhs._msg
    }
    
    public var hashValue: Int {
        return timestamp.hashValue ^ _msg.hashValue
    }
    
    public var description: String {
        return "timestamp: \(timestamp), duration: \(_msg)"
    }
}

//extension MIDINote where Element == MIDINoteMessage {
//    public var timerange: Range<Timestamp> {
//        return timestamp..<endstamp
//    }
//    public var endstamp: Timestamp {
//        return timestamp + duration
//    }
//
//    public var duration: Stride {
//        return Stride(_msg.duration)
//    }
//    
//    public var note: UInt8 {
//        return _msg.note
//    }
//}
