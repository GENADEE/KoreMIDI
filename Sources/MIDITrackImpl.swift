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
//                                    timestamp3: MusicTimeStamp) {
//
//}


//struct WeakRef<Element : AnyObject> {
//    private(set) weak var ref : Element?
//    init(ref: Element) {
//        self.ref = ref
//    }
//}


//extension MIDITrack {
public class MIDITrack : Sequence, Equatable, Comparable, Hashable, CustomStringConvertible {
    public typealias Timestamp = MIDITimestamp
    public typealias Element = MIDIEvent<Timestamp>

    internal final let ref : MusicTrack

    public final let parent: MIDISequence

    //        var parent : MIDISequence {
    //            return MIDISequence(impl: parentImpl)
    //        }


    //        var parentImpl : MIDISequence {
    //            return _parent ?? MIDISequence(for: self)
    //        }

    //        var isParentUnique : Bool {
    //            return _parent == nil
    //        }

//    public init() {
//        parent = MIDISequence()
//        ref = MIDITrackCreate(ref: parent.ref)
//
//        //            _parent = s
//        //        ref = M
//        //        parent = nil
//    }

    public static func ===(lhs: MIDITrack, rhs: MIDITrack) -> Bool {
        return lhs.ref == rhs.ref
    }

    public static func ==(lhs: MIDITrack, rhs: MIDITrack) -> Bool {
        return lhs === rhs || lhs.elementsEqual(rhs)
    }

    public init(parent: MIDISequence) {
        ref = MIDITrackCreate(ref: parent.ref)
        self.parent = parent
    }

    public init(parent: MIDISequence, no: Int) {
        self.parent = parent
        ref = MusicSequenceGetTrack(ref: parent.ref, at: no)
    }

    public final func copy() -> MIDITrack {
        let cpy = MIDITrack(parent : parent)
        cpy.copyInsert(from: self)
        return cpy
    }

    public final var timerange: Range<Timestamp> {
        return startTime..<endTime
    }

    public static func <(lhs: MIDITrack, rhs: MIDITrack) -> Bool {
        return lhs.ref.hashValue < rhs.ref.hashValue
    }

    public final var description: String {
        var opts: [String] = []
        if soloed {
            opts.append("soloed")
        }

        if muted {
            opts.append("muted")
        }

        return "MIDITrackImpl(in:\(timerange), \(map { $0 }))"
    }

    public final subscript(timerange timerange: Range<Timestamp>) -> AnyIterator<Element> {
        fatalError()
    }

    public final var startTime : Timestamp {
        get {
            return Timestamp(beats: _offsetTime)
        }
        set {
            _offsetTime = newValue.beats
        }
    }

    public final var endTime : Timestamp {
        get {
            return startTime.advanced(by: duration)
        }
        set {
            duration = _offsetTime + newValue.beats
        }
    }

    public final func makeIterator() -> AnyIterator<Element> {
        return AnyIterator(MIDIIterator(self))
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
            return ret.boolValue
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

    public final func timestamp(after t: Timestamp) -> Timestamp {
        fatalError()
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
        MusicSequenceInsert(ref: ref, event: element)
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

    fileprivate init(tempo parent: MIDISequence) {
        self.parent = parent
        self.ref = MusicSequenceGetTempoTrack(ref: parent.ref)
    }
}
//}


class MIDITempoTrack : MIDITrack {
    public override init(parent: MIDISequence) {
        super.init(tempo : parent)
    }
}






