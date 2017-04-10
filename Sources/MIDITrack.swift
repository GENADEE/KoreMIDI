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

    public var timerange: Range<MIDITimestamp> {
        return impl.timerange
    }
    
    public static func ==(lhs: MIDITrack, rhs: MIDITrack) -> Bool {
        return lhs.impl == rhs.impl
    }
    
    public var description: String {
        return impl.description
    }
    
    public subscript(timerange timerange: Range<MIDITimestamp>) -> AnyIterator<Element> {
        return impl[timerange: timerange]
    }
    
    public var startTime : MIDITimestamp {
        get {
            return impl.startTime
        }
        set {
            impl.startTime = newValue
        }

    }
    
    public var endTime : MIDITimestamp {
        get {
            return impl.endTime
        }
        set {
            impl.endTime = newValue
        }
    }
    
    public func makeIterator() -> Iterator {
        return impl.makeIterator()
    }
    
    public var hashValue: Int {
        return impl.hashValue
    }
    
    public var loopInfo : MusicTrackLoopInfo {
        get {
            return impl.loopInfo
        }
        set {
            impl.loopInfo = newValue
        }
    }
    
    public var muted : Bool {
        get {
            return impl.muted.boolValue
        }
        set {
            impl.muted = DarwinBoolean(newValue)
        }
    }
    
    public var soloed : Bool {
        get {
            return impl.soloed.boolValue
        }
        set {
            impl.soloed = DarwinBoolean(newValue)
        }
    }
    
    public var automatedParameters : UInt32 {
        get {
            return impl.automatedParameters
        }
        set {
            impl.automatedParameters = newValue
        }
    }
    
    public var timeResolution : Int16 {
        get {
            return impl.timeResolution
        }
        set {
            impl.timeResolution = newValue
        }
    }
    
    mutating
    func move(_ timerange: Range<MIDITimestamp>, to timestamp: MIDITimestamp) {
        _ensureUnique()
        impl.move(timerange, to: timestamp)
    }
    
    mutating
    func clear(_ timerange: Range<MIDITimestamp>) {
        _ensureUnique()
        impl.clear(timerange)
    }
    
    mutating
    func load(from other: MIDITrack) {
        _ensureUnique()
        impl.load(from: other.impl)
    }
    
    mutating
    func cut(_ timerange: Range<MIDITimestamp>) {
        _ensureUnique()
        impl.cut(timerange)
    }
    
    mutating
    func copyInsert(from other: MIDITrack, in timerange: Range<MIDITimestamp>, at timestamp: MIDITimestamp) {
        _ensureUnique()
        impl.copyInsert(from: other.impl, in: timerange, at: timestamp)
    }
    
    mutating
    func merge(with other: MIDITrack, in timerange: Range<MIDITimestamp>, at timestamp: MIDITimestamp) {
        _ensureUnique()
        impl.merge(with: other.impl, in: timerange, at: timestamp)
    }
    
    mutating
    func insert(_ event: MIDIEvent, at timestamp: MIDITimestamp) {
        _ensureUnique()
//        event.insert(to: impl, at: timestamp)
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
    
    mutating func remove(_ timerange: Range<MIDITimestamp>) {
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
