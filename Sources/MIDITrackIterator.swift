//
//  Iterators.swift
//  KoreMIDI
//
//  Created by Adam Nemecek on 4/5/17.
//  Copyright © 2017 Adam Nemecek. All rights reserved.
//

import Foundation
import AudioToolbox

public class MIDITrackIterator : IteratorProtocol {
    //    typealias MIDITimestamp = Double
    public typealias Element = (timestamp: MIDITimestamp, event: MIDINoteMessage)
    
    private let ref: MusicEventIterator
    private let content: MIDITrackImpl

    private let timerange: ClosedRange<MIDITimestamp>?
    
    internal init(_ content: MIDITrackImpl, timerange: ClosedRange<MIDITimestamp>? = nil) {
        self.content = content
        self.ref = MIDIIteratorCreate(ref : content.ref)
        self.timerange = timerange
        timerange.map {
            self._seek(to: $0.lowerBound)
        }
    }
    
    deinit {
        DisposeMusicEventIterator(ref)
    }
    
    public var current: Element? {
        var beats: Double = 0
        var type: MusicEventType = 0
        var data : UnsafeRawPointer? = nil
        var size : UInt32 = 0
        while _hasCurrent {
            
            MusicEventIteratorGetEventInfo(ref, &beats, &type, &data, &size)
            if type == kMusicEventType_MIDINoteMessage {
                let p = data.map {  $0.bindMemory(to: MIDINoteMessage.self, capacity: 1) }!
                let tt = MIDITimestamp(base: content.parent, beats: beats)
                if (timerange.map { $0.contains(tt) }) ?? true {
                    return (tt, p.pointee)
                }
                return nil
            }
            move()
        }
        return nil
    }
    
//    func current1() -> Element? {
//        
//        while _hasCurrent {
//            let e = MIDIIteratorGetCurrent(ref: ref)
//            if e?.type == kMusicEventType_MIDINoteMessage{
//                
//            }
//            MusicEventIteratorGetEventInfo(ref, &beats, &type, &data, &size)
//            if type == kMusicEventType_MIDINoteMessage {
//                let p = data.map {  $0.bindMemory(to: MIDINoteMessage.self, capacity: 1) }!
//                let tt = MIDITimestamp(base: content.parent, beats: beats)
//                return (tt, p.pointee)
//            }
//            move()
//        }
//        return nil
//    }
    
    public func remove() {
        //
    }
    
    private var timestamp: MIDITimestamp? {
        return current?.timestamp
    }
    
    private var _hasCurrent: Bool {
        return MIDIIteratorHasCurrent(ref: ref)
    }
    
    private func _seek(to timestamp: MIDITimestamp) {
        MusicEventIteratorSeek(ref, timestamp.beats)
    }
    
    private func move() {
        MusicEventIteratorNextEvent(ref)
    }
    
    public func next() -> Element? {
        defer {
            move()
        }
        return current
        
    }
}

class TypedMIDIIterator<Element> : MIDITrackIterator {
    override func next() -> Element? {
        return super.next()
    }
}

//class MIDITrackFilteringIterator : MIDITrackIterator {
//    public init(_ content: MIDITrack, timerange: ClosedRange<MIDITimestamp>? = nil, predicate: (Element) -> Bool) {
//        
//    }
//}

//struct MIDIEventTrackView<Element : MIDIEvent> : Sequence {
//    
//    let content: MIDITrack
//    let timerange: ClosedRange<MIDITimestamp>?
//    
//    init(content: MIDITrack, timerange: ClosedRange<MIDITimestamp>? = nil) {
//        self.content = content
//        self.timerange = timerange
//    }
//    
//    func makeIterator() -> AnyIterator<Element> {
//        let i = MIDITrackIterator(content, timerange: timerange)
//        
//        return AnyIterator {
//            while let n = i.next() {
//                if let nn = n as? Element {
//                    return nn
//                }
//            }
//            return nil
//        }
//    }
//}
