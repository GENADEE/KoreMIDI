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
    internal weak var parent: MIDISequenceImpl! = nil
    private  var impl : MIDITrackImpl! = nil
    
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
    
    public var timerange: ClosedRange<MIDITimestamp> {
        return impl.timerange
    }
    
    public static func ==(lhs: MIDITrack, rhs: MIDITrack) -> Bool {
        return lhs.impl == rhs.impl
    }
    
    public var description: String {
        return impl.description
    }
    
    public subscript(timerange timerange: ClosedRange<MIDITimestamp>) -> AnyIterator<Element> {
        fatalError()
    }
    
    public var startTime : MIDITimestamp {
        return MIDITimestamp(base: parent, beats: MusicTimeStamp(offsetTime))
    }
    
    public var endTime : MIDITimestamp {
        return startTime.advanced(by: MusicTimeStamp(duration))
    }
    
    public func makeIterator() -> Iterator {
        return impl.makeIterator()
    }
    
    public var hashValue: Int {
        return impl.hashValue
    }
    
    private mutating func _ensureUnique() {
        if !isKnownUniquelyReferenced(&impl!) {
            impl = impl.copy()
        }
    }
    
    private var offsetTime : Int {
        get {
            return impl.offsetTime
        }
        set {
            impl.offsetTime = newValue
        }
    }
    
    
    
    public var duration : Int {
        get {
            return impl.duration
        }
        set {
            impl.duration = newValue
        }
    }
    
    public var loopInfo : Int {
        get {
            return impl.duration
        }
        set {
            impl.duration = newValue
        }
    }
    
    public var muted : Bool {
        get {
            return impl.muted
        }
        set {
            impl.muted = newValue
        }
    }
    
    public var soloed : Bool {
        get {
            return impl.soloed
        }
        set {
            impl.soloed = newValue
        }
    }
    
    public var automatedParameters : Bool {
        get {
            return impl.automatedParameters
        }
        set {
            impl.automatedParameters = newValue
        }
    }
    
    public var timeResolution : Int {
        get {
            return impl.timeResolution
        }
        set {
            impl.timeResolution = newValue
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
