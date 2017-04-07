//
//  Extensions.swift
//  KoreMIDI
//
//  Created by Adam Nemecek on 4/5/17.
//  Copyright © 2017 Adam Nemecek. All rights reserved.
//

import AudioToolbox.MusicPlayer

extension ClosedRange {
    func union(_ other: ClosedRange) -> ClosedRange<Bound>{
        let s = [lowerBound, upperBound, other.lowerBound, other.upperBound].sorted()
        return s.first!...s.last!
    }
}

extension Int {
    init(_ bool: Bool) {
        self = bool ? 1 : 0
    }
}

extension Bool {
    init(_ value: DarwinBoolean) {
        self = value.boolValue ? true : false
    }
}

extension Bool {
    init(_ int: Int) {
        self = int != 0
    }
}

extension Sequence {
    func reduce(combine: (Iterator.Element, Iterator.Element) throws -> Iterator.Element) rethrows -> Iterator.Element? {
        var g = makeIterator()
        guard var accu = g.next() else { return nil }
        
        while let next = g.next() {
            accu = try combine(accu, next)
        }
        return accu
    }
}

extension CABarBeatTime : CustomStringConvertible {
    public var description : String {
        return "bar: \(bar), beat: \(beat), subbeat: \(subbeat), subbeatDivisor: \(subbeatDivisor)"
    }
}
