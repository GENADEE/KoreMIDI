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
        self = value.boolValue ? true : false
    }
}

class MIDITrackIterator : IteratorProtocol {
    typealias Timestamp = Double
    typealias Element = (timestamp: Timestamp, event: MIDINoteMessage)
    private let ref: MusicEventIterator
    
    private let timerange: ClosedRange<Timestamp>?
    
    init(_ content: MIDITrack, timerange: ClosedRange<Timestamp>? = nil) {
        self.ref = MIDIIteratorCreate(ref : content.ref)
        self.timerange = timerange
        timerange.map {
            self.seek(to: $0.lowerBound)
        }
    }
    
    deinit {
        DisposeMusicEventIterator(ref)
    }
    
    
    func current() -> Element? {
        var ts: Timestamp = 0
        var type: MusicEventType = 0
        var data : UnsafeRawPointer? = nil
        var size : UInt32 = 0
        while _hasCurrent {
            
            MusicEventIteratorGetEventInfo(ref, &ts, &type, &data, &size)
            if type == kMusicEventType_MIDINoteMessage {
                let p = data.map {  $0.bindMemory(to: MIDINoteMessage.self, capacity: 1) }!

                return (ts, p.pointee)
            }
            move()
        }
        return nil
    }
    
    func remove() {
        //
    }
    
    
    private var _hasCurrent: Bool {
        var bool : DarwinBoolean = false
        MusicEventIteratorHasCurrentEvent(ref, &bool)
        return Bool(bool)
    }
    
    private func seek(to timestamp: Timestamp ) {
        MusicEventIteratorSeek(ref, timestamp)
    }
    
    
    private func move() {
        MusicEventIteratorNextEvent(ref)
    }
    

    func next() -> Element? {
        defer {
            move()
        }
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
        let i = MIDITrackIterator(content, timerange: timerange)
        
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
