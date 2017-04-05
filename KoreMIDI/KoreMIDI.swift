//
//  KoreMIDI.swift
//  KoreMIDI
//
//  Created by Adam Nemecek on 4/5/17.
//  Copyright © 2017 Adam Nemecek. All rights reserved.
//

import Foundation

import AudioToolbox


class MIDISequence : Collection, Comparable, Hashable {
    private let ref : MusicSequence
    typealias Index = Int
    typealias Element = MIDITrack
    
    init() {
        ref = MIDISequenceCreate()
    }

    init(path: String) {
        ref = MIDISequenceLoad(path: path)
    }

    var startIndex: Index {
        return 0
    }
    
    var endIndex : Index {
        fatalError()
    }
    
    
    subscript(index: Index) -> Element {
        fatalError()
    }
    
    func index(after i: Index) -> Index {
        return i + 1
    }
    
    
    var type : MusicSequenceType {
        get {
            //MusicSequenceGetSequenceType
            fatalError()
        }
        set {
            
        }
    }

    static func ==(lhs: MIDISequence, rhs: MIDISequence) -> Bool {
        return lhs.ref == rhs.ref
    }

    static func <(lhs: MIDISequence, rhs: MIDISequence) -> Bool {
        return lhs.hashValue < rhs.hashValue
    }

    var hashValue: Int {
        return ref.hashValue
    }
    
    deinit {
        DisposeMusicSequence(ref)
    }
    
    func export() -> Data {
        fatalError()
    }
    
    var tempoTrack : MIDITrack {
        fatalError()
    }
}
extension Int {
    init(_ bool: Bool) {
        self = bool ? 1 : 0
    }
}

extension Bool {
    init(_ int: Int) {
        self = int != 0
    }
}

protocol TimeSeries : Sequence {
    associatedtype Timestamp : Comparable
    var startTimestamp: Timestamp { get }
    var endTimestamp : Timestamp { get }
    subscript(timerange: ClosedRange<Timestamp>) -> SubSequence { get }
}

struct MIDITrack : Sequence {
    typealias Element = Int
    typealias Timestamp = Double

    fileprivate let ref : MusicTrack

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
    
    func makeIterator() -> AnyIterator<Int> {
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
    func copyInsert(with other: MIDITrack, in timerange: ClosedRange<Timestamp>, at timestamp: Timestamp) {
        MusicTrackCopyInsert(ref, timerange.lowerBound, timerange.upperBound, other.ref, timestamp)
    }
    
    mutating
    func merge(with other: MIDITrack, in timerange: ClosedRange<Timestamp>, at timestamp: Timestamp) {
        MusicTrackMerge(ref, timerange.lowerBound, timerange.upperBound, other.ref, timestamp)
    }
    
    func add(_ event: MIDIEvent, at timestamp: Timestamp) {
        switch type(of: event).type {
//            case let msg =
        case .note:
            fatalError()
        default: fatalError()
        }
    }

}

class EventIterator : IteratorProtocol {
    typealias Element = Int
    private let ref: MusicEventIterator
    
    init(track: MIDITrack) {
        ref = MIDIIteratorCreate(ref : track.ref)
    }
    
    deinit {
        DisposeMusicEventIterator(ref)
    }

    func current() -> Element? {
        fatalError()
    }

    func next() -> Element? {
        fatalError()
    }
}

class MIDIEventIterator<Element> : EventIterator {
    
}


