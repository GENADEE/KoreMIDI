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

    public init() {
        impl = MIDITrackImpl()
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
        return impl[timerange: timerange]
    }
    
    public var startTime : MIDITimestamp {
        return impl.startTime
    }
    
    public var endTime : MIDITimestamp {
        return impl.endTime
    }
    
    public func makeIterator() -> Iterator {
        return impl.makeIterator()
    }
    
    public var hashValue: Int {
        return impl.hashValue
    }
    
    private var offsetTime : Int {
        get {
            return impl.offsetTime
        }
        set {
            //_ensureUnique()
            impl.offsetTime = newValue
        }
    }

    public var duration : MusicTimeStamp {
        get {
            return impl.duration
        }
        set {
            impl.duration = newValue
        }
    }
    
    public var loopInfo : Int {
        get {
            return impl.loopInfo
        }
        set {
            impl.loopInfo = newValue
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
    
    public var timeResolution : MusicTimeStamp {
        get {
            return impl.timeResolution
        }
        set {
            impl.timeResolution = newValue
        }
    }
    
    mutating
    func move(_ timerange: ClosedRange<MIDITimestamp>, to timestamp: MIDITimestamp) {
        _ensureUnique()
        impl.move(timerange, to: timestamp)
    }
    
    mutating
    func clear(_ timerange: ClosedRange<MIDITimestamp>) {
        _ensureUnique()
        impl.clear(timerange)
    }
    
    mutating
    func load(from other: MIDITrack) {
        _ensureUnique()
        impl.load(from: other.impl)
    }
    
    mutating
    func cut(_ timerange: ClosedRange<MIDITimestamp>) {
        _ensureUnique()
        impl.cut(timerange)
    }
    
    mutating
    func copyInsert(from other: MIDITrack, in timerange: ClosedRange<MIDITimestamp>, at timestamp: MIDITimestamp) {
        _ensureUnique()
        impl.copyInsert(from: other.impl, in: timerange, at: timestamp)
    }
    
    mutating
    func merge(with other: MIDITrack, in timerange: ClosedRange<MIDITimestamp>, at timestamp: MIDITimestamp) {
        _ensureUnique()
        impl.merge(with: other.impl, in: timerange, at: timestamp)
    }
    
    mutating
    func insert(_ event: MIDIEvent, at timestamp: MIDITimestamp) {
        _ensureUnique()
        event.insert(to: impl, at: timestamp)
    }
    
    mutating
    func insert(_ note: MIDINote) {
        _ensureUnique()
        fatalError()
    }
    
    mutating func remove(_ element : Element) {
        _ensureUnique()
        remove([element])
    }
    
    mutating func remove<S : Sequence>(_ elements: S) where S.Iterator.Element == Element {
        _ensureUnique()
        impl.remove(elements)
    }
    
    mutating func remove(_ timerange: ClosedRange<MIDITimestamp>) {
        _ensureUnique()
        impl.remove(timerange)
    }
    
    internal init(seq: MIDISequenceImpl) {
        impl = MIDITrackImpl(seq: seq)
    }
    
    internal init(seq: MIDISequenceImpl, no: Int) {
        impl = MIDITrackImpl(seq: seq, no: no)
    }
    
    private mutating func _ensureUnique() {
        if impl.isParentUnique { return }
        impl = impl.copy()
    }
    
    private var impl : MIDITrackImpl
}
