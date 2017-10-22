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
    init(timerange: Range<MusicTimeStamp>) {
        lowerBound = MIDITimestamp(beats: timerange.lowerBound)
        upperBound = MIDITimestamp(beats: timerange.upperBound)
    }
}

public class MIDIIterator: IteratorProtocol {
    public typealias Timestamp = MIDITimestamp
    public typealias Element = MIDIEvent<Timestamp>

    internal init(_ content: MIDITrack) {
        self._content = content
        self._ref = MIDIIteratorCreate(ref : content.ref)
        //self._timerange = timerange
//        timerange.map {
//            self._seek(to: $0.lowerBound)
//        }
    }

    deinit {
        DisposeMusicEventIterator(_ref)
    }

    private var _current: Element? {
        return MIDIIteratorGetCurrent(ref: _ref)
//        if let e : Element = MIDIIteratorGetCurrent(ref: _ref) {
//            if let r = _timerange, !r.contains(e.timestamp) {
//                return nil
//            }
//            return e
//        }
//        return nil
    }

    internal func remove() -> Element? {
        defer {
            MusicEventIteratorDeleteEvent(_ref)
        }
        return _current
    }

    public func next() -> Element? {
        while let event = _current {
            _move()
            return event
        }
        return nil
    }

    fileprivate func _seek(to timestamp: Timestamp) {
        MusicEventIteratorSeek(_ref, timestamp.beats)
    }

    fileprivate func _move() {
        MusicEventIteratorNextEvent(_ref)
    }


    private let _ref: MusicEventIterator
    private let _content: MIDITrack

//    private let _timerange: Range<Timestamp>?
}

class MIDIRangeIterator : MIDIIterator {
    let timerange : Range<Timestamp>

    internal init(_ content: MIDITrack, timerange: Range<Timestamp>) {
        self.timerange = timerange
        super.init(content)
        _seek(to: timerange.lowerBound)
    }

    public override func next() -> Element? {
        fatalError()
    }
}

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
