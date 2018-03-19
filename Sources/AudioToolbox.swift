//
//  AudioToolbox.swift
//  KoreMIDI
//
//  Created by Adam Nemecek on 4/5/17.
//  Copyright © 2017 Adam Nemecek. All rights reserved.
//

import AudioToolbox.MusicPlayer

@inline(__always) internal
func OSAssert(_ err: OSStatus, function: String = #function) {
    assert(err == noErr, "Error (osstatus: \(err)) in \(function)")
}

func with<T>(_ apply: (T) -> ()) {

}

//
// player
//

@inline(__always) internal
func MIDIPlayerCreate() -> MusicPlayer {
//    NewMusicPlayer
    fatalError()
}

///
/// Sequences
///

@inline(__always) internal
func MIDISequenceCreate() -> MusicSequence {
    var ref : MusicSequence? = nil
    OSAssert(NewMusicSequence(&ref))
    return ref!
}

@inline(__always) internal
func MIDISequenceImport(_ url: URL) -> MusicSequence {
    let seq = MIDISequenceCreate()
    OSAssert(MusicSequenceFileLoad(seq, url as CFURL, .midiType, .smf_ChannelsToTracks))
    return seq
}

@inline(__always) internal
func MIDISequenceImport(_ data: Data) -> MusicSequence {
    let seq = MIDISequenceCreate()
    OSAssert(MusicSequenceFileLoadData(seq, data as CFData,
                                       .midiType, .smf_ChannelsToTracks))
    return seq
}

@inline(__always) internal
func MIDISequenceExport(ref: MusicSequence,
                        resolution : Int16 = 960) -> Data {
    var data : Unmanaged<CFData>? = nil
    OSAssert(MusicSequenceFileCreateData(ref, .midiType, .eraseFile, resolution, &data))
    return data!.takeUnretainedValue() as Data
}

@inline(__always) internal
func MIDISequenceSave(ref: MusicSequence,
                      to url: URL,
                      resolution: Int16 = 960) {

    OSAssert(MusicSequenceFileCreate(ref, url as CFURL,
                                     .midiType,
                                     .eraseFile,
                                     resolution))
}

@inline(__always) internal
func MusicSequenceGetTrackCount(ref: MusicSequence) -> Int {
    var c: UInt32 = 0
    OSAssert(MusicSequenceGetTrackCount(ref, &c))
    return Int(c)
}

@inline(__always) internal
func MusicSequenceGetTrack(ref: MusicSequence, at index: Int) -> MusicTrack {
    var r : MusicTrack? = nil
    OSAssert(MusicSequenceGetIndTrack(ref, UInt32(index), &r))
    return r!
}
//
//@inline(__always) internal
//func MusicSequenceInsert(ref: MusicSequence, event: MIDIEvent) {
//    switch event {
//    case .extendedNote(let ts, var e): OSAssert(MusicTrackNewExtendedNoteEvent(ref, ts.beats, &e))
//    case .extendedTempo(let ts, let e): OSAssert(MusicTrackNewExtendedTempoEvent(ref, ts.beats, e.bpm))
//    case .user(let ts, var e): OSAssert(MusicTrackNewUserEvent(ref, ts.beats, &e))
//    case .meta(let ts, var e): OSAssert(MusicTrackNewMetaEvent(ref, ts.beats, &e))
//    case .note(let ts, var e): OSAssert(MusicTrackNewMIDINoteEvent(ref, ts.beats, &e))
//    case .channel(let ts, var e): OSAssert(MusicTrackNewMIDIChannelEvent(ref, ts.beats, &e))
//    case .rawData(let ts, var e): OSAssert(MusicTrackNewMIDIRawDataEvent(ref, ts.beats, &e))
//    case .parameter(let ts, var e): OSAssert(MusicTrackNewParameterEvent(ref, ts.beats, &e))
//    case .auPreset(let ts, var e): OSAssert(MusicTrackNewAUPresetEvent(ref, ts.beats, &e))
//    }
//}

@inline(__always) internal
func MusicSequenceBeatsToBarBeatTime(ref: MusicSequence, beats: MIDITimestamp, subdivisor: UInt32) -> CABarBeatTime {
    var t = CABarBeatTime()
    OSAssert(MusicSequenceBeatsToBarBeatTime(ref, beats.beats, subdivisor, &t))
    return t
}

//@inline(__always) internal
//func MusicSequenceBeatsToSeconds(ref: MusicSequence, beats: MusicTimeStamp) -> Float64 {
//    var out: Float64 = 0
//    OSAssert(MusicSequenceGetSecondsForBeats(ref, beats, &out))
//    return out
//}

//@inline(__always) internal
//func MusicSequenceSecondsToBeats(ref: MusicSequence, seconds: MusicTimeStamp) -> Float64 {
//    var out: MusicTimeStamp = 0
//    OSAssert(MusicSequenceGetBeatsForSeconds(ref, seconds, &out))
//    return out
//}

@inline(__always) internal
func MusicSequenceGetSequenceType(ref: MusicSequence) -> MusicSequenceType {
    var out: MusicSequenceType = .beats
    OSAssert(MusicSequenceGetSequenceType(ref, &out))
    return out
}

//@inline(__always) internal
//func MusicTrackGetSequence(_ track: MusicTrack) -> MusicSequence {
//    var out: MusicSequence? = nil
//    OSAssert(MusicTrackGetSequence(track, &out))
//    return out!
//}

///
/// Iterators
///

@inline(__always) internal
func MIDIIteratorCreate(ref: MusicTrack) -> MusicEventIterator {
    var r: MusicEventIterator? = nil
    OSAssert(NewMusicEventIterator(ref, &r))
    return r!
}

