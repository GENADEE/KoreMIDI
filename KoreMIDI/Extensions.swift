//
//  Extensions.swift
//  KoreMIDI
//
//  Created by Adam Nemecek on 4/5/17.
//  Copyright © 2017 Adam Nemecek. All rights reserved.
//

import Foundation

extension ClosedRange {
    func union(_ other: ClosedRange) -> ClosedRange<Bound>{
        let s = [lowerBound, upperBound, other.lowerBound, other.upperBound].sorted()
        return s.first!...s.last!
    }
    
//    init<S: Sequence>(_ seq: S) where S.Iterator.Element :
}
