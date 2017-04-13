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

extension Range where Bound == MIDITimestamp {
    init(base: MIDITimestamp.Base, timerange: Range<MusicTimeStamp>) {
        lowerBound = MIDITimestamp(base: base, beats: timerange.lowerBound)
        upperBound = MIDITimestamp(base: base, beats: timerange.upperBound)
    }
}


public class MIDIIterator: IteratorProtocol {
    public typealias Timestamp = MusicTimeStamp
    public typealias Element = (ts: MusicTimeStamp, type: MIDIEventType, data: Data)
    
    internal init(_ content: MIDITrack.Impl, timerange: Range<Timestamp>? = nil) {
        self._content = content
        self._ref = MIDIIteratorCreate(ref : content.ref)
        self._timerange = timerange
        timerange.map {
            self._seek(to: $0.lowerBound)
        }
    }
    
//    internal init(_ content: MIDITrack.Impl, timerange: Range<Timestamp>) {
//        self._content = content
//        self._ref = MIDIIteratorCreate(ref: _content.ref)
//        self._timerange = timerange
//        self._seek(to: _timerange!.lowerBound)
//    }
    
    deinit {
        DisposeMusicEventIterator(_ref)
    }
    
    private final var _current: Element? {
        return MIDIIteratorGetCurrent(ref: _ref)
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
    
    public func remove() {
        //
    }
    
    public func next() -> Element? {
        while let event = _current {
            _move()
            return event
        }
        return nil
    }
    
    private var timestamp: Timestamp? {
        //        return MIDITimestamp(base: content.par, beats: current?.timestamp ?? 0)
        fatalError()
    }
    
    private func _seek(to timestamp: Timestamp) {
        MusicEventIteratorSeek(_ref, timestamp)
    }
    
    private func _move() {
        MusicEventIteratorNextEvent(_ref)
    }
    
    
    private let _ref: MusicEventIterator
    private let _content: MIDITrack.Impl
    
    private let _timerange: Range<Timestamp>?
}


//class MIDIEventIterator<Event : MIDIEventConvertible> : MIDIIterator {
//    final override func next() -> Element? {
//        while let n = super.next() {
//            if n.type == Event.type {
//                return n
//            }
//        }
//        return nil
//    }
//}




//class MIDITrackFilteringIterator : MIDIIterator {
//    public init(_ content: MIDITrack, timerange: Range<MIDITimestamp>? = nil, predicate: (Element) -> Bool) {
//
//    }
//}

//struct MIDIEventTrackView<Element : MIDIEvent> : Sequence {
//
//    let content: MIDITrack
//    let timerange: Range<MIDITimestamp>?
//
//    init(content: MIDITrack, timerange: Range<MIDITimestamp>? = nil) {
//        self.content = content
//        self.timerange = timerange
//    }
//
//    func makeIterator() -> AnyIterator<Element> {
//        let i = MIDIIterator(content, timerange: timerange)
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
