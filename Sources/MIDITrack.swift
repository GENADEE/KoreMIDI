//
//  MIDITrack.swift
//  KoreMIDI
//
//  Created by Adam Nemecek on 4/5/17.
//  Copyright © 2017 Adam Nemecek. All rights reserved.
//

import AVFoundation

import struct AudioToolbox.MusicPlayer.MusicTrackLoopInfo

public struct MIDITrack : Sequence, Equatable, Hashable, CustomStringConvertible {
    public typealias Element = MIDIEvent
    public typealias Timestamp = MIDITimestamp

    public init() {
        
        _impl = MIDITrackImpl()
    }

    public var timerange: Range<Timestamp> {
        return _impl.timerange
    }
    
    public static func ==(lhs: MIDITrack, rhs: MIDITrack) -> Bool {
        return lhs._impl == rhs._impl
    }
    
    public var description: String {
        return _impl.description
    }
    
    public subscript(timerange timerange: Range<Timestamp>) -> AnyIterator<Element> {
        return _impl[timerange: timerange]
    }

    public var startTime : Timestamp {
        get {
            return _impl.startTime
        }
        set {
            _impl.startTime = newValue
        }
    }
    
    public var endTime : Timestamp {
        get {
            return _impl.endTime
        }
        set {
            _impl.endTime = newValue
        }
    }
    
    public var duration : Timestamp.Stride {
        get {
            return _impl.duration
        }
        set {
            _impl.duration = newValue
        }
    }
    
    public func makeIterator() -> AnyIterator<Element> {
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
    
//    mutating func insert(_ element: Element) {
//        _ensureUnique()
//        
//        switch element.type {
//            
//        }
//        
//    }
    
//    public func map<S: Sequence>(from: S, to: S) where S.Iterator.Element == Element {
//        
//    }
    
    mutating
    func move(_ timerange: Range<Timestamp>, to timestamp: Timestamp) {
        _ensureUnique()
        _impl.move(timerange, to: timestamp)
    }
    
    mutating
    func clear(_ timerange: Range<Timestamp>) {
        _ensureUnique()
        _impl.clear(timerange)
    }
    
    mutating
    func load(from other: MIDITrack) {
        _ensureUnique()
        _impl.load(from: other._impl)
    }
    
    mutating
    func cut(_ timerange: Range<Timestamp>) {
        _ensureUnique()
        _impl.cut(timerange)
    }
    
    mutating
    func copyInsert(from other: MIDITrack, in timerange: Range<Timestamp>, at timestamp: MIDITimestamp) {
        _ensureUnique()
        _impl.copyInsert(from: other._impl, in: timerange, at: timestamp)
    }
    
    mutating
    func merge(with other: MIDITrack, in timerange: Range<Timestamp>, at timestamp: MIDITimestamp) {
        _ensureUnique()
        _impl.merge(with: other._impl, in: timerange, at: timestamp)
    }
    
    mutating
    func insert(_ event: Element, at timestamp: Timestamp) {
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
    
    mutating func remove(_ timerange: Range<Timestamp>) {
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
