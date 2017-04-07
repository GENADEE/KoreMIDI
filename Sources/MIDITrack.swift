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
    

    internal weak var parent: MIDISequenceImpl! = nil
    private  var impl : MIDITrackImpl! = nil
    
    init() {
        fatalError()
    }
    
    internal init(seq: MIDISequenceImpl) {
        impl = MIDITrackImpl(seq: seq)
    }
    
    internal init(seq: MIDISequenceImpl, no: Int) {
        impl = MIDITrackImpl(seq: seq, no: no)
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
        fatalError()
    }
    
    public var startTime : MIDITimestamp {
        return MIDITimestamp(base: parent, beats: MusicTimeStamp(offsetTime))
    }
    
    public var endTime : MIDITimestamp {
        return startTime.advanced(by: MusicTimeStamp(duration))
    }
    
    public func makeIterator() -> Iterator {
        return impl.makeIterator()
    }
    
    public var hashValue: Int {
        return impl.hashValue
    }
    
    private mutating func _ensureUnique() {
        if !isKnownUniquelyReferenced(&impl!) {
            impl = impl.copy()
        }
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
    
    
    
    public var duration : Int {
        get {
            return impl.duration
        }
        set {
            impl.duration = newValue
        }
    }
    
    public var loopInfo : Int {
        get {
            return impl.duration
        }
        set {
            impl.duration = newValue
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
    
    public var timeResolution : Int {
        get {
            return impl.timeResolution
        }
        set {
            impl.timeResolution = newValue
        }
    }
    
    mutating
    func move(_ timerange: ClosedRange<MIDITimestamp>, to timestamp: MIDITimestamp) {
        impl.move(timerange, to: timestamp)
    }
    
    mutating
    func clear(_ timerange: ClosedRange<MIDITimestamp>) {
        impl.clear(timerange)
    }
    
    mutating
    func cut(_ timerange: ClosedRange<MIDITimestamp>) {
        impl.cut(timerange)
    }
    
    mutating
    func copyInsert(from other: MIDITrack, in timerange: ClosedRange<MIDITimestamp>, at timestamp: MIDITimestamp) {
        impl.copyInsert(from: other.impl, in: timerange, at: timestamp)
    }
    
    mutating
    func merge(with other: MIDITrack, in timerange: ClosedRange<MIDITimestamp>, at timestamp: MIDITimestamp) {
        impl.merge(with: other.impl, in: timerange, at: timestamp)
    }
    
    mutating
    func add(_ event: MIDIEvent, at timestamp: MIDITimestamp) {
        event.add(to: impl, at: timestamp)
    }
    
    mutating func remove<S : Sequence>(_ elements: S) where S.Iterator.Element == Element {
        //        remove(÷
        fatalError()
    }
    
    mutating func remove(_ timerange: ClosedRange<MIDITimestamp>) {
        fatalError()
    }
}
