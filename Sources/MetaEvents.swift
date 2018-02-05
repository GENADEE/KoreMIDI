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

// not text: key signature, sequence, time signature


