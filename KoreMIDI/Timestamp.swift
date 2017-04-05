//
//  Timestamp.swift
//  KoreMIDI
//
//  Created by Adam Nemecek on 4/5/17.
//  Copyright © 2017 Adam Nemecek. All rights reserved.
//

import Foundation
import AudioToolbox

struct Timestamp : Comparable, Hashable {
    let beats : MusicTimeStamp
    typealias Base = MIDISequence
    
    let base : UnsafePointer<Base>
    
    init(base: UnsafePointer<Base>, beats: MusicTimeStamp) {
        fatalError()
    }
    
    static func ==(lhs: Timestamp, rhs: Timestamp) -> Bool {
        return lhs.beats == rhs.beats
    }
    
    static func <(lhs: Timestamp, rhs: Timestamp) -> Bool {
        return lhs.beats < rhs.beats
    }
    
    var hashValue: Int {
        return beats.hashValue
    }
    
    static func +(lhs: Timestamp, rhs: Timestamp) -> Timestamp {
        assert(lhs.base == rhs.base)
        return Timestamp(base: lhs.base, beats: lhs.beats + rhs.beats)
    }
    
    static func -(lhs: Timestamp, rhs: Timestamp) -> Timestamp {
        return Timestamp(base: lhs.base, beats: lhs.beats - rhs.beats)
    }
}
