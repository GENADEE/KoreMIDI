//
//  AudioToolbox.swift
//  KoreMIDI
//
//  Created by Adam Nemecek on 4/5/17.
//  Copyright © 2017 Adam Nemecek. All rights reserved.
//

import AudioToolbox.MusicPlayer

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
func MIDISequenceImport(url: URL) -> MusicSequence {
    let seq = MIDISequenceCreate()
    MusicSequenceFileLoad(seq, url as CFURL, .midiType, .smf_ChannelsToTracks)
    return seq
}

@inline(__always) internal
func MIDISequenceImport(import data: Data) -> MusicSequence {
//    let seq = MIDISequenceCreate()
//    let url = URL(fileURLWithPath: path) as CFURL
//    MusicSequenceFileLoad(seq, url, .midiType, .smf_ChannelsToTracks)
//    return seq
    fatalError()
}

@inline(__always) internal
func MIDISequenceExport(ref: MusicSequence) -> Data {
    fatalError()
//    MusicSequenceFileCreateData(ref, .midiType, .eraseFile)
//    let seq = MIDISequenceCreate()
//    let url = URL(fileURLWithPath: path) as CFURL
//    MusicSequenceFileLoad(seq, url, .midiType, .smf_ChannelsToTracks)
//    return seq
}

//public func MusicSequenceFileCreateData(_ inSequence: MusicSequence, _ inFileType: MusicSequenceFileTypeID, _ inFlags: MusicSequenceFileFlags, _ inResolution: Int16, _ outData: UnsafeMutablePointer<Unmanaged<CFData>?>) -> OSStatus

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
func MusicTrackGetSequence(_ track: MusicTrack) -> MusicSequence {
    var out: MusicSequence? = nil
    MusicTrackGetSequence(track, &out)
    return out!
}

//@inline(__always) internal
//func MusicSequenceSetSequenceType(ref: MusicSequence, type: MIDIS)  {
//    var out: MusicSequenceType = .beats
//    MusicSequenceGetSequenceType(ref, &out)
//    return out
//}

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
func MusicSequenceBeatsToBarBeatTime(ref: MusicSequence, beats: MusicTimeStamp, subdivisor: UInt32) -> CABarBeatTime {
    var t = CABarBeatTime()
    MusicSequenceBeatsToBarBeatTime(ref, beats, subdivisor, &t)
    return t
}

@inline(__always) internal
func MusicSequenceGetTempoTrack(ref: MusicSequence) -> MusicTrack {
    var out : MusicTrack? = nil
    MusicSequenceGetTempoTrack(ref, &out)
    return out!
}

protocol MIDIEvent {
    static var type : MIDIEventType { get }
    func insert(to: MIDITrackImpl, at timestamp: MIDITimestamp)
}

extension MIDINoteMessage : MIDIEvent, Hashable, Comparable, CustomStringConvertible {
    
    public static var type : MIDIEventType {
        return .note
    }
    
    public var description: String {
        return "MIDIMsg(\(note), duration: \(duration))"
    }
    
    internal func insert(to track: MIDITrackImpl, at timestamp: MIDITimestamp) {
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


