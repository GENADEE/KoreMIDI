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
    
    func next() -> Element? {
        fatalError()
    }
}

class MIDIEventIterator<Element> : EventIterator {
    
}
