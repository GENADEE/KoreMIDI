//
//  AudioToolbox.swift
//  KoreMIDI
//
//  Created by Adam Nemecek on 4/5/17.
//  Copyright © 2017 Adam Nemecek. All rights reserved.
//

import Foundation
import AudioToolbox

@inline(__always)
internal func MIDITrackGetProperty(ref: MusicTrack, prop: UInt32) -> Int {
    var data: UInt32 = 0
    var len : UInt32 = 0
    MusicTrackGetProperty(ref, prop, &data, &len)
    return Int(data)
}

@inline(__always)
internal func MIDITrackSetProperty(ref: MusicTrack, prop: UInt32, to: Int) {
    var data = UInt32(to)
    MusicTrackSetProperty(ref, prop, &data, UInt32(MemoryLayout<UInt32>.size))
    
}

@inline(__always)
internal func MIDISequenceCreate() -> MusicSequence {
    var ref : MusicSequence? = nil
    NewMusicSequence(&ref)
    return ref!
}

@inline(__always)
internal func MIDITrackCreate(ref: MusicSequence) -> MusicTrack {
    fatalError()
}

internal func MIDISequenceLoad(path: String) -> MusicSequence {
    fatalError()
}

func MIDIIteratorCreate(ref: MusicTrack) -> MusicEventIterator {
    var r: MusicEventIterator? = nil
    NewMusicEventIterator(ref, &r)
    return r!
}

protocol MIDIEvent {
    
    static var type : MIDIEventType { get }
    func add(to: MIDITrack, at timestamp: Double)
}


extension MIDINoteMessage : MIDIEvent, Hashable {
    static var type : MIDIEventType {
        return .note
    }
    
    func add(to track: MIDITrack, at timestamp: Double) {
        var cpy = self
        MusicTrackNewMIDINoteEvent(track.ref, timestamp, &cpy)
    }
    
    public static func ==(lhs: MIDINoteMessage, rhs: MIDINoteMessage) -> Bool {
        fatalError()
    }
    
    public var hashValue: Int {
        fatalError()
    }
}
//
//extension MIDIChannelMessage : MIDIEventType {
////    static var type: 
//}

