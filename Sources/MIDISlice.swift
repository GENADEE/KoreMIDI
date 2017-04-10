//
//  MIDITrackSlice.swift
//  KoreMIDI
//
//  Created by Adam Nemecek on 4/8/17.
//
//

import Foundation



public struct MIDISlice<Element : MIDIEventConvertible> : TimeSeries {
    public typealias Timestamp = MIDITimestamp
    typealias Base = MIDITrackImpl
    
    private let base: Base
    let timerange : Range<Timestamp>?

    internal init(base: Base, timerange: Range<Timestamp>? = nil) {
        self.base = base
        self.timerange = timerange
    }

    public var startTime : Timestamp {
        return base.startTime
    }
    
    public var endTime: Timestamp {
        return base.endTime
    }
    
    public var duration: Timestamp.Stride {
//        return base.duration
        fatalError()
    }
    
    public func timestamp(after t: Timestamp) -> Timestamp {
        fatalError()
    }
    
    public subscript(timerange: Range<Timestamp>) -> MIDISlice<Element> {
        get {
            fatalError()
        }
        set {
            fatalError()
        }
    }
    
    public func makeIterator() -> AnyIterator<Element> {
        fatalError()
    }
}
