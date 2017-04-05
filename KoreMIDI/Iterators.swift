//
//  Iterators.swift
//  KoreMIDI
//
//  Created by Adam Nemecek on 4/5/17.
//  Copyright © 2017 Adam Nemecek. All rights reserved.
//

import Foundation
import AudioToolbox

class EventIterator : IteratorProtocol {
    typealias Timestamp = Double
    typealias Element = (timestamp: Timestamp, event: MIDINoteMessage)
    private let ref: MusicEventIterator
    
    private let timerange: ClosedRange<Timestamp>?
    
    init(track: MIDITrack, timerange: ClosedRange<Timestamp>? = nil) {
        self.ref = MIDIIteratorCreate(ref : track.ref)
        self.timerange = timerange
    }
    
    deinit {
        DisposeMusicEventIterator(ref)
    }
    
    
    func current() -> Element? {
        fatalError()
    }
    
    func remove() {
        //
    }
    
    
    
    func seek(to timestamp: Timestamp ) {
        
        
    }
    
    
    private func move() {
        fatalError()
    }
    
    func next() -> Element? {
        defer {
            move()
        }
        timerange
        return current()
    }
}

class MIDIEventIterator<Element> : EventIterator {
    
}
