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

protocol EventType : Temporal, Comparable {
    associatedtype Event : Equatable
    var event : Event { get }
    var timestamp : Timestamp { get }
    
    init(event: Event, timestamp : Timestamp)
}

protocol MutableTimeSeries : TimeSeries {
    
    subscript(timerange: Range<Timestamp>) -> SubSequence { get set }
}

extension TimeSeries {
    var duration: Timestamp.Stride {
        return startTime.distance(to: endTime)
    }
}
