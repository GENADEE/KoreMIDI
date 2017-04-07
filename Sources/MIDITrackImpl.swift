//
//  MIDITrack.swift
//  KoreMIDI
//
//  Created by Adam Nemecek on 4/5/17.
//  Copyright © 2017 Adam Nemecek. All rights reserved.
//

import Foundation
import AudioToolbox.MusicPlayer

internal final class MIDITrackImpl : Sequence, Equatable, Hashable, CustomStringConvertible {
    internal typealias Iterator = MIDITrackIterator
    internal typealias Element = Iterator.Element
    
    private let ref : MusicTrack
    internal weak var parent: MIDISequenceImpl! = nil
    
    init() {
        fatalError()
    }
    
    internal init(seq: MIDISequenceImpl) {
        ref = MIDITrackCreate(ref: seq.ref)
        parent = seq
    }
    
    internal init(seq: MIDISequenceImpl, no: Int) {
        ref = MusicSequenceGetIndTrack(ref: seq.ref, no: no)
        parent = seq
    }
    
    internal func copy() -> MIDITrackImpl {
        var cpy = MIDITrackImpl()
//        fatalError()
        cpy.copyInsert(from: self, in: timerange, at: startTime)
        return cpy
    }
    
    internal var timerange: ClosedRange<MIDITimestamp> {
        return startTime...endTime
    }
    
    internal static func ==(lhs: MIDITrackImpl, rhs: MIDITrackImpl) -> Bool {
        return lhs.ref == rhs.ref || lhs.elementsEqual(rhs) {
            $0.timestamp == $1.timestamp && $0.event == $1.event
        }
    }
    
    internal var description: String {
        var opts: [String] = []
        if soloed {
            opts.append("soloed")
        }
        
        if muted {
            opts.append("muted")
        }
        
        return "MIDITrackImpl(in:\(timerange), \(opts))"
    }
    
    internal subscript(timerange timerange: ClosedRange<MIDITimestamp>) -> AnyIterator<Element> {
        fatalError()
    }
    
    internal var startTime : MIDITimestamp {
        return MIDITimestamp(base: parent, beats: MusicTimeStamp(offsetTime))
    }
    
    internal var endTime : MIDITimestamp {
        return startTime.advanced(by: MusicTimeStamp(duration))
    }
    
    internal func makeIterator() -> Iterator {
//        return MIDITrackIterator(self)
        fatalError()
    }
    
    internal var hashValue: Int {
        return ref.hashValue
    }
    
    internal var offsetTime : Int {
        get {
            //            let offset = self[.offsetTime]
            return tee(self[.offsetTime])
        }
        set {
            self[.offsetTime] = newValue
        }
    }
    
    internal var duration : Int {
        get {
            return self[.length]
        }
        set {
            self[.length] = newValue
        }
    }
    
    internal var loopInfo : Int {
        get {
            return self[.loopInfo]
        }
        set {
            self[.loopInfo] = newValue
        }
    }
    
    internal var muted : Bool {
        get {
            return Bool(self[.muted])
        }
        set {
            self[.muted] = Int(newValue)
        }
    }
    
    internal var soloed : Bool {
        get {
            return Bool(self[.soloed])
        }
        set {
            self[.soloed] = Int(newValue)
        }
    }
    
    internal var automatedParameters : Bool {
        get {
            return Bool(self[.automatedParams])
        }
        set {
            self[.automatedParams] = Int(newValue)
        }
    }
    
    internal var timeResolution : Int {
        get {
            return self[.resolution]
        }
        set {
            self[.resolution] = newValue
        }
    }
    
    private subscript(prop: MIDITrackProp) -> Int {
        get {
            return MIDITrackGetProperty(ref: ref, prop: prop.rawValue)
        }
        set {
            MIDITrackSetProperty(ref: ref, prop: prop.rawValue, to: newValue)
        }
    }
    
//    mutating
    func move(_ timerange: ClosedRange<MIDITimestamp>, to timestamp: MIDITimestamp) {
        MusicTrackMoveEvents(ref,
                             timerange.lowerBound.beats,
                             timerange.upperBound.beats,
                             timestamp.beats)
    }
    
//    mutating
    func clear(_ timerange: ClosedRange<MIDITimestamp>) {
        MusicTrackClear(ref,
                        timerange.lowerBound.beats,
                        timerange.upperBound.beats)
    }
    
//    mutating
    func cut(_ timerange: ClosedRange<MIDITimestamp>) {
        MusicTrackCut(ref,
                      timerange.lowerBound.beats,
                      timerange.upperBound.beats)
    }
    
//    mutating
    func copyInsert(from other: MIDITrackImpl, in timerange: ClosedRange<MIDITimestamp>, at timestamp: MIDITimestamp) {
        MusicTrackCopyInsert(other.ref,
                             timerange.lowerBound.beats,
                             timerange.upperBound.beats,
                             ref,
                             timestamp.beats)
    }
    
//    mutating
    func merge(with other: MIDITrackImpl, in timerange: ClosedRange<MIDITimestamp>, at timestamp: MIDITimestamp) {
        MusicTrackMerge(other.ref,
                        timerange.lowerBound.beats,
                        timerange.upperBound.beats,
                        ref,
                        timestamp.beats)
    }
    
//    mutating
    func add(_ event: MIDIEvent, at timestamp: MIDITimestamp) {
//        event.add(to: self, at: timestamp)
        fatalError()
    }
    
    func remove<S : Sequence>(_ elements: S) where S.Iterator.Element == Element {
        //        remove(÷
        fatalError()
    }
    
    func remove(_ timerange: ClosedRange<MIDITimestamp>) {
        fatalError()
    }
}