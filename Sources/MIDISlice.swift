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

    public var startTime : Timestamp {
        fatalError()
    }

    public var endTime: Timestamp {
        fatalError()
    }
    
    public var duration: Timestamp.Stride {
        fatalError()
    }
    
    public func timestamp(after t: MIDITimestamp) -> MIDITimestamp {
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
