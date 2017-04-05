//
//  MIDISequence.swift
//  KoreMIDI
//
//  Created by Adam Nemecek on 4/5/17.
//  Copyright © 2017 Adam Nemecek. All rights reserved.
//

import Foundation
import AudioToolbox

class MIDISequence : Collection, Comparable, Hashable {
    internal let ref : MusicSequence
    typealias Index = Int
    typealias Element = MIDITrack
    
    init() {
        ref = MIDISequenceCreate()
    }
    
    init(path: String) {
        ref = MIDISequenceLoad(path: path)
    }
    
    var startIndex: Index {
        return 0
    }
    
    var endIndex : Index {
        fatalError()
    }

    subscript(index: Index) -> Element {
        fatalError()
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
    
    deinit {
        DisposeMusicSequence(ref)
    }
    
    func export() -> Data {
        fatalError()
    }
    
    var tempoTrack : MIDITrack {
        fatalError()
    }
}
