//
//  Iterators.swift
//  KoreMIDI
//
//  Created by Adam Nemecek on 4/5/17.
//  Copyright © 2017 Adam Nemecek. All rights reserved.
//

import AVFoundation

public class MIDIIterator: IteratorProtocol {
    public typealias Timestamp = MIDITimestamp
    public typealias Element = MIDINote

    internal init(_ content: MIDITrack, timestamp: Timestamp? = nil) {
        self.ref = MIDIIteratorCreate(ref : content.ref)
        timestamp.map {
            self.seek(to: $0)
        }
    }

    deinit {
        DisposeMusicEventIterator(ref)
    }

    public final var current: Element? {
        get {
            fatalError()
        }
        set {
            fatalError()
        }
//        return MIDIIteratorGetCurrent(ref: ref)
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
            MusicEventIteratorDeleteEvent(ref)
        }
        return current
    }

    public func next() -> Element? {
        defer {
            fwd()
        }
        return current
    }

    public final func seek(to timestamp: Timestamp) {
        MusicEventIteratorSeek(ref, timestamp.beats)
    }

    @inline(__always)
    fileprivate func fwd() {
        MusicEventIteratorNextEvent(ref)
    }

    @inline(__always)
    fileprivate func bwd() {
        MusicEventIteratorPreviousEvent(ref)
    }

    private let ref: MusicEventIterator


//    private let _timerange: Range<Timestamp>?
}


internal final class MIDIDataIterator: IteratorProtocol {
    public typealias Timestamp = MIDITimestamp
    public typealias Element = MIDIData

    internal init(_ content: MIDITrack) {
        self.ref = MIDIIteratorCreate(ref : content.ref)
    }

    deinit {
        DisposeMusicEventIterator(ref)
    }

    final var current: Element? {
        get {
            return Element(ref: ref)
        }
        set {
            if let event = newValue {
                if event.timestamp == current?.timestamp {
                    _ = event.data.baseAddress.map {
                        MusicEventIteratorSetEventInfo(ref, event.type.rawValue, $0)
                    }
                }
                else {
                    /// note that this moved the pointer to the next event
                    MusicEventIteratorSetEventTime(ref, MusicTimeStamp(event.timestamp.beats))
                }
            }
            else {
                _ = remove()
            }
        }
    }

    final func remove() -> Element? {
        defer {
            MusicEventIteratorDeleteEvent(ref)
        }
        return current
    }

    final func next() -> Element? {
        defer {
            fwd()
        }
        return current
    }

    final func seek(to timestamp: Timestamp) {
        MusicEventIteratorSeek(ref, timestamp.beats)
    }

    private var hasNext: Bool {
        var ret: DarwinBoolean = false
        OSAssert(MusicEventIteratorHasNextEvent(ref, &ret))
        return ret.boolValue
    }

    private var hasPrevious: Bool {
        var ret: DarwinBoolean = false
        OSAssert(MusicEventIteratorHasNextEvent(ref, &ret))
        return ret.boolValue
    }

    @inline(__always)
    fileprivate func fwd() {
        guard hasNext else { return }
        OSAssert(MusicEventIteratorNextEvent(ref))
    }

    @inline(__always)
    fileprivate func bwd() {
        guard hasPrevious else { return }
        OSAssert(MusicEventIteratorPreviousEvent(ref))
    }

    private let ref: MusicEventIterator
}

public class MIDIRangeIterator : MIDIIterator {
    public let timerange : Range<Timestamp>

    internal init(_ content: MIDITrack, timerange: Range<Timestamp>) {
        self.timerange = timerange
        super.init(content)
        self.seek(to: timerange.lowerBound)
    }

    public override func next() -> Element? {
        return super.next().flatMap {
            guard self.timerange.contains($0.timestamp) else { return nil }
            return $0
        }
    }
}

//struct MIDIEventIterator<Event: EventType> {
//
//}

