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
    public typealias Element = MIDIEvent

    public init() {
        _impl = MIDITrackImpl()
    }

    public var timerange: Range<MIDITimestamp> {
        return _impl.timerange
    }
    
    public static func ==(lhs: MIDITrack, rhs: MIDITrack) -> Bool {
        return lhs._impl == rhs._impl
    }
    
    public var description: String {
        return _impl.description
    }
    
    public subscript(timerange timerange: Range<MIDITimestamp>) -> AnyIterator<Element> {
        return _impl[timerange: timerange]
    }
    
    public var startTime : MIDITimestamp {
        get {
            return _impl.startTime
        }
        set {
            _impl.startTime = newValue
        }

    }
    
    public var endTime : MIDITimestamp {
        get {
            return _impl.endTime
        }
        set {
            _impl.endTime = newValue
        }
    }
    
    public func makeIterator() -> AnyIterator<MIDIEvent> {
        return _impl.makeIterator()
    }
    
    public var hashValue: Int {
        return _impl.hashValue
    }
    
    public var loopInfo : MusicTrackLoopInfo {
        get {
            return _impl.loopInfo
        }
        set {
            _impl.loopInfo = newValue
        }
    }
    
    public var muted : Bool {
        get {
            return _impl.muted.boolValue
        }
        set {
            _impl.muted = DarwinBoolean(newValue)
        }
    }
    
    public var soloed : Bool {
        get {
            return _impl.soloed.boolValue
        }
        set {
            _impl.soloed = DarwinBoolean(newValue)
        }
    }
    
    public var automatedParameters : UInt32 {
        get {
            return _impl.automatedParameters
        }
        set {
            _impl.automatedParameters = newValue
        }
    }
    
    public var timeResolution : Int16 {
        get {
            return _impl.timeResolution
        }
        set {
            _impl.timeResolution = newValue
        }
    }
    
    mutating
    func move(_ timerange: Range<MIDITimestamp>, to timestamp: MIDITimestamp) {
        _ensureUnique()
        _impl.move(timerange, to: timestamp)
    }
    
    mutating
    func clear(_ timerange: Range<MIDITimestamp>) {
        _ensureUnique()
        _impl.clear(timerange)
    }
    
    mutating
    func load(from other: MIDITrack) {
        _ensureUnique()
        _impl.load(from: other._impl)
    }
    
    mutating
    func cut(_ timerange: Range<MIDITimestamp>) {
        _ensureUnique()
        _impl.cut(timerange)
    }
    
    mutating
    func copyInsert(from other: MIDITrack, in timerange: Range<MIDITimestamp>, at timestamp: MIDITimestamp) {
        _ensureUnique()
        _impl.copyInsert(from: other._impl, in: timerange, at: timestamp)
    }
    
    mutating
    func merge(with other: MIDITrack, in timerange: Range<MIDITimestamp>, at timestamp: MIDITimestamp) {
        _ensureUnique()
        _impl.merge(with: other._impl, in: timerange, at: timestamp)
    }
    
    mutating
    func insert(_ event: MIDIEvent, at timestamp: MIDITimestamp) {
        _ensureUnique()
//        event.insert(to: _impl, at: timestamp)
        fatalError()
    }

    mutating func remove(_ element : Element) {
        _ensureUnique()
        remove([element])
    }
    
    mutating func remove<S : Sequence>(_ elements: S) where S.Iterator.Element == Element {
        _ensureUnique()
        _impl.remove(elements)
    }
    
    mutating func remove(_ timerange: Range<MIDITimestamp>) {
        _ensureUnique()
        _impl.remove(timerange)
    }
    
    internal init(seq: MIDISequenceImpl) {
        _impl = MIDITrackImpl(parent: seq)
    }
    
    internal init(seq: MIDISequenceImpl, no: Int) {
        _impl = MIDITrackImpl(parent: seq, no: no)
    }
    
    private mutating func _ensureUnique() {
        if _impl.isParentUnique { return }
        _impl = _impl.copy()
    }
    
    internal var _impl : MIDITrackImpl
}
