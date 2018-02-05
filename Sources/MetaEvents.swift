//
//  MetaEvents.swift
//  KoreMIDI
//
//  Created by Adam Nemecek on 1/31/18.
//

import Foundation

public protocol MIKMIDIMetaEvent {

}

public protocol MIKMIDIMetaTextEvent : MIKMIDIMetaEvent, MIDITrackEventType {

}

struct MIDIMetaTextEvent {
    let timestamp: MIDITimestamp

    init(ptr: UnsafePointer<Int>) {
        fatalError()
    }
}

//protocol MIDIMetaEvent2 {
//
//    var timestamp: MIDITimestamp { get }
//}

//protocol MIDIMetaTextEvent : MIDIMetaEvent {
//
//}



// not text: key signature, sequence, time signature


