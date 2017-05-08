//
//  MIDISequence.swift
//  KoreMIDI
//
//  Created by Adam Nemecek on 4/5/17.
//  Copyright © 2017 Adam Nemecek. All rights reserved.
//

import AudioToolbox.MusicPlayer

public struct MIDISequence : MutableCollection, Comparable, Hashable, RangeReplaceableCollection, RandomAccessCollection {

    public typealias Index = Int
    public typealias IndexDistance = Index
    public typealias Element = MIDITrack
    public typealias Timestamp = Element.Timestamp
//    func copy() -> MIDISequence {
//        return MIDISequence(import: export())
//    }

    public init() {
        _impl = Impl()
    }
    
    public init(import url: URL) {
        _impl = Impl(import: url)
    }
    
    public init(import data: Data) {
        _impl = Impl(import: data)
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
            let value = self[index]
        }
    }
    
    public func dict() -> NSDictionary {
        return MusicSequenceGetInfoDictionary(_impl.ref) as NSDictionary
    }

    public func index(after i: Index) -> Index {
        return i + 1
    }

    public func index(before i: Index) -> Index {
        return i - 1
    }

    public var startTime : Timestamp? {
        return _impl.startTime
    }

    public var endTime : Timestamp? {
        return _impl.endTime
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
    
    public func save(to url: URL) throws {
        try _impl.save(to: url)
    }
    
//    public var tempoTrack : MIDITrackImpl {
//        return MIDITrackImpl(tempoTrack: self)
//
//    }
    
    private mutating func _ensureUnique() {
        guard isKnownUniquelyReferenced(&_impl) else { return }
        _impl = _impl.copy()
    }
    
    internal init(impl: Impl) {
        _impl = impl
    }

    internal private(set) var _impl: Impl
    
//    private func _registerCallback() {
//        _impl.register {
//            self._ensureUnique()
//            
//        }
//    }
    
//    private static let _callback: MusicSequenceUserCallback = {
//        // adapted from r9midisequencer
//        ref, seq, mt, timestamp, userData, startTime, endTime in
//        let impl = unsafeBitCast(ref, to: MIDISequenceImpl.self)
//        assert(impl.ref == ref)
//    }
}


//struct MIDISequenceView<Event: MIDIEvent> : Sequence {
//    
//}
