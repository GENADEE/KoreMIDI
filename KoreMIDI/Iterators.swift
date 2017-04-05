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
    typealias Element = MIDINoteMessage
    private let ref: MusicEventIterator
    
    init(track: MIDITrack) {
        ref = MIDIIteratorCreate(ref : track.ref)
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
        return current()
    }
}

class MIDIEventIterator<Element> : EventIterator {
    
}