//extension Double : TimestampType {
//    public var beats : MusicTimeStamp {
//        return MusicTimeStamp(self)
//    }
//}

@inline(__always) internal
func MIDIIteratorHasCurrent(ref: MusicEventIterator) -> Bool {
    var bool : DarwinBoolean = false
    OSAssert(MusicEventIteratorHasCurrentEvent(ref, &bool))
    return Bool(bool)
}

extension UnsafeRawBufferPointer : Equatable {
    public static func ==(lhs: UnsafeRawBufferPointer, rhs: UnsafeRawBufferPointer) -> Bool {
        return lhs.count == rhs.count && lhs.elementsEqual(rhs)
    }
}

internal struct MIDIRawEvent : EventType, CustomStringConvertible {
    let timestamp: MIDITimestamp
    let type: MIDIEventType
    let data: UnsafeRawBufferPointer

    @inline(__always)
    init?(ref: MusicEventIterator) {
        guard MIDIIteratorHasCurrent(ref: ref) else { return nil }

        var timestamp: Float64 = 0
        var type: MusicEventType = 0
        var data: UnsafeRawPointer? = nil
        var size: UInt32 = 0

        OSAssert(MusicEventIteratorGetEventInfo(ref, &timestamp, &type, &data, &size))

        self.timestamp = MIDITimestamp(beats: timestamp)
        self.type = MIDIEventType(rawValue: type)
        self.data = UnsafeRawBufferPointer(start: data!, count: Int(size))
    }

    var description: String {
        return "\(timestamp)\(type)"
    }

    init(timestamp: MIDITimestamp, type: MIDIEventType, data: inout String) {
        self.timestamp = timestamp
        self.type = type

        self.data = withUnsafeBytes(of: &data) { $0 }
    }

    static func ==(lhs: MIDIRawEvent, rhs: MIDIRawEvent) -> Bool {
        return lhs.timestamp == rhs.timestamp &&
            lhs.type == rhs.type &&
            lhs.data == rhs.data
    }
}

//internal struct MIDIRawEvent2<T> : Equatable {
//    let timestamp: MIDITimestamp
//    let type: MIDIEventType
//    let pointer: UnsafeRawBufferPointer
//
//    init?(ref: MusicEventIterator) {
//        guard MIDIIteratorHasCurrent(ref: ref) else { return nil }
//
//        var timestamp: Float64 = 0
//        var type: MusicEventType = 0
//        var data : UnsafeRawPointer? = nil
//        var size : UInt32 = 0
//
//        OSAssert(MusicEventIteratorGetEventInfo(ref, &timestamp, &type, &data, &size))
//
//        self.timestamp = MIDITimestamp(beats: timestamp)
//        self.type = MIDIEventType(rawValue: type)
//        self.pointer = UnsafeRawBufferPointer(start: data!, count: Int(size))
//    }
//
//    static func ==(lhs: MIDIRawEvent2, rhs: MIDIRawEvent2) -> Bool {
//        return lhs.timestamp == rhs.timestamp &&
//            lhs.type == rhs.type &&
//            lhs.pointer == rhs.pointer
//    }
//
//    static func <(lhs: MIDIRawEvent2, rhs: MIDIRawEvent2) -> Bool {
//        return lhs.timestamp < rhs.timestamp
//    }
//}

struct EventPointer<Event> {

    private let pointer: UnsafeRawPointer

    init() {
        fatalError()
    }
}

@inline(__always) internal
func MIDIIteratorGetCurrent(ref: MusicEventIterator) -> MIDIEvent? {

    guard MIDIIteratorHasCurrent(ref: ref) else { return nil }

    var timestamp: Float64 = 0
    var type: MusicEventType = 0
    var data : UnsafeRawPointer? = nil
    var size : UInt32 = 0



    OSAssert(MusicEventIteratorGetEventInfo(ref, &timestamp, &type, &data, &size))
    let d = Data(bytes: data!, count: Int(size))


    return MIDIEvent(timestamp: MIDITimestamp(beats: timestamp),
                     type: MIDIEventType(rawValue: type),
                     data: d)
}

///
/// Tracks
///

@inline(__always) internal
func MIDITrackCreate(ref: MusicSequence) -> MusicTrack {
    var out : MusicTrack? = nil
    OSAssert(MusicSequenceNewTrack(ref, &out))
    return out!
}

@inline(__always) internal
func MIDITrackGetProperty<T>(ref: MusicTrack, prop: MIDITrackProp) -> T {
    var d = Data(capacity: MemoryLayout<T>.size)
    var size: UInt32 = 0
    d.withUnsafeMutableBytes {
        OSAssert(MusicTrackGetProperty(ref, prop.rawValue, $0, &size))
    }

    return d.decode()
}


@inline(__always) internal
func MIDITrackGetProperty(ref: MusicTrack, prop: UInt32) -> Bool {
    var out : DarwinBoolean = false
    var size: UInt32 = 0
    OSAssert(MusicTrackGetProperty(ref, prop, &out, &size))
    return out.boolValue
}

@inline(__always) internal
func MIDITrackSetProperty<T>(ref: MusicTrack, prop: MIDITrackProp, to value: T) {
    var cpy = value
    OSAssert(MusicTrackSetProperty(ref, prop.rawValue, &cpy, UInt32(MemoryLayout<T>.size)))
}

@inline(__always) internal
func MusicSequenceGetTempoTrack(ref: MusicSequence) -> MusicTrack {
    var out : MusicTrack? = nil
    OSAssert(MusicSequenceGetTempoTrack(ref, &out))
    return out!
}

