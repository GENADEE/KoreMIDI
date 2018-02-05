//
//  MIDITrack.swift
//  KoreMIDI
//
//  Created by Adam Nemecek on 4/5/17.
//  Copyright © 2017 Adam Nemecek. All rights reserved.
//

import Foundation
import AudioToolbox.MusicPlayer

//
//let SequenceCallback : MusicSequenceUserCallback = {
//
//}

//@convention(c) func SequenceCallback(ref: UnsafeMutableRawPointer?,
//                                    seq: MusicSequence,
//                                    track: MusicTrack,
//                                    timestamp: MusicTimeStamp,
//                                    userdata: UnsafePointer<MusicEventUserData>,
//                                    timestamp2: MusicTimeStamp,
//                                    timestamp3: Musi  cTimeStamp) {
//
//}


public class Instrument {
    let name: String

    init(name: String) {
        fatalError()
    }
}

public class MIDITrack : Sequence, Equatable, Comparable, Hashable, CustomStringConvertible {
    public typealias Timestamp = MIDITimestamp
    public typealias Element = MIDIEvent

    /// this needs to be a strong reference because sequence need to be around as long as track ref is around
    private final let sequence: MIDISequence
    internal final let ref : MusicTrack

    public static func ===(lhs: MIDITrack, rhs: MIDITrack) -> Bool {
        return lhs.ref == rhs.ref
    }

    public static func ==(lhs: MIDITrack, rhs: MIDITrack) -> Bool {
        return lhs === rhs || lhs.elementsEqual(rhs)
    }

    public static func <(lhs: MIDITrack, rhs: MIDITrack) -> Bool {
        return lhs.ref.hashValue < rhs.ref.hashValue
    }

    public init(sequence: MIDISequence) {
        self.sequence = sequence
        self.ref = MIDITrackCreate(ref: sequence.ref)
    }

    internal init(sequence: MIDISequence, no: Int) {
        self.sequence = sequence
        self.ref = MusicSequenceGetTrack(ref: sequence.ref, at: no)
    }

//    public final func copy() -> MIDITrack {
//        let cpy = MIDITrack(sequence : sequence!)
//        cpy.copyInsert(from: self)
//        return cpy
//    }
//

    public var instrument: Instrument {
        fatalError()
    }

    public final var timerange: Range<Timestamp> {
        return startTime..<endTime
    }

    public final var description: String {
        var opts: [String] = []
        if soloed {
            opts.append("soloed")
        }

        if muted {
            opts.append("muted")
        }

        return "MIDITrack(in:\(timerange), \(map { $0 }))"
    }

    public final subscript(timerange timerange: Range<Timestamp>) -> MIDIRangeIterator {
        fatalError()
    }

    public final var startTime: Timestamp {
        get {
            return Timestamp(beats: _offsetTime)
        }
        set {
            _offsetTime = newValue.beats
        }
    }

    public final var endTime: Timestamp {
        get {
            return startTime.advanced(by: duration)
        }
        set {
            duration = _offsetTime + newValue.beats
        }
    }

    public final func makeIterator() -> MIDIIterator {
        return .init(self)
    }

    public final var hashValue: Int {
        return ref.hashValue
    }

    public final var loopInfo : MusicTrackLoopInfo {
        get {
            return self[.loopInfo]
        }
        set {
            self[.loopInfo] = newValue
        }
    }

    public final var muted : Bool {
        get {
            let ret : DarwinBoolean = self[.muted]
            return Bool(ret)
        }
        set {
            self[.muted] = DarwinBoolean(newValue)
        }
    }

    public final var soloed : Bool {
        get {
            let ret : DarwinBoolean = self[.soloed]
            return ret.boolValue
        }
        set {
            self[.soloed] = DarwinBoolean(newValue)
        }
    }

    public final var automatedParameters : UInt32 {
        get {
            return self[.automatedParams]
        }
        set {
            self[.automatedParams] = newValue
        }
    }

    public final var timeResolution : Int16 {
        get {
            return self[.resolution]
        }
        set {
            self[.resolution] = newValue
        }
    }

    private subscript <T>(_ prop: MIDITrackProp) -> T {
        get {
            return MIDITrackGetProperty(ref: ref, prop: prop)
        }
        set {
            MIDITrackSetProperty(ref: ref, prop: prop, to: newValue)
        }
    }

    private var _offsetTime : MusicTimeStamp {
        get {
            return self[.offsetTime]
        }
        set {
            self[.offsetTime] = newValue
        }
    }

    public final var duration : Timestamp.Stride {
        get {
            return self[.length]

        }
        set {
            self[.length] = newValue
        }
    }

    final func insert(_ element: Element) {
        fatalError()
//        MusicSequenceInsert(ref: ref, event: element)
    }

    func move(_ timerange: Range<Timestamp>, to timestamp: Timestamp) {
        OSAssert(MusicTrackMoveEvents(ref,
                                      timerange.lowerBound.beats,
                                      timerange.upperBound.beats,
                                      timestamp.beats))
    }

    func load(from other: MIDITrack) {
        clearAll()
        copyInsert(from: other, in: other.timerange, at: other.startTime)
    }

    func clear(_ timerange: Range<Timestamp>) {
        OSAssert(MusicTrackClear(ref,
                                 timerange.lowerBound.beats,
                                 timerange.upperBound.beats))
    }

    func clearAll() {
        clear(timerange)
    }

    func cut(_ timerange: Range<Timestamp>) {
        OSAssert(MusicTrackCut(ref,
                               timerange.lowerBound.beats,
                               timerange.upperBound.beats))
    }

    func copyInsert(from other: MIDITrack,
                    in timerange: Range<Timestamp>? = nil,
                    at timestamp: Timestamp? = nil) {
        let tr = timerange ?? other.timerange
        OSAssert(MusicTrackCopyInsert(other.ref,
                                      tr.lowerBound.beats,
                                      tr.upperBound.beats,
                                      ref,
                                      timestamp?.beats ?? 0))
    }

    func merge(with other: MIDITrack,
               in timerange: Range<Timestamp>? = nil,
               at timestamp: Timestamp? = nil) {
        let tr = timerange ?? other.timerange
        OSAssert(MusicTrackMerge(other.ref,
                                 tr.lowerBound.beats,
                                 tr.upperBound.beats,
                                 ref,
                                 (timestamp ?? 0).beats))
    }

    func remove<S : Sequence>(_ elements: S) where S.Iterator.Element == Element {
        guard let range = (elements.lazy.map { $0.timestamp }.range()) else { return }
        let s = Set(elements)
        fatalError()
        //            remove(range) {
        //                s.contains($0)
        //            }
    }

    func remove(_ timerange: Range<Timestamp>,
                predicate: (Element) -> Bool) {

        let i = MIDIRangeIterator(self, timerange: timerange)

        while let n = i.next() {
            if predicate(n) {
                _ = i.remove()
            }
        }
    }

    fileprivate init(tempo sequence: MIDISequence) {
        self.sequence = sequence
        self.ref = MusicSequenceGetTempoTrack(ref: sequence.ref)
    }
}
//}


class MIDITempoTrack : MIDITrack {
    internal override init(sequence: MIDISequence) {
        super.init(tempo : sequence)
    }
}






