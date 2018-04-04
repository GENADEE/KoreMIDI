//
//  UnsafePointer.swift
//  KoreMIDI
//
//  Created by Adam Nemecek on 2/5/18.
//

import Foundation

//import AudioToolbox.MusicPlayer

//protocol EventPointer {
//    mutating
//    func insert(to ref: MIDITrack, at timestamp: Double)
//}

//extension UnsafePointer where Pointee : MIDITrackEvent {
//    func insert(to ref: MIDITrack, at timestamp: Double) {
//        switch pointee.self {
//        case ExtendedNoteOnEvent.self:
//            MusicTrackNewExtendedNoteEvent(ref.ref, timestamp, self)
//        default:
//            fatalError()
//        }
//    }
//}

//extension ExtendedNoteOnEvent : EventPointer {
//    internal mutating func insert(to ref: MIDITrack, at timestamp: Double) {
//        MusicTrackNewExtendedNoteEvent(ref.ref, timestamp, &self)
//    }
//}

//extension UnsafePointer where Pointee == ExtendedTempoEvent {
//    internal func insert(to ref: MIDITrack, at timestamp: Double) {
//        MusicTrackNewExtendedTempoEvent(ref.ref, timestamp, pointee.bpm)
//    }
//}
//
//extension UnsafePointer where Pointee == MusicEventUserData {
//    internal func insert(to ref: MIDITrack, at timestamp: Double) {
//        MusicTrackNewUserEvent(ref.ref, timestamp, self)
//    }
//}
//
//extension UnsafePointer where Pointee == AudioToolbox.MIDIMetaEvent {
//    internal func insert(to ref: MIDITrack, at timestamp: Double) {
//        MusicTrackNewMetaEvent(ref.ref, timestamp, self)
//    }
//}
//
//extension UnsafePointer where Pointee == MIDINoteMessage {
//    internal func insert(to ref: MIDITrack, at timestamp: Double) {
//        MusicTrackNewMIDINoteEvent(ref.ref, timestamp, self)
//    }
//}
//
//extension UnsafePointer where Pointee == MIDIChannelMessage {
//    internal func insert(to ref: MIDITrack, at timestamp: Double) {
//        MusicTrackNewMIDIChannelEvent(ref.ref, timestamp, self)
//    }
//}
//
//extension UnsafePointer where Pointee == MIDIRawData {
//    internal func insert(to ref: MIDITrack, at timestamp: Double) {
//        MusicTrackNewMIDIRawDataEvent(ref.ref, timestamp, self)
//    }
//}
//
//extension UnsafePointer where Pointee == ParameterEvent {
//    internal func insert(to ref: MIDITrack, at timestamp: Double) {
//        MusicTrackNewParameterEvent(ref.ref, timestamp, self)
//    }
//}
//
//extension UnsafePointer where Pointee == AUPresetEvent {
//    internal func insert(to ref: MIDITrack, at timestamp: Double) {
//        MusicTrackNewAUPresetEvent(ref.ref, timestamp, self)
//    }
//}

//extension UnsafePointer where Pointee == ExtendedControlEvent {
//    internal func insert(to ref: MIDITrack, at timestamp: Double) {
//        MusicTrackNewExtendedNoteEvent(ref.ref, timestamp, self)
//    }
//}

