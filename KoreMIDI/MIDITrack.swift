//
//  MIDITrack.swift
//  KoreMIDI
//
//  Created by Adam Nemecek on 4/5/17.
//  Copyright © 2017 Adam Nemecek. All rights reserved.
//

import Foundation
import AudioToolbox

@inline(__always)
func MusicSequenceGetIndTrack(ref: MusicSequence, no: Int) -> MusicTrack {
    var r : MusicTrack? = nil
    MusicSequenceGetIndTrack(ref, UInt32(no), &r)
    return r!
}

struct MIDITrack : Sequence {
    typealias Iterator = MIDITrackIterator
    typealias Element = Iterator.Element
    typealias Timestamp = Iterator.Timestamp
    
    internal let ref : MusicTrack
    
    init(seq: MIDISequence) {
        ref = MIDITrackCreate(ref: seq.ref)
    }
    
    init(seq: MIDISequence, no: Int) {
        ref = MusicSequenceGetIndTrack(ref: seq.ref, no: no)
    }
    
    var timerange: ClosedRange<Timestamp> {
        return Timestamp(startTime)...Timestamp(endTime)
    }
    
    //    deinit {
    //
    //    }
    
    var loopInfo : Int {
        get {
            return self[kSequenceTrackProperty_LoopInfo]
        }
        set {
            self[kSequenceTrackProperty_LoopInfo] = newValue
        }
    }
    
    var startTime : Int {
        get {
            return self[kSequenceTrackProperty_OffsetTime]
        }
        set {
            self[kSequenceTrackProperty_OffsetTime] = newValue
        }
    }
    
    var duration : Int {
        get {
            return self[kSequenceTrackProperty_TrackLength]
        }
        set {
            self[kSequenceTrackProperty_TrackLength] = newValue
        }
    }
    
    var endTime : Int {
        return startTime + duration
    }

    var muted : Bool {
        get {
            return Bool(self[kSequenceTrackProperty_MuteStatus])
        }
        set {
            self[kSequenceTrackProperty_MuteStatus] = Int(newValue)
        }
    }
    
    var soloed : Bool {
        get {
            return Bool(self[kSequenceTrackProperty_SoloStatus])
        }
        set {
            self[kSequenceTrackProperty_SoloStatus] = Int(newValue)
        }
    }
    
    var automatedParameters : Bool {
        get {
            return Bool(self[kSequenceTrackProperty_AutomatedParameters])
        }
        set {
            self[kSequenceTrackProperty_AutomatedParameters] = Int(newValue)
        }
    }

    
    var timeResolution : Int {
        get {
            return self[kSequenceTrackProperty_TimeResolution]
        }
        set {
            self[kSequenceTrackProperty_TimeResolution] = newValue
        }
    }
    
    func makeIterator() -> Iterator {
        return MIDITrackIterator(self)
    }
    
    private subscript(prop: UInt32) -> Int {
        get {
            return MIDITrackGetProperty(ref: ref, prop: prop)
        }
        set {
            MIDITrackSetProperty(ref: ref, prop: prop, to: newValue)
        }
    }
    
    mutating
    func move(_ timerange: ClosedRange<Timestamp>, to timestamp: Timestamp) {
        MusicTrackMoveEvents(ref, timerange.lowerBound, timerange.upperBound, timestamp)
    }
    
    mutating
    func clear(_ timerange: ClosedRange<Timestamp>) {
        MusicTrackClear(ref, timerange.lowerBound, timerange.upperBound)
    }
    
    mutating
    func cut(_ timerange: ClosedRange<Timestamp>) {
        MusicTrackCut(ref, timerange.lowerBound, timerange.upperBound)
    }
    
    mutating
    func copyInsert(from other: MIDITrack, in timerange: ClosedRange<Timestamp>, at timestamp: Timestamp) {
        MusicTrackCopyInsert(ref, timerange.lowerBound, timerange.upperBound, other.ref, timestamp)
    }
    
    mutating
    func merge(with other: MIDITrack, in timerange: ClosedRange<Timestamp>, at timestamp: Timestamp) {
        MusicTrackMerge(ref, timerange.lowerBound, timerange.upperBound, other.ref, timestamp)
    }
    
    mutating
    func add(_ event: MIDIEvent, at timestamp: Timestamp) {

        event.add(to: self, at: timestamp)
    }
    
    mutating func remove<S : Sequence>() where S.Iterator.Element == Int {
        fatalError()
        
    }
    
    mutating func remove(_ timerange: ClosedRange<Timestamp>) {
        fatalError()
    }
}
