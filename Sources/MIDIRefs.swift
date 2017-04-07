//
//  Disposables.swift
//  KoreMIDI
//
//  Created by Adam Nemecek on 4/5/17.
//  Copyright © 2017 Adam Nemecek. All rights reserved.
//

import Foundation

import AudioToolbox.MusicPlayer

protocol MIDIRef : class {
    init(ref: OpaquePointer)
}
//
//struct MIDITrack : Disposable {
//    private let ref : MusicTrack
//    
//    func dispose() {
//        MusicTrack
//    }
//}

internal class MIDITrackRef : Hashable, Comparable {
    private let ref: MusicTrack

    internal init(seq: MIDISequence) {
        ref = MIDITrackCreate(ref: seq.ref)
    }

    deinit {
        
    }
    
    internal static func ==(lhs: MIDITrackRef, rhs: MIDITrackRef) -> Bool {
        return lhs.ref == rhs.ref
    }
    
    internal static func <(lhs: MIDITrackRef, rhs: MIDITrackRef) -> Bool {
        return lhs.hashValue < rhs.hashValue
    }
    
    internal var hashValue: Int {
        return ref.hashValue
    }
}

internal class MIDISequenceRef : Hashable, Comparable {
    internal let ref : MusicSequence
    
    internal init() {
        ref = MIDISequenceCreate()
        
    }
    
    internal init(path: String) {
        ref = MIDISequenceLoad(path: path)
        
    }
    deinit {
        DisposeMusicSequence(ref)
    }
    
    internal static func ==(lhs: MIDISequenceRef, rhs: MIDISequenceRef) -> Bool {
        return lhs.ref == rhs.ref
    }
    
    internal static func <(lhs: MIDISequenceRef, rhs: MIDISequenceRef) -> Bool {
        return lhs.hashValue < rhs.hashValue
    }
    
    internal var hashValue: Int {
        return ref.hashValue
    }
}

//internal class MIDITrackIteratorRef {
//    private let ref : MusicEventIterator
//    
//}
//
//class MIDITrackRef : MIDIRef {
//    deinit {
//
//    }
//}


