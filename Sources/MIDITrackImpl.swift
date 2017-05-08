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


extension MIDITrack {
    internal final class Impl : Sequence, Equatable, Comparable, Hashable, CustomStringConvertible {
        //    typealias Iterator = MIDIIterator
        //    typealias Element = Iterator.Element
        public typealias Timestamp = MIDITimestamp
        typealias Element = MIDIEvent<Timestamp>

        let ref : MusicTrack
        private var _parent: MIDISequence.Impl? = nil
        
        var parent : MIDISequence {
            return MIDISequence(impl: parentImpl)
        }
        
        init(tempoTrack seq: MIDISequence.Impl) {
            self.ref = MusicSequenceGetTempoTrack(ref: seq.ref)
        }
        
        var parentImpl : MIDISequence.Impl {
            return _parent ?? MIDISequence.Impl(for: self)
        }
        
        var isParentUnique : Bool {
            return _parent == nil
        }
        
        init() {
            let s = MIDISequence.Impl()
            ref = MIDITrackCreate(ref: s.ref)
            
            _parent = s
            //        ref = M
            //        parent = nil
        }
        
        static func ===(lhs: Impl, rhs: Impl) -> Bool {
            return lhs.ref == rhs.ref
        }
        
        static func ==(lhs: Impl, rhs: Impl) -> Bool {
            return lhs === rhs || lhs.elementsEqual(rhs)
        }
        
        init(parent: MIDISequence.Impl) {
            ref = MIDITrackCreate(ref: parent.ref)
            _parent = parent
        }
        
        init(parent: MIDISequence.Impl, no: Int) {
            _parent = parent
            ref = MusicSequenceGetIndTrack(ref: parent.ref, no: no)
        }
        
        func copy() -> Impl {
            let cpy = Impl()
            cpy.copyInsert(from: self)
            return cpy
        }
        
        var timerange: Range<Timestamp> {
            return startTime..<endTime
        }
        
        static func <(lhs: Impl, rhs: Impl) -> Bool {
            return lhs.ref.hashValue < rhs.ref.hashValue
        }
        
        var description: String {
            var opts: [String] = []
            if soloed.boolValue {
                opts.append("soloed")
            }
            
            if muted.boolValue {
                opts.append("muted")
            }
            
            return "MIDITrackImpl(in:\(timerange), \(opts), \(map { $0 }))"
        }
        
        subscript(timerange timerange: Range<Timestamp>) -> AnyIterator<Element> {
            fatalError()
        }
        
        var startTime : Timestamp {
            get {
                return Timestamp(beats: _offsetTime)
            }
            set {
                _offsetTime = newValue.beats
            }
        }
        
        var endTime : Timestamp {
            get {
                return startTime.advanced(by: duration)
            }
            set {
                duration = _offsetTime + newValue.beats
            }
        }
        
        func makeIterator() -> AnyIterator<Element> {
            return AnyIterator(MIDIIterator(self))
        }
        
        var hashValue: Int {
            return ref.hashValue
        }
        
        var loopInfo : MusicTrackLoopInfo {
            get {
                return _get(.loopInfo)
            }
            set {
                _set(.loopInfo, to: newValue)
            }
        }
        
        var muted : DarwinBoolean {
            get {
                return _get(.muted)
            }
            set {
                _set(.muted, to: newValue)
            }
        }
        
        var soloed : DarwinBoolean {
            get {
                return _get(.soloed)
            }
            set {
                _set(.soloed, to: newValue)
            }
        }
        
        var automatedParameters : UInt32 {
            get {
                return _get(.automatedParams)
            }
            set {
                _set(.automatedParams, to: newValue)
            }
        }
        
        var timeResolution : Int16 {
            get {
                return _get(.resolution)
            }
            set {
                _set(.resolution, to: newValue)
            }
        }
        
        func timestamp(after t: Timestamp) -> Timestamp {
            fatalError()
        }
        
        
        private func _get<T>(_ prop: MIDITrackProp) -> T {
            return MIDITrackGetProperty(ref: ref, prop: prop)
        }
        
        
        private func _set<T>(_ prop: MIDITrackProp, to value: T) {
            return MIDITrackSetProperty(ref: ref, prop: prop, to: value)
        }
        
        internal subscript(element element: Element) -> Element {
            get {
                fatalError()
            }
            set {
                //            guard element != newValue else { return }
                //            let i = MIDIIterator(self, timerange: element.timerange)
                //            i[element] = newValue
                fatalError()
            }
        }
        
        private var _offsetTime : MusicTimeStamp {
            get {
                //            let offset = self[.offsetTime]
                return _get(.offsetTime)
            }
            set {
                _set(.offsetTime, to: newValue)
            }
        }
        
        var duration : Timestamp.Stride {
            get {
                return _get(.length)
                
            }
            set {
                _set(.length, to: newValue)
            }
        }
        
        func insert(_ element: Element) {
            OSAssert(MusicSequenceInsert(ref: ref, event: element))
        }

        func move(_ timerange: Range<Timestamp>, to timestamp: Timestamp) {
            OSAssert(MusicTrackMoveEvents(ref,
                                          timerange.lowerBound.beats,
                                          timerange.upperBound.beats,
                                          timestamp.beats))
        }
        
        func load(from other: Impl) {
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
        
        func copyInsert(from other: Impl,
                              in timerange: Range<Timestamp>? = nil,
                              at timestamp: Timestamp? = nil) {
            let tr = timerange ?? other.timerange
            OSAssert(MusicTrackCopyInsert(other.ref,
                                          tr.lowerBound.beats,
                                          tr.upperBound.beats,
                                          ref,
                                          timestamp?.beats ?? 0))
        }
        
        func merge(with other: Impl,
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

            let i = MIDIIterator(self, timerange: timerange)
            
            while let n = i.next() {
                if predicate(n) {
                    _ = i.remove()
                }
            }
        }
    }
}

//final class MIDIEventTrackImpl<Element : MIDIEventConvertible> : MIDITrack.Impl {
//    
//}





