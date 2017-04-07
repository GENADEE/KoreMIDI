//
//  MIDISequence.swift
//  KoreMIDI
//
//  Created by Adam Nemecek on 4/5/17.
//  Copyright © 2017 Adam Nemecek. All rights reserved.
//

import AudioToolbox.MusicPlayer

public struct MIDISequence : MutableCollection, Comparable, Hashable, RangeReplaceableCollection {

    public typealias Index = Int
    public typealias IndexDistance = Index
    public typealias Element = MIDITrack

    public init() {
        _ref = MIDISequenceRef()
//        self.path = nil
    }
    
    public init(path: String) {
        _ref = MIDISequenceRef(path: path)
//        self.path = path
    }
    
    public init(import: Data) {
        fatalError()
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
            return MIDITrack(seq: self, no: index)
        }
        set {
            fatalError()
        }
    }

    public func index(after i: Index) -> Index {
        return i + 1
    }
    
    mutating
    public func replaceSubrange<C : Collection>(_ subrange: Range<Index>, with newElements: C) where C.Iterator.Element == Element {
        fatalError()
    }

    public var type : MusicSequenceType {
        get {
            return MusicSequenceGetSequenceType(ref: ref)
        }
        set {
            MusicSequenceSetSequenceType(ref, newValue)
        }
    }

    public static func ==(lhs: MIDISequence, rhs: MIDISequence) -> Bool {
        return lhs._ref == rhs._ref
    }
    
    public static func <(lhs: MIDISequence, rhs: MIDISequence) -> Bool {
        return lhs._ref < rhs._ref
    }
    
    public var hashValue: Int {
        return ref.hashValue
    }
    
    public func export() -> Data {
        return MusicSequenceCreateData(ref: ref)
    }
    
    public func save(to: URL) {
        fatalError()
    }
    
    public var tempoTrack : MIDITempoTrack {
        return MIDITempoTrack(ref: self)
    }
    
    internal var ref : MusicSequence {
        return _ref.ref
    }
    
    private let _ref: MIDISequenceRef
}


//struct MIDISequenceView<Event: MIDIEvent> : Sequence {
//    
//}
