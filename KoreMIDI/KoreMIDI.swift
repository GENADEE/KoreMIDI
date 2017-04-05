//
//  KoreMIDI.swift
//  KoreMIDI
//
//  Created by Adam Nemecek on 4/5/17.
//  Copyright © 2017 Adam Nemecek. All rights reserved.
//

import Foundation

import AudioToolbox


extension Int {
    init(_ bool: Bool) {
        self = bool ? 1 : 0
    }
}

extension Bool {
    init(_ int: Int) {
        self = int != 0
    }
}

protocol TimeSeries : Sequence {
    associatedtype Timestamp : Comparable
    var startTimestamp: Timestamp { get }
    var endTimestamp : Timestamp { get }
    subscript(timerange: ClosedRange<Timestamp>) -> SubSequence { get }
}



struct MIDIEventTrack<Event : MIDIEvent> : Sequence {
    private let ref : MIDITrack
    
    init(ref: MIDITrack) {
        self.ref = ref
    }

    func makeIterator() -> AnyIterator<Event> {
        let i = ref.makeIterator()
        return AnyIterator {
            while let n = i.next() {
                if let nn = n as? Event {
                    return nn
                }
            }
            return nil
        }
    }
}



