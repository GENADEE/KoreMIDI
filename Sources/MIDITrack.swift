//
//  MIDITrack.swift
//  KoreMIDI
//
//  Created by Adam Nemecek on 4/5/17.
//  Copyright © 2017 Adam Nemecek. All rights reserved.
//

import Foundation
import AudioToolbox.MusicPlayer

public struct MIDITrack : Sequence, Equatable, Hashable, CustomStringConvertible {
    public typealias Iterator = MIDITrackIterator
    public typealias Element = Iterator.Element
    
    internal let ref : MusicTrack
    internal let parent: MIDISequence
    
    public init(seq: MIDISequence) {
        ref = MIDITrackCreate(ref: seq.ref)
        parent = seq
    }
    
    internal init(seq: MIDISequence, no: Int) {
        ref = MusicSequenceGetIndTrack(ref: seq.ref, no: no)
        parent = seq
    }
    
    public var timerange: ClosedRange<MIDITimestamp> {
        return startTime...endTime
    }
    
    public static func ==(lhs: MIDITrack, rhs: MIDITrack) -> Bool {
        return lhs.ref == rhs.ref || lhs.elementsEqual(rhs) {
            $0.timestamp == $1.timestamp && $0.event == $1.event
        }
    }
    
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

    public var startTime : MIDITimestamp {
        return MIDITimestamp(base: parent, beats: MusicTimeStamp(offsetTime))
    }
    
    public var endTime : MIDITimestamp {
        return startTime.advanced(by: MusicTimeStamp(duration))
    }
    
    public var hashValue: Int {
        return ref.hashValue
    }

    public var offsetTime : Int {
        get {
            return self[.offsetTime]
        }
        set {
            self[.offsetTime] = newValue
        }
    }
    
    public var duration : Int {
        get {
            return self[.length]
        }
        set {
            self[.length] = newValue
        }
    }

    public var loopInfo : Int {
        get {
            return self[.loopInfo]
        }
        set {
            self[.loopInfo] = newValue
        }
    }

    public var muted : Bool {
        get {
            return Bool(self[.muted])
        }
        set {
            self[.muted] = Int(newValue)
        }
    }
    
    public var soloed : Bool {
        get {
            return Bool(self[.soloed])
        }
        set {
            self[.soloed] = Int(newValue)
        }
    }
    
    public var automatedParameters : Bool {
        get {
            return Bool(self[.automatedParams])
        }
        set {
            self[.automatedParams] = Int(newValue)
        }
    }
    
    public var timeResolution : Int {
        get {
            return self[.resolution]
        }
        set {
            self[.resolution] = newValue
        }
    }
    
    public func makeIterator() -> Iterator {
        return MIDITrackIterator(self)
    }
    
    
    private subscript(prop: MIDITrackProp) -> Int {
        get {
            return MIDITrackGetProperty(ref: ref, prop: prop.rawValue)
        }
        set {
            MIDITrackSetProperty(ref: ref, prop: prop.rawValue, to: newValue)
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
    
    mutating func remove<S : Sequence>(_ elements: S) where S.Iterator.Element == Element {
//        remove(÷
        fatalError()
    }
    
    mutating func remove(_ timerange: ClosedRange<MIDITimestamp>) {
        fatalError()
    }
}
