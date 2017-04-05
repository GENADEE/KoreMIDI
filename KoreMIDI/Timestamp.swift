//
//  Timestamp.swift
//  KoreMIDI
//
//  Created by Adam Nemecek on 4/5/17.
//  Copyright © 2017 Adam Nemecek. All rights reserved.
//

import Foundation
import AudioToolbox

extension CABarBeatTime : CustomStringConvertible {
    public var description : String {
        return "bar: \(bar), beat: \(beat), subbeat: \(subbeat), subbeatDivisor: \(subbeatDivisor)"
    }
}

struct Timestamp : Comparable, Hashable, Strideable, CustomStringConvertible {
    typealias Base = MIDISequence
    
    typealias Stride = MusicTimeStamp

    let beats : MusicTimeStamp
    private let base : Base
    
    var seconds: Float64 {
        return MusicSequenceBeatsToSeconds(ref: base.ref, beats: beats)
    }

    init(base: Base, beats: MusicTimeStamp) {
        self.base = base
        self.beats = beats
    }
    
    init(base: Base, beats: CABarBeatTime) {
//        self.base = base
//        self.beats = beats
        fatalError()
    }
    
    var description: String {
        return "Timestamp(\(beats))"
    }
    
    static func ==(lhs: Timestamp, rhs: Timestamp) -> Bool {
        assert(lhs.base == rhs.base)
        return lhs.beats == rhs.beats
    }
    
    static func <(lhs: Timestamp, rhs: Timestamp) -> Bool {
        assert(lhs.base == rhs.base)
        return lhs.beats < rhs.beats
    }
    
    var hashValue: Int {
        return beats.hashValue
    }
    
    func beatTime(for subdivisor: UInt32 = 4) -> CABarBeatTime {
        var t = CABarBeatTime()
        MusicSequenceBeatsToBarBeatTime(base.ref, beats, subdivisor, &t)
        return t
    }
    
    func advanced(by n: Stride) -> Timestamp {
        return Timestamp(base: base, beats: beats + n)
    }
    
    func distance(to other: Timestamp) -> Stride {
        return other.beats - beats
    }
    
    static func +(lhs: Timestamp, rhs: Timestamp) -> Timestamp {
        assert(lhs.base == rhs.base)
        return Timestamp(base: lhs.base, beats: lhs.beats + rhs.beats)
    }
    
    static prefix func -(_ value: Timestamp) -> Timestamp {
        return Timestamp(base: value.base, beats: -value.beats)
    }
    
    static func -(lhs: Timestamp, rhs: Timestamp) -> Timestamp {
        return lhs + (-rhs)
    }
}

//public func MusicSequenceBeatsToBarBeatTime(_ inSequence: MusicSequence, _ inBeats: MusicTimeStamp, _ inSubbeatDivisor: UInt32, _) -> CABarBeatTime {
//    
//}
