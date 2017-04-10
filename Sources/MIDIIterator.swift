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


public class MIDIIterator : IteratorProtocol {
    //    typealias MIDITimestamp = Double
//    public typealias Element = (timestamp: MIDITimestamp, event: MIDINoteMessage)
    public typealias Element = MIDIEvent
    
    private let _ref: MusicEventIterator
    private let _content: MIDITrackImpl

    private let timerange: Range<MIDITimestamp>?
    
    internal init(_ content: MIDITrackImpl, timerange: Range<MIDITimestamp>? = nil) {
        self._content = content
        self._ref = MIDIIteratorCreate(ref : _content.ref)
        self.timerange = timerange
        timerange.map {
            self._seek(to: $0.lowerBound)
        }
    }
    
    internal init(_ content: MIDITrackImpl, timerange: Range<MusicTimeStamp>) {
        fatalError()
//        self.content = content
//        self.ref = MIDIIteratorCreate(ref : content.ref)
//        self.timerange = timerange
//        timerange.map {
//            self._seek(to: $0.lowerBound)
//        }
    }
    
    deinit {
        DisposeMusicEventIterator(_ref)
    }
    
    public final var current: Element? {
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
    
    private var timestamp: MIDITimestamp? {
//        return MIDITimestamp(base: content.par, beats: current?.timestamp ?? 0)
        fatalError()
    }

    private func _seek(to timestamp: MIDITimestamp) {
        MusicEventIteratorSeek(_ref, timestamp.beats)
    }
    
    private func _move() {
        MusicEventIteratorNextEvent(_ref)
    }
    
    public func next() -> Element? {
        defer {
            _move()
        }
        return current
        
    }
}


class MIDIEventIterator<Event : MIDIEventConvertible> : MIDIIterator {
    final override func next() -> Element? {
        while let n = super.next() {
            if n.type == Event.type1 {
                return n
            }
        }
        return nil
    }
}




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
