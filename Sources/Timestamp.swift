//
//  MIDITimestamp.swift
//  KoreMIDI
//
//  Created by Adam Nemecek on 4/5/17.
//  Copyright © 2017 Adam Nemecek. All rights reserved.
//

import Foundation
import AudioToolbox.MusicPlayer

public struct MIDITimestamp : Comparable, Hashable, Strideable, CustomStringConvertible {
    internal typealias Base = MIDISequenceRef
    
    public typealias Stride = MusicTimeStamp

    public let beats : MusicTimeStamp
    private let base : Base
    
    var seconds: Float64 {
        return MusicSequenceBeatsToSeconds(ref: base.ref, beats: beats)
    }

    internal init(base: Base, beats: MusicTimeStamp) {
        self.base = base
        self.beats = beats
    }
    
    internal init(base: Base, beats: CABarBeatTime) {
//        self.base = base
//        self.beats = beats
        fatalError()
    }
    
    public var description: String {
        return "\(beatTime())"
    }
    
    public static func ==(lhs: MIDITimestamp, rhs: MIDITimestamp) -> Bool {
        assert(lhs.base == rhs.base)
        return lhs.beats == rhs.beats
    }
    
    public static func <(lhs: MIDITimestamp, rhs: MIDITimestamp) -> Bool {
        assert(lhs.base == rhs.base)
        return lhs.beats < rhs.beats
    }
    
    public var hashValue: Int {
        return beats.hashValue
    }
    
    public func beatTime(for subdivisor: UInt32 = 4) -> CABarBeatTime {
        return MusicSequenceBeatsToBarBeatTime(ref: base.ref, beats: beats, subdivisor: subdivisor)
    }
    
    public func advanced(by n: Stride) -> MIDITimestamp {
        return MIDITimestamp(base: base, beats: beats + n)
    }
    
    public func distance(to other: MIDITimestamp) -> Stride {
        return other.beats - beats
    }
    
    public static func +(lhs: MIDITimestamp, rhs: MIDITimestamp) -> MIDITimestamp {
        assert(lhs.base == rhs.base)
        return MIDITimestamp(base: lhs.base, beats: lhs.beats + rhs.beats)
    }
    
    public static prefix func -(_ value: MIDITimestamp) -> MIDITimestamp {
        return MIDITimestamp(base: value.base, beats: -value.beats)
    }
    
    public static func -(lhs: MIDITimestamp, rhs: MIDITimestamp) -> MIDITimestamp {
        return lhs + (-rhs)
    }
}

