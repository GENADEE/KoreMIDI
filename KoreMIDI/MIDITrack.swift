//
//  MIDITrack.swift
//  KoreMIDI
//
//  Created by Adam Nemecek on 4/5/17.
//  Copyright © 2017 Adam Nemecek. All rights reserved.
//

import Foundation
import AudioToolbox

public struct MIDITrack : Sequence, CustomStringConvertible {
    public typealias Iterator = MIDITrackIterator
    public typealias Element = Iterator.Element
    
    internal let ref : MusicTrack
    internal let parent: MIDISequence
    
    public init(seq: MIDISequence) {
        ref = MIDITrackCreate(ref: seq.ref)
        parent = seq
    }
    
    public init(seq: MIDISequence, no: Int) {
        ref = MusicSequenceGetIndTrack(ref: seq.ref, no: no)
        parent = seq
    }
    
    public var timerange: ClosedRange<MIDITimestamp> {
        return startTime...endTime
    }
    
    //    deinit {
    //
    //    }
    
    public var description: String {
        var opts: [String] = []
        if soloed {
            opts.append("soloed")
        }
        
        if muted {
            opts.append("muted")
        }
        
        return "MIDITrack(in:\(timerange), \(opts))"
    }
    
    public var offsetTime : Int {
        get {
            return self[kSequenceTrackProperty_OffsetTime]
        }
        set {
            self[kSequenceTrackProperty_OffsetTime] = newValue
        }
    }
    
    public var duration : Int {
        get {
            return self[kSequenceTrackProperty_TrackLength]
        }
        set {
            self[kSequenceTrackProperty_TrackLength] = newValue
        }
    }
    
    public var startTime : MIDITimestamp {
        return MIDITimestamp(base: parent, beats: MusicTimeStamp(offsetTime))
    }
    
    public var endTime : MIDITimestamp {
        return startTime.advanced(by: MusicTimeStamp(duration))
    }

    public var loopInfo : Int {
        get {
            return self[kSequenceTrackProperty_LoopInfo]
        }
        set {
            self[kSequenceTrackProperty_LoopInfo] = newValue
        }
    }

    public var muted : Bool {
        get {
            return Bool(self[kSequenceTrackProperty_MuteStatus])
        }
        set {
            self[kSequenceTrackProperty_MuteStatus] = Int(newValue)
        }
    }
    
    public var soloed : Bool {
        get {
            return Bool(self[kSequenceTrackProperty_SoloStatus])
        }
        set {
            self[kSequenceTrackProperty_SoloStatus] = Int(newValue)
        }
    }
    
    public var automatedParameters : Bool {
        get {
            return Bool(self[kSequenceTrackProperty_AutomatedParameters])
        }
        set {
            self[kSequenceTrackProperty_AutomatedParameters] = Int(newValue)
        }
    }
    
    public var timeResolution : Int {
        get {
            return self[kSequenceTrackProperty_TimeResolution]
        }
        set {
            self[kSequenceTrackProperty_TimeResolution] = newValue
        }
    }
    
    public func makeIterator() -> Iterator {
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
    func move(_ timerange: ClosedRange<MIDITimestamp>, to timestamp: MIDITimestamp) {
        MusicTrackMoveEvents(ref,
                             timerange.lowerBound.beats,
                             timerange.upperBound.beats,
                             timestamp.beats)
    }
    
    mutating
    func clear(_ timerange: ClosedRange<MIDITimestamp>) {
        MusicTrackClear(ref,
                        timerange.lowerBound.beats,
                        timerange.upperBound.beats)
    }
    
    mutating
    func cut(_ timerange: ClosedRange<MIDITimestamp>) {
        MusicTrackCut(ref,
                      timerange.lowerBound.beats,
                      timerange.upperBound.beats)
    }
    
    mutating
    func copyInsert(from other: MIDITrack, in timerange: ClosedRange<MIDITimestamp>, at timestamp: MIDITimestamp) {
        MusicTrackCopyInsert(ref,
                             timerange.lowerBound.beats,
                             timerange.upperBound.beats,
                             other.ref,
                             timestamp.beats)
    }
    
    mutating
    func merge(with other: MIDITrack, in timerange: ClosedRange<MIDITimestamp>, at timestamp: MIDITimestamp) {
        MusicTrackMerge(ref,
                        timerange.lowerBound.beats,
                        timerange.upperBound.beats,
                        other.ref,
                        timestamp.beats)
    }
    
    mutating
    func add(_ event: MIDIEvent, at timestamp: MIDITimestamp) {

        event.add(to: self, at: timestamp)
    }
    
    mutating func remove<S : Sequence>() where S.Iterator.Element == Element {
        fatalError()
        
    }
    
    mutating func remove(_ timerange: ClosedRange<MIDITimestamp>) {
        fatalError()
    }
}
