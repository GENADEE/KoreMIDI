//
//  Iterators.swift
//  KoreMIDI
//
//  Created by Adam Nemecek on 4/5/17.
//  Copyright © 2017 Adam Nemecek. All rights reserved.
//

import Foundation
import AudioToolbox

protocol List : Sequence {
    var head: Iterator.Element? { get }
    var tail: SubSequence { get }
}


public class MIDITrackIterator : IteratorProtocol {
    //    typealias MIDITimestamp = Double
//    public typealias Element = (timestamp: MIDITimestamp, event: MIDINoteMessage)
    public typealias Element = MIDIEvent
    
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
    
    internal init(_ content: MIDITrackImpl, timerange: ClosedRange<MusicTimeStamp>) {
        fatalError()
//        self.content = content
//        self.ref = MIDIIteratorCreate(ref : content.ref)
//        self.timerange = timerange
//        timerange.map {
//            self._seek(to: $0.lowerBound)
//        }
    }
    
    deinit {
        DisposeMusicEventIterator(ref)
    }
    
    public var current: Element? {
        while _hasCurrent {
            
            let n = MIDIIteratorGetCurrent(ref: ref)
            
            move()
            return n
            
//            n.data.copyBytes(to: <#T##UnsafeMutableBufferPointer<DestinationType>#>)
//            MusicEventIteratorGetEventInfo(ref, &beats, &type, &data, &size)
//            EventInfo(timestamp: beats, type: type, data: Data(bytes: data, count: Int(size)))
//            
//            if type == kMusicEventType_MIDINoteMessage {
//                let p = data.map {  $0.bindMemory(to: MIDINoteMessage.self, capacity: 1) }!
//                let tt = MIDITimestamp(base: content.parent._impl, beats: beats)
//                if (timerange.map { $0.contains(tt) }) ?? true {
//                    return MIDINote(timestamp: tt, msg: p.pointee)
//                }
//                return nil
//            }

            
        }
        return nil
    }
    
    subscript(element : Element) -> Element {
        get {
            fatalError()
        }
        set {
//            assert(current! == element)
            fatalError()
            
        }
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
//        return MIDITimestamp(base: content.par, beats: current?.timestamp ?? 0)
        fatalError()
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

class TypedMIDIIterator<Event : MIDIEventConvertible> : MIDITrackIterator {
    override func next() -> Element? {
        while let n = super.next() {
            if n.type == Event.type1 {
                return n
            }
        }
        return nil
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
