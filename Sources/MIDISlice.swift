//
//  MIDITrackSlice.swift
//  KoreMIDI
//
//  Created by Adam Nemecek on 4/8/17.
//
//

import Foundation

/*

public struct MIDISlice<Element : MIDIEventConvertible> : TimeSeries {
    public typealias Timestamp = MIDITimestamp
    internal typealias Base = MIDIEventTrackImpl<Element>
    
    private let _base: Base
    let timerange : Range<Timestamp>?

    internal init(base: Base, timerange: Range<Timestamp>? = nil) {
        self._base = base
        self.timerange = timerange
    }

    public var startTime : Timestamp {
        return _base.startTime
    }
    
    public var endTime: Timestamp {
        return _base.endTime
    }
    
    public var duration: Timestamp.Stride {
        return _base.duration
    }
    
    public func timestamp(after t: Timestamp) -> Timestamp {
//        return base.times
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
        let i = _base.makeIterator()
        return AnyIterator {
            i.next().map { Element(event: $0)! }
        }
    }
}
*/
