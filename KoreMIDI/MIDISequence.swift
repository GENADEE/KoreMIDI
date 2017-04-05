//
//  MIDISequence.swift
//  KoreMIDI
//
//  Created by Adam Nemecek on 4/5/17.
//  Copyright © 2017 Adam Nemecek. All rights reserved.
//

import Foundation
import AudioToolbox

@inline(__always)
func MusicSequenceGetTrackCount(ref: MusicSequence) -> Int {
    var c: UInt32 = 0
    MusicSequenceGetTrackCount(ref, &c)
    return Int(c)
}

struct MIDISequence : Collection, Comparable, Hashable {
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
    
    internal var ref : MusicSequence {
        return _ref.ref
    }

    typealias Index = Int
    typealias IndexDistance = Int
    typealias Element = MIDITrack
    
    init() {
        _ref = Ref()
//        self.path = nil
    }
    
    init(path: String) {
        _ref = Ref(path: path)
//        self.path = path
    }
    
    init(import: Data) {
        fatalError()
    }
    
    var startIndex: Index {
        return 0
    }
    
    var count: IndexDistance {
        return MusicSequenceGetTrackCount(ref: ref)
    }
    
    var endIndex : Index {
        return startIndex + count
    }

    subscript(index: Index) -> Element {
        return MIDITrack(seq: self, no: index)
    }

    func index(after i: Index) -> Index {
        return i + 1
    }

    var type : MusicSequenceType {
        get {
            //MusicSequenceGetSequenceType
            fatalError()
        }
        set {
        
        }
    }
    
    static func ==(lhs: MIDISequence, rhs: MIDISequence) -> Bool {
        return lhs.ref == rhs.ref
    }
    
    static func <(lhs: MIDISequence, rhs: MIDISequence) -> Bool {
        return lhs.hashValue < rhs.hashValue
    }
    
    var hashValue: Int {
        return ref.hashValue
    }
    
    func export() -> Data {
        fatalError()
    }
    
    var tempoTrack : MIDITrack {
        fatalError()
    }
}
