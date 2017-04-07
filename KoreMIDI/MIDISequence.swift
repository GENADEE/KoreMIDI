//
//  MIDISequence.swift
//  KoreMIDI
//
//  Created by Adam Nemecek on 4/5/17.
//  Copyright © 2017 Adam Nemecek. All rights reserved.
//

import AudioToolbox

public struct MIDISequence : Collection, Comparable, Hashable {

    public typealias Index = Int
    public typealias IndexDistance = Int
    public typealias Element = MIDITrack

    internal init() {
        _ref = Ref()
//        self.path = nil
    }
    
    internal init(path: String) {
        _ref = Ref(path: path)
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
        return MIDITrack(seq: self, no: index)
    }

    public func index(after i: Index) -> Index {
        return i + 1
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
        return lhs.ref == rhs.ref
    }
    
    public static func <(lhs: MIDISequence, rhs: MIDISequence) -> Bool {
        return lhs.hashValue < rhs.hashValue
    }
    
    public var hashValue: Int {
        return ref.hashValue
    }
    
    public func export() -> Data {
        return MusicSequenceCreateData(ref: ref)
    }
    
    public var tempoTrack : MIDITempoTrack {
        return MIDITempoTrack(ref: self)
    }
    
    internal var ref : MusicSequence {
        return _ref.ref
    }

    private class Ref {
        internal let ref : MusicSequence
        
        init() {
            ref = MIDISequenceCreate()
            
        }
        
        init(path: String) {
            ref = MIDISequenceLoad(path: path)
            
        }
        deinit {
            DisposeMusicSequence(ref)
        }
    }
    
    private let _ref: Ref
    //            let path: String?
}


//struct MIDISequenceView<Event: MIDIEvent> : Sequence {
//    
//}
