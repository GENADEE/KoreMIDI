//
//  MIDISequence.swift
//  KoreMIDI
//
//  Created by Adam Nemecek on 4/5/17.
//  Copyright © 2017 Adam Nemecek. All rights reserved.
//

import AudioToolbox.MusicPlayer


extension Sequence {
    func split<A,B>(transform: @escaping (Iterator.Element) -> (A,B)) -> AnyIterator<(A,B)> {
        var i = makeIterator()
        return AnyIterator {
            i.next().map { transform($0) }
        }
    }
}

public struct MIDISequence : MutableCollection, Comparable, Hashable, RangeReplaceableCollection {

    public typealias Index = Int
    public typealias IndexDistance = Index
    public typealias Element = MIDITrack

    func copy() -> MIDISequence {
        return MIDISequence(import: export())
    }
    
    public init() {
        _ref = MIDISequenceRef()
//        self.path = nil
    }
    
    public init(path: String) {
        _ref = MIDISequenceRef(path: path)
//        self.path = path
    }
    
    public init(import data: Data) {
        _ref = MIDISequenceRef(import: data)
    }

    public var startIndex: Index {
        return 0
    }
    
    public var count: IndexDistance {
        return MusicSequenceGetTrackCount(ref: ref)
    }
    
    public var endIndex : Index {
        return startIndex + count
    }

    public subscript(index: Index) -> Element {
        get {
            return MIDITrack(seq: _ref, no: index)
        }
        set {
            ensureUnique()
            fatalError()
        }
    }

    public func index(after i: Index) -> Index {
        return i + 1
    }

    private mutating func ensureUnique() {
        if !isKnownUniquelyReferenced(&_ref) {
            _ref = _ref.copy()
        }
    }

    mutating
    public func replaceSubrange<C : Collection>(_ subrange: Range<Index>, with newElements: C) where C.Iterator.Element == Element {
        ensureUnique()
        fatalError()
    }

    public var type : MusicSequenceType {
        get {
            return MusicSequenceGetSequenceType(ref: ref)
        }
//        set {
//            MusicSequenceSetSequenceType(ref, newValue)
//        }
    }

    public static func ==(lhs: MIDISequence, rhs: MIDISequence) -> Bool {
        return lhs._ref == rhs._ref
    }
    
    public static func <(lhs: MIDISequence, rhs: MIDISequence) -> Bool {
        return lhs._ref < rhs._ref
    }
    
    public var hashValue: Int {
        return _ref.hashValue
    }
    
    public func export() -> Data {
        return _ref.export()
    }
    
    public func save(to url: URL) {
        _ref.save(to: url)
    }
    
    public var tempoTrack : MIDITempoTrack {
        return MIDITempoTrack(ref: self)
    }
    
    internal var ref : MusicSequence {
        return _ref.ref
    }
    
    private var _ref: MIDISequenceRef
}


//struct MIDISequenceView<Event: MIDIEvent> : Sequence {
//    
//}
