//
//  AudioToolbox.swift
//  KoreMIDI
//
//  Created by Adam Nemecek on 4/5/17.
//  Copyright © 2017 Adam Nemecek. All rights reserved.
//

import AudioToolbox.MusicPlayer

func OSAssert(_ stat: OSStatus) {
    assert(stat == noErr)
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
    OSAssert(MusicSequenceFileLoadData(seq, data as CFData, .midiType, .smf_ChannelsToTracks))
    return seq
}

@inline(__always) internal
func MIDISequenceExport(ref: MusicSequence) -> Data {
//    MusicSequenceFileCreateData(ref, .midiType, 0, )
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
    OSAssert(MusicSequenceGetTrackCount(ref, &c))
    return Int(c)
}

@inline(__always) internal
func MusicSequenceGetIndTrack(ref: MusicSequence, no: Int) -> MusicTrack {
    var r : MusicTrack? = nil
   OSAssert(MusicSequenceGetIndTrack(ref, UInt32(no), &r))
    return r!
}

@inline(__always) internal
func MusicSequenceBeatsToSeconds(ref: MusicSequence, beats: MusicTimeStamp) -> Float64 {
    var out: Float64 = 0
    OSAssert(MusicSequenceGetSecondsForBeats(ref, beats, &out))
    return out
}

@inline(__always) internal
func MusicSequenceSecondsToBeats(ref: MusicSequence, seconds: MusicTimeStamp) -> Float64 {
    var out: MusicTimeStamp = 0
    OSAssert(MusicSequenceGetBeatsForSeconds(ref, seconds, &out))
    return out
}

@inline(__always) internal
func MusicSequenceGetSequenceType(ref: MusicSequence) -> MusicSequenceType {
    var out: MusicSequenceType = .beats
    OSAssert(MusicSequenceGetSequenceType(ref, &out))
    return out
}

@inline(__always) internal
func MusicTrackGetSequence(_ track: MusicTrack) -> MusicSequence {
    var out: MusicSequence? = nil
    OSAssert(MusicTrackGetSequence(track, &out))
    return out!
}

//@inline(__always) internal
//func MusicSequenceSetSequenceType(ref: MusicSequence, type: MIDIS)  {
//    var out: MusicSequenceType = .beats
//    MusicSequenceGetSequenceType(ref, &out)
//    return out
//}


///
/// Iterators
///

//enum OSResult<T> {
//    case ok(T), err(OSStatus)
//    
//    public init(fun: @autoclosure () -> OSStatus, ok: @autoclosure () -> T) {
//        let e = fun()
//        if e == noErr {
//            self = .ok(ok())
//        }
//        else {
//            self = .err(e)
//        }
//    }
//}

@inline(__always) internal
func MIDIIteratorCreate(ref: MusicTrack) -> MusicEventIterator {
//    var r: MusicEventIterator? = nil
//    return OSResult(fun:
//        NewMusicEventIterator(ref, &r)
//    }) {
//        r!
//    }
    var r: MusicEventIterator? = nil
    OSAssert(NewMusicEventIterator(ref, &r))
    return r!
}

extension Double : TimestampType {
    public var beats : MusicTimeStamp {
        return MusicTimeStamp(self)
    }
}

@inline(__always) internal
func MIDIIteratorGetCurrent(ref: MusicEventIterator) -> MIDIEvent<MusicTimeStamp>? {
    func MIDIIteratorHasCurrent(ref: MusicEventIterator) -> Bool {
        var bool : DarwinBoolean = false
        OSAssert(MusicEventIteratorHasCurrentEvent(ref, &bool))
        return Bool(bool)
    }

    guard MIDIIteratorHasCurrent(ref: ref) else { return nil }

    var timestamp: Double = 0
    var type: MusicEventType = 0
    var data : UnsafeRawPointer? = nil
    var size : UInt32 = 0
    
    OSAssert(MusicEventIteratorGetEventInfo(ref, &timestamp, &type, &data, &size))
    let d = Data(bytes: data!, count: Int(size))
    return MIDIEvent(timestamp: timestamp,
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
    var ptr = UnsafeMutablePointer<T>.allocate(capacity: 1)
    var size: UInt32 = 0
    OSAssert(MusicTrackGetProperty(ref, prop.rawValue, ptr, &size))
//    fatalError("ownership")
    defer {
        ptr.deinitialize()
        ptr.deallocate(capacity: 1)
    }
      return ptr.pointee
}

@inline(__always) internal
func MIDITrackSetProperty<T>(ref: MusicTrack, prop: MIDITrackProp, to value: T) {
    var cpy = value
    OSAssert(MusicTrackSetProperty(ref, prop.rawValue, &cpy, UInt32(MemoryLayout<T>.size)))
}


@inline(__always) internal
func MusicSequenceBeatsToBarBeatTime(ref: MusicSequence, beats: MusicTimeStamp, subdivisor: UInt32) -> CABarBeatTime {
    var t = CABarBeatTime()
    OSAssert(MusicSequenceBeatsToBarBeatTime(ref, beats, subdivisor, &t))
    return t
}

@inline(__always) internal
func MusicSequenceGetTempoTrack(ref: MusicSequence) -> MusicTrack {
    var out : MusicTrack? = nil
    OSAssert(MusicSequenceGetTempoTrack(ref, &out))
    return out!
}


