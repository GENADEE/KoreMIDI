//
//  TimeSeries.swift
//  KoreMIDI
//
//  Created by Adam Nemecek on 4/9/17.
//
//

import Foundation

public protocol Temporal {
    associatedtype Timestamp : Comparable, Strideable
}

public protocol TimeSeries : Sequence, Temporal {

    
    var startTime : Timestamp { get }
    var endTime : Timestamp { get }

    var duration : Timestamp.Stride { get }
    
    func timestamp(after t: Timestamp) -> Timestamp
    
    //    subscript(timerange: Range<Timestamp>) -> SubSequence { get }
}

protocol MutableTimeSeries : TimeSeries {
    
    subscript(timerange: Range<Timestamp>) -> SubSequence { get set }
}

extension TimeSeries {
    var duration: Timestamp.Stride {
        return startTime.distance(to: endTime)
    }
}

@inline(__always)
func withCopy<T, Result>(of value : T, body: (UnsafePointer<T>) -> Result) -> Result {
    var copy = value
    return withUnsafePointer(to: &copy) {
        body($0)
    }
}
