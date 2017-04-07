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
        _impl = MIDISequenceImpl()
//        self.path = nil
    }
    
    public init(path: String) {
        _impl = MIDISequenceImpl(path: path)
//        self.path = path
    }
    
    public init(import data: Data) {
        _impl = MIDISequenceImpl(import: data)
    }
    
    public var startIndex: Index {
        return _impl.startIndex
    }
    
    public var endIndex : Index {
        return _impl.endIndex
    }

    public subscript(index: Index) -> Element {
        get {
            return MIDITrack(seq: _impl, no: index)
        }
        set {
            _ensureUnique()
            fatalError()
        }
    }

    public func index(after i: Index) -> Index {
        return i + 1
    }

    private mutating func _ensureUnique() {
        if !isKnownUniquelyReferenced(&_impl) {
            _impl = _impl.copy()
        }
    }

    mutating
    public func replaceSubrange<C : Collection>(_ subrange: Range<Index>, with newElements: C) where C.Iterator.Element == Element {
        _ensureUnique()
        fatalError()
    }

    public var type : MusicSequenceType {
        get {
            return _impl.type
        }
//        set {
//            MusicSequenceSetSequenceType(ref, newValue)
//        }
    }

    public static func ==(lhs: MIDISequence, rhs: MIDISequence) -> Bool {
        return lhs._impl == rhs._impl
    }
    
    public static func <(lhs: MIDISequence, rhs: MIDISequence) -> Bool {
        return lhs._impl < rhs._impl
    }
    
    public var hashValue: Int {
        return _impl.hashValue
    }
    
    public func export() -> Data {
        return _impl.export()
    }
    
    public func save(to url: URL) {
        _impl.save(to: url)
    }
    
    public var tempoTrack : MIDITempoTrack {
        return MIDITempoTrack(ref: self)
    }
    
    internal var ref : MusicSequence {
        return _impl.ref
    }
    
    private var _impl: MIDISequenceImpl
}


//struct MIDISequenceView<Event: MIDIEvent> : Sequence {
//    
//}
