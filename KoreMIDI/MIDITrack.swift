//
//  MIDITrack.swift
//  KoreMIDI
//
//  Created by Adam Nemecek on 4/5/17.
//  Copyright © 2017 Adam Nemecek. All rights reserved.
//

import Foundation
import AudioToolbox

struct MIDITrack : Sequence {
    typealias Element = Int
    typealias Timestamp = Double
    
    internal let ref : MusicTrack
    
    init() {
        ref = MIDISequenceCreate()
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
    
    var offsetTime : Int {
        get {
            return self[kSequenceTrackProperty_OffsetTime]
        }
        set {
            self[kSequenceTrackProperty_OffsetTime] = newValue
        }
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
    
    var length : Int {
        get {
            return self[kSequenceTrackProperty_TrackLength]
        }
        set {
            self[kSequenceTrackProperty_TrackLength] = newValue
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
    
    func makeIterator() -> AnyIterator<MIDIEvent> {
        fatalError()
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
        switch type(of: event).type {
        //            case let msg =
        case .note:
            fatalError()
        default: fatalError()
        }
    }
    
    mutating func remove<S : Sequence>() where S.Iterator.Element == Int {
        fatalError()
        
    }
    
    mutating func remove(_ timerange: ClosedRange<Timestamp>) {
        fatalError()
    }
}
