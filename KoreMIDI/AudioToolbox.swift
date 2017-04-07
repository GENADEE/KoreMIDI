//
//  AudioToolbox.swift
//  KoreMIDI
//
//  Created by Adam Nemecek on 4/5/17.
//  Copyright © 2017 Adam Nemecek. All rights reserved.
//

import AudioToolbox

///
/// Sequences
///

@inline(__always) internal
func MIDISequenceCreate() -> MusicSequence {
    var ref : MusicSequence? = nil
    NewMusicSequence(&ref)
    return ref!
}

@inline(__always) internal
func MIDISequenceLoad(path: String) -> MusicSequence {
    let seq = MIDISequenceCreate()
    let url = URL(fileURLWithPath: path) as CFURL
    MusicSequenceFileLoad(seq, url, .midiType, .smf_ChannelsToTracks)
    return seq
}

@inline(__always) internal
func MusicSequenceGetTrackCount(ref: MusicSequence) -> Int {
    var c: UInt32 = 0
    MusicSequenceGetTrackCount(ref, &c)
    return Int(c)
}

@inline(__always) internal
func MusicSequenceGetIndTrack(ref: MusicSequence, no: Int) -> MusicTrack {
    var r : MusicTrack? = nil
    MusicSequenceGetIndTrack(ref, UInt32(no), &r)
    return r!
}

@inline(__always) internal
func MusicSequenceBeatsToSeconds(ref: MusicSequence, beats: MusicTimeStamp) -> Float64 {
    var out: Float64 = 0
    MusicSequenceGetSecondsForBeats(ref, beats, &out)
    return out
}

@inline(__always) internal
func MusicSequenceSecondsToBeats(ref: MusicSequence, seconds: MusicTimeStamp) -> Float64 {
    var out: MusicTimeStamp = 0
    MusicSequenceGetBeatsForSeconds(ref, seconds, &out)
    return out
}

@inline(__always) internal
func MusicSequenceGetSequenceType(ref: MusicSequence) -> MusicSequenceType {
    var out: MusicSequenceType = .beats
    MusicSequenceGetSequenceType(ref, &out)
    return out
}

@inline(__always) internal
func MusicSequenceCreateData(ref: MusicSequence, resolution: Int = 480) -> Data {
    var data: Unmanaged<CFData>? = nil
    fatalError()
//    MusicSequenceFileCreateData(ref, .midiType, .eraseFile, Int16(resolution), &data)
//    return (data?.takeRetainedValue() as! Data)
}

///
/// Iterators
///

@inline(__always) internal
func MIDIIteratorCreate(ref: MusicTrack) -> MusicEventIterator {
    var r: MusicEventIterator? = nil
    NewMusicEventIterator(ref, &r)
    return r!
}

@inline(__always) internal
func MIDIIteratorHasCurrent(ref: MusicEventIterator) -> Bool {
    var bool : DarwinBoolean = false
    MusicEventIteratorHasCurrentEvent(ref, &bool)
    return Bool(bool)
}

@inline(__always) internal
func MIDIIteratorGetCurrent(ref: MusicEventIterator) -> (beats: Double, type: MIDIEventType, data: UnsafeRawPointer?, size: UInt32)? {
    var beats: Double = 0
    var type: MusicEventType = 0
    var data : UnsafeRawPointer? = nil
    var size : UInt32 = 0
    
    MusicEventIteratorGetEventInfo(ref, &beats, &type, &data, &size)
    return (beats, MIDIEventType(rawValue: type)!, data, size)
}

///
/// Tracks
///

@inline(__always) internal
func MIDITrackCreate(ref: MusicSequence) -> MusicTrack {
    fatalError()
}

@inline(__always) internal
func MIDITrackGetProperty(ref: MusicTrack, prop: UInt32) -> Int {
    var data: UInt32 = 0
    var len : UInt32 = 0
    MusicTrackGetProperty(ref, prop, &data, &len)
    return Int(data)
}

@inline(__always) internal
func MIDITrackSetProperty(ref: MusicTrack, prop: UInt32, to: Int) {
    var data = UInt32(to)
    MusicTrackSetProperty(ref, prop, &data, UInt32(MemoryLayout<UInt32>.size))
}

@inline(__always) internal
func MusicSequenceBeatsToBarBeatTime(ref: MusicSequence, beats: MusicTimeStamp, _ subdivisor: UInt32) -> CABarBeatTime {
    var t = CABarBeatTime()
    MusicSequenceBeatsToBarBeatTime(ref, beats, subdivisor, &t)
    return t
}

protocol MIDIEvent {
    static var type : MIDIEventType { get }
    func add(to: MIDITrack, at timestamp: Timestamp)
}

extension MIDINoteMessage : MIDIEvent, Hashable, Comparable, CustomStringConvertible {
    
    public static var type : MIDIEventType {
        return .note
    }
    
    public var description: String {
        return "MIDIMsg(\(note), duration: \(duration))"
    }
    
    public func add(to track: MIDITrack, at timestamp: Timestamp) {
        var cpy = self
        MusicTrackNewMIDINoteEvent(track.ref, timestamp.beats, &cpy)
    }
    
    public static func ==(lhs: MIDINoteMessage, rhs: MIDINoteMessage) -> Bool {
        return (lhs.channel, lhs.note, lhs.velocity, lhs.releaseVelocity, lhs.duration) ==
            (rhs.channel, rhs.note, rhs.velocity, rhs.releaseVelocity, rhs.duration)
    }
    
    public static func <(lhs: MIDINoteMessage, rhs: MIDINoteMessage) -> Bool {
        return lhs.note < rhs.note
    }
    
    public var hashValue: Int {
        return note.hashValue
    }
}


