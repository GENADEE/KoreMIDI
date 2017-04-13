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



extension MIDITrack {
    
    
    internal class Impl : Sequence, Equatable, Comparable, Hashable, CustomStringConvertible {
        //    typealias Iterator = MIDIIterator
        //    typealias Element = Iterator.Element
        public typealias Timestamp = MIDITimestamp
        typealias Element = MIDIEvent<Timestamp>

        let ref : MusicTrack
        private var _parent: MIDISequenceImpl? = nil
        
        var parent : MIDISequence {
            return MIDISequence(impl: parentImpl)
        }
        
        final var parentImpl : MIDISequenceImpl {
            return _parent ?? MIDISequenceImpl(for: self)
        }
        
        final var isParentUnique : Bool {
            return _parent == nil
        }
        
        init() {
            let s = MIDISequenceImpl()
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
        
        init(parent: MIDISequenceImpl) {
            ref = MIDITrackCreate(ref: parent.ref)
            _parent = parent
        }
        
        init(parent: MIDISequenceImpl, no: Int) {
            _parent = parent
            ref = MusicSequenceGetIndTrack(ref: parent.ref, no: no)
        }
        
        final func copy() -> Impl {
            let cpy = Impl()
            cpy.copyInsert(from: self)
            return cpy
        }
        
        final var timerange: Range<Timestamp> {
            return startTime..<endTime
        }
        
        static func <(lhs: Impl, rhs: Impl) -> Bool {
            return lhs.ref.hashValue < rhs.ref.hashValue
        }
        
        final var description: String {
            var opts: [String] = []
            if soloed.boolValue {
                opts.append("soloed")
            }
            
            if muted.boolValue {
                opts.append("muted")
            }
            
            return "MIDITrackImpl(in:\(timerange), \(opts))"
        }
        
        final subscript(timerange timerange: Range<Timestamp>) -> AnyIterator<Element> {
            fatalError()
        }
        
        final var startTime : Timestamp {
            get {
                return Timestamp(base: parent._impl, beats: _offsetTime)
            }
            set {
                _offsetTime = newValue.beats
            }
        }
        
        final var endTime : Timestamp {
            get {
                return startTime.advanced(by: duration)
            }
            set {
                duration = _offsetTime + newValue.beats
            }
        }
        
        final func makeIterator() -> AnyIterator<Element> {
            let i = MIDIIterator(self)
            let s = self.parentImpl
            return AnyIterator {
                i.next().map {
                    let t = Timestamp(base: s, beats: $0.timestamp)
                    return MIDIEvent(timestamp: t, type: $0.type, data: $0.data)
                }
            }
        }
        
        final var hashValue: Int {
            return ref.hashValue
        }
        
        final var loopInfo : MusicTrackLoopInfo {
            get {
                return get(.loopInfo)
            }
            set {
                set(.loopInfo, to: newValue)
            }
        }
        
        final var muted : DarwinBoolean {
            get {
                return get(.muted)
            }
            set {
                set(.muted, to: newValue)
            }
        }
        
        final var soloed : DarwinBoolean {
            get {
                return get(.soloed)
            }
            set {
                set(.soloed, to: newValue)
            }
        }
        
        final var automatedParameters : UInt32 {
            get {
                return get(.automatedParams)
            }
            set {
                set(.automatedParams, to: newValue)
            }
        }
        
        final var timeResolution : Int16 {
            get {
                return get(.resolution)
            }
            set {
                set(.resolution, to: newValue)
            }
        }
        
        final func timestamp(after t: Timestamp) -> Timestamp {
            fatalError()
        }
        
        
        private final  func get<T>(_ prop: MIDITrackProp) -> T {
            return MIDITrackGetProperty(ref: ref, prop: prop)
        }
        
        
        private final func set<T>(_ prop: MIDITrackProp, to value: T) {
            //        return MIDITrackGetProperty(ref: ref, prop: prop)
            fatalError()
        }
        
        internal final subscript(element element: Element) -> Element {
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
        
        private final var _offsetTime : MusicTimeStamp {
            get {
                //            let offset = self[.offsetTime]
                return get(.offsetTime)
            }
            set {
                set(.offsetTime, to: newValue)
            }
        }
        
        final var duration : Timestamp.Stride {
            get {
                return get(.length)
                
            }
            set {
                set(.length, to: newValue)
            }
        }
        
        final func insert(_ element: Element) {
            switch element {
            
            case .extendedNote(let ts, var e):
                MusicTrackNewExtendedNoteEvent(ref, ts.beats, &e)
            case .extendedTempo(let ts, let e):
                MusicTrackNewExtendedTempoEvent(ref, ts.beats, e.bpm)
            case .user(let ts, var e):
                MusicTrackNewUserEvent(ref, ts.beats, &e)
            case .meta(let ts, var e):
                MusicTrackNewMetaEvent(ref, ts.beats, &e)
            case .note(let ts, var e):
                MusicTrackNewMIDINoteEvent(ref, ts.beats, &e)
            case .channel(let ts, var e):
                MusicTrackNewMIDIChannelEvent(ref, ts.beats, &e)
            case .rawData(let ts, var e):
                MusicTrackNewMIDIRawDataEvent(ref, ts.beats, &e)
            case .parameter(let ts, var e):
                MusicTrackNewParameterEvent(ref, ts.beats, &e)
            case .auPreset(let ts, var e):
                MusicTrackNewAUPresetEvent(ref, ts.beats, &e)
            }
        }

        final public func insert(_ element: MIDIEvent<MusicTimeStamp>) {
            insert(element.map {
                Timestamp(base: self.parentImpl, beats: $0)
            })
        }
        
        
        final func move(_ timerange: Range<Timestamp>, to timestamp: Timestamp) {
            MusicTrackMoveEvents(ref,
                                 timerange.lowerBound.beats,
                                 timerange.upperBound.beats,
                                 timestamp.beats)
        }
        
        final func load(from other: Impl) {
            clearAll()
            copyInsert(from: other, in: other.timerange, at: other.startTime)
        }
        
        final func clear(_ timerange: Range<Timestamp>) {
            MusicTrackClear(ref,
                            timerange.lowerBound.beats,
                            timerange.upperBound.beats)
        }
        
        final func clearAll() {
            clear(timerange)
        }
        
        final func cut(_ timerange: Range<Timestamp>) {
            MusicTrackCut(ref,
                          timerange.lowerBound.beats,
                          timerange.upperBound.beats)
        }
        
        final func copyInsert(from other: Impl,
                              in timerange: Range<Timestamp>? = nil,
                              at timestamp: Timestamp? = nil) {
            let tr = timerange ?? other.timerange
            MusicTrackCopyInsert(other.ref,
                                 tr.lowerBound.beats,
                                 tr.upperBound.beats,
                                 ref,
                                 timestamp?.beats ?? 0)
        }
        
        final func merge(with other: Impl,
                         in timerange: Range<Timestamp>? = nil,
                         at timestamp: Timestamp? = nil) {
            let tr = timerange ?? other.timerange
            MusicTrackMerge(other.ref,
                            tr.lowerBound.beats,
                            tr.upperBound.beats,
                            ref,
                            timestamp?.beats ?? 0)
        }
        
        final func remove<S : Sequence>(_ elements: S) where S.Iterator.Element == Element {
            guard let range = (elements.lazy.map { $0.timestamp }.range()) else { return }
            let s = Set(elements)
            
            remove(range) {
                s.contains($0)
            }
        }
        
        final func remove(_ timerange: Range<Timestamp>,
                          predicate: (Element) -> Bool) {
            let t = timerange.lowerBound.beats..<timerange.upperBound.beats
            let i = MIDIIterator(self, timerange: t)
            
            while let n = i.next() {
                let ts = Timestamp(base: parentImpl, beats: n.timestamp)
                let e = Element(timestamp: ts, type: n.type, data: n.data)

                if predicate(e) {
                    i.remove()
                }
            }
        }
    }
}

//final class MIDIEventTrackImpl<Element : MIDIEventConvertible> : MIDITrack.Impl {
//    
//}





