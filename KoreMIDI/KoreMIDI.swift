//
//  KoreMIDI.swift
//  KoreMIDI
//
//  Created by Adam Nemecek on 4/5/17.
//  Copyright © 2017 Adam Nemecek. All rights reserved.
//

import Foundation

import AudioToolbox


class MIDISequence : Collection {
    let ref : MusicSequence
    typealias Index = Int
    typealias Element = MIDITrack
    
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
    
    
    init() {
        ref = CreateMIDISequence()
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

class MIDITrack {
    let ref : MusicTrack
    
    init() {
        ref = CreateMIDITrack()
    }
    
    deinit {
        
    }
}

class EventIterator : IteratorProtocol {
    typealias Element = Int
    private let ref: MusicEventIterator
    
    init(track: MIDITrack) {
        fatalError()
    }
    deinit {
        DisposeMusicEventIterator(ref)
    }
    
    func next() -> Element? {
        fatalError()
    }
}

class MIDIEventIterator<Element> : EventIterator {
    
}


private func CreateMIDISequence() -> MusicSequence {
    var ref : MusicSequence? = nil
    NewMusicSequence(&ref)
    return ref!
}

private func CreateMIDITrack() -> MusicSequence {
    var ref : MusicSequence? = nil
    NewMusicSequence(&ref)
    return ref!
}
