//
//  Extensions.swift
//  KoreMIDI
//
//  Created by Adam Nemecek on 4/5/17.
//  Copyright © 2017 Adam Nemecek. All rights reserved.
//

import Foundation
import AudioToolbox

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
    init(_ int: Int) {
        self = int != 0
    }
}

extension CABarBeatTime : CustomStringConvertible {
    public var description : String {
        return "bar: \(bar), beat: \(beat), subbeat: \(subbeat), subbeatDivisor: \(subbeatDivisor)"
    }
}
