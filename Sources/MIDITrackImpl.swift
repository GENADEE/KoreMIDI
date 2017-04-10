//
//  MIDITrack.swift
//  KoreMIDI
//
//  Created by Adam Nemecek on 4/5/17.
//  Copyright © 2017 Adam Nemecek. All rights reserved.
//

import Foundation
import AudioToolbox.MusicPlayer

internal class MIDITrackImpl : Sequence, Equatable, Comparable, Hashable, CustomStringConvertible {
//    typealias Iterator = MIDIIterator
//    typealias Element = Iterator.Element
    typealias Element = MIDIEvent
    typealias Timestamp = MIDITimestamp
    
    let ref : MusicTrack
    private weak var _parent: MIDISequenceImpl? = nil
    
    var parent : MIDISequence {
        return MIDISequence(impl: parentImpl)
    }
    
    var parentImpl : MIDISequenceImpl {
        return _parent ?? MIDISequenceImpl(for: self)
    }
    
    var isParentUnique : Bool {
        return _parent == nil
    }
    
    init() {
        let s = MIDISequenceImpl()
        ref = MIDITrackCreate(ref: s.ref)
        
        fatalError()
        //        ref = M
        //        parent = nil
    }
    
    static func ===(lhs: MIDITrackImpl, rhs: MIDITrackImpl) -> Bool {
        return lhs.ref == rhs.ref
    }
    
    static func ==(lhs: MIDITrackImpl, rhs: MIDITrackImpl) -> Bool {
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
    
    func copy() -> MIDITrackImpl {
        let cpy = MIDITrackImpl()
        cpy.copyInsert(from: self)
        return cpy
    }
    
    var timerange: Range<Timestamp> {
        return startTime..<endTime
    }
    
    static func <(lhs: MIDITrackImpl, rhs: MIDITrackImpl) -> Bool {
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
        
        return "MIDITrackImpl(in:\(timerange), \(opts))"
    }
    
    subscript(timerange timerange: Range<Timestamp>) -> AnyIterator<Element> {
        fatalError()
    }
    
    var startTime : MIDITimestamp {
        get {
            return MIDITimestamp(base: parent._impl, beats: _offsetTime)
        }
        set {
            _offsetTime = newValue.beats
        }
    }
    
    var endTime : Timestamp {
        get {
            return startTime.advanced(by: _duration)
        }
        set {
            _duration = _offsetTime + newValue.beats
        }
    }
    
    func makeIterator() -> AnyIterator<MIDIEvent> {
        //        return MIDIIterator(self)
        //        fatalError()
        return AnyIterator(MIDIIterator(self))
    }
    
    var hashValue: Int {
        return ref.hashValue
    }
    
    var loopInfo : MusicTrackLoopInfo {
        get {
            return get(.loopInfo)
        }
        set {
            set(.loopInfo, to: newValue)
        }
    }
    
    var muted : DarwinBoolean {
        get {
            return get(.muted)
        }
        set {
            set(.muted, to: newValue)
        }
    }
    
    var soloed : DarwinBoolean {
        get {
            return get(.soloed)
        }
        set {
            set(.soloed, to: newValue)
        }
    }
    
    var automatedParameters : UInt32 {
        get {
            return get(.automatedParams)
        }
        set {
            set(.automatedParams, to: newValue)
        }
    }
    
    var timeResolution : Int16 {
        get {
            return get(.resolution)
        }
        set {
            set(.resolution, to: newValue)
        }
    }
    
    private func get<T>(_ prop: MIDITrackProp) -> T {
        return MIDITrackGetProperty(ref: ref, prop: prop)
    }
    
    
    private func set<T>(_ prop: MIDITrackProp, to value: T) {
        //        return MIDITrackGetProperty(ref: ref, prop: prop)
        fatalError()
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
            return get(.offsetTime)
        }
        set {
            set(.offsetTime, to: newValue)
        }
    }
    
    private var _duration : MIDITimestamp.Stride {
        get {
            return get(.length)
            
        }
        set {
            set(.length, to: newValue)
        }
    }

    func move(_ timerange: Range<Timestamp>, to timestamp: Timestamp) {
        MusicTrackMoveEvents(ref,
                             timerange.lowerBound.beats,
                             timerange.upperBound.beats,
                             timestamp.beats)
    }
    
    func load(from other: MIDITrackImpl) {
        clearAll()
        copyInsert(from: other, in: other.timerange, at: other.startTime)
    }

    func clear(_ timerange: Range<Timestamp>) {
        MusicTrackClear(ref,
                        timerange.lowerBound.beats,
                        timerange.upperBound.beats)
    }

    func clearAll() {
        clear(timerange)
    }
    
    func cut(_ timerange: Range<Timestamp>) {
        MusicTrackCut(ref,
                      timerange.lowerBound.beats,
                      timerange.upperBound.beats)
    }

    func copyInsert(from other: MIDITrackImpl,
                             in timerange: Range<Timestamp>? = nil,
                             at timestamp: Timestamp? = nil) {
        let tr = timerange ?? other.timerange
        MusicTrackCopyInsert(other.ref,
                             tr.lowerBound.beats,
                             tr.upperBound.beats,
                             ref,
                             timestamp?.beats ?? 0)
    }
    
    func merge(with other: MIDITrackImpl,
                        in timerange: Range<Timestamp>? = nil,
                        at timestamp: Timestamp? = nil) {
        let tr = timerange ?? other.timerange
        MusicTrackMerge(other.ref,
                        tr.lowerBound.beats,
                        tr.upperBound.beats,
                        ref,
                        timestamp?.beats ?? 0)
    }

    func remove<S : Sequence>(_ elements: S) where S.Iterator.Element == Element {
        //        remove(÷
        //        guard let range = (elements.lazy.map { $0.timerange }.reduce { $0.union($1) }) else { return }
        guard let range = (elements.lazy.map { $0.timestamp }.range()) else { return }
        let s = Set(elements)
        
        let i = MIDIIterator(self, timerange: range)
        while let n = i.next() {
            if s.contains(n) {
                i.remove()
            }
        }
    }
    
    func remove(_ timerange: Range<Timestamp>, predicate: ((Element) -> Bool)? = nil) {
        let i = MIDIIterator(self, timerange: timerange)
        while let n = i.next() {
            let t = MIDITimestamp(base: parentImpl, beats: n.timestamp)
            if timerange.contains(t) || (predicate.map { $0(n) } ?? false) {
                i.remove()
            }
        }
    }
    
    func remove() {
        
    }

}

final class MIDIEventTrackImpl<Element : MIDIEventConvertible> : MIDITrackImpl {
    
}





