//
//  MIDITimestamp.swift
//  KoreMIDI
//
//  Created by Adam Nemecek on 4/5/17.
//  Copyright © 2017 Adam Nemecek. All rights reserved.
//

import Foundation
import AudioToolbox.MusicPlayer

protocol DefaultConstructible {
    init()
    
}


protocol HasExtrema : DefaultConstructible {
    static var min: Self { get }
    static var max: Self { get }
}
/*
public struct MIDITimestamp : Comparable, Hashable, Strideable, CustomStringConvertible {
    internal typealias Base = MIDISequenceImpl
    public typealias Stride = MusicTimeStamp

    public let beats : MusicTimeStamp
//    private weak var base : Base! = nil
    
//    var seconds: Float64 {
//        return MusicSequenceBeatsToSeconds(ref: base.ref, beats: beats)
//    }

//    internal init(base: Base, beats: MusicTimeStamp) {
////        self.base = base
//        self.beats = beats
//    }
//    
//    internal init(base: Base, beats: CABarBeatTime) {
////        self.base = base
////        self.beats = beats
//        fatalError()
//    }
    
    internal init(beats: MusicTimeStamp) {
        self.beats = beats
    }

    public var description: String {
        return "\(beats)"
    }
    
    public static func ==(lhs: MIDITimestamp, rhs: MIDITimestamp) -> Bool {
//        assert(lhs.base == rhs.base)
        return lhs.beats == rhs.beats
    }
    
    public static func <(lhs: MIDITimestamp, rhs: MIDITimestamp) -> Bool {
//        assert(lhs.base == rhs.base)
        return lhs.beats < rhs.beats
    }
    
    public var hashValue: Int {
        return beats.hashValue
    }
    
//    public func beatTime(for subdivisor: UInt32 = 4) -> CABarBeatTime {
//        return MusicSequenceBeatsToBarBeatTime(ref: base.ref, beats: beats, subdivisor: subdivisor)
//    }
    
    public func advanced(by n: Stride) -> MIDITimestamp {
        return MIDITimestamp(beats: beats + n)
    }
    
    public func distance(to other: MIDITimestamp) -> Stride {
        return other.beats - beats
    }
    
    public static func +(lhs: MIDITimestamp, rhs: MIDITimestamp) -> MIDITimestamp {
//        assert(lhs.base == rhs.base)
        return MIDITimestamp(beats: lhs.beats + rhs.beats)
    }
    
    public static prefix func -(_ value: MIDITimestamp) -> MIDITimestamp {
        return MIDITimestamp(beats: -value.beats)
    }
    
    public static func -(lhs: MIDITimestamp, rhs: MIDITimestamp) -> MIDITimestamp {
        return lhs + (-rhs)
    }
}*/

