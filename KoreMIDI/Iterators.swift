//
//  Iterators.swift
//  KoreMIDI
//
//  Created by Adam Nemecek on 4/5/17.
//  Copyright © 2017 Adam Nemecek. All rights reserved.
//

import Foundation
import AudioToolbox

extension Bool {
    init(_ value: DarwinBoolean) {
        fatalError()
    }
}

class EventIterator : IteratorProtocol {
    typealias Timestamp = Double
    typealias Element = (timestamp: Timestamp, event: MIDINoteMessage)
    private let ref: MusicEventIterator
    
    private let timerange: ClosedRange<Timestamp>?
    
    init(_ content: MIDITrack, timerange: ClosedRange<Timestamp>? = nil) {
        self.ref = MIDIIteratorCreate(ref : content.ref)
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
    
    
    private var _hasCurrent: Bool {
        var bool : DarwinBoolean = false
        MusicEventIteratorHasCurrentEvent(ref, &bool)
        return Bool(bool)
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
//        timerange
        return current()
    }
}

struct MIDIEventTrackView<Element : MIDIEvent> : Sequence {
    typealias Timestamp = Double
    let content: MIDITrack
    let timerange: ClosedRange<Timestamp>?
    
    init(content: MIDITrack, timerange: ClosedRange<Timestamp>? = nil) {
        self.content = content
        self.timerange = timerange
    }
    
    func makeIterator() -> AnyIterator<Element> {
        let i = EventIterator(content, timerange: timerange)
        
        return AnyIterator {
            while let n = i.next() {
                if let nn = n as? Element {
                    return nn
                }
            }
            return nil
        }
    }
}
