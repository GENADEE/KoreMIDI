//
//  MIDIEventConvertible.swift
//  KoreMIDI
//
//  Created by Adam Nemecek on 4/8/17.
//
//

import Foundation
import AudioToolbox.MusicPlayer



protocol MIDIEventConvertible {
//    static var type : MIDIEventType { get }
    init?(event: MIDIEvent)
    func insert(to: MIDITrackImpl, at timestamp: MIDITimestamp)
}


//extension ExtendedNoteOnEvent: MIDIEventConvertible {
//    init?(event: MIDIEvent) {
//        guard event.type == .extendedNote else { return nil }
//        self = event.data.decode()
//    }
//    
//    public var hashValue: Int {
//        return groupID.hashValue
//    }
//    
//    func insert(to: MIDITrackImpl, at timestamp: MIDITimestamp) {
//        var copy = self
//        MusicTrackNewExtendedNoteEvent(to.ref, timestamp.beats, &copy)
//    }
//    
//    public static func ==(lhs: ExtendedNoteOnEvent, rhs: ExtendedNoteOnEvent) -> Bool {
//        return lhs.instrumentID == rhs.instrumentID &&
//            lhs.groupID == rhs.groupID &&
//            lhs.duration == rhs.duration //&&
//        //         lhs.extendedParams == rhs.extendedParams
//    }
//    
//    public static func <(lhs: ExtendedNoteOnEvent, rhs: ExtendedNoteOnEvent) -> Bool {
//        return lhs.groupID < rhs.groupID && lhs.instrumentID < rhs.instrumentID
//    }
//
//}
//
//
//
//
////
//// MARK: ExtendedTempoEvent
////
//
//extension ExtendedTempoEvent: MIDIEventConvertible {
//    init?(event: MIDIEvent) {
//        guard event.type == .extendedTempo else { return nil }
//        self = event.decode()
//    }
//    public var hashValue: Int {
//        return bpm.hashValue
//    }
//    
//    func add(to track: MusicTrack, at: MusicTimeStamp) {
//        MusicTrackNewExtendedTempoEvent(track, at, bpm)
//    }
//    
//    public static func ==(lhs: ExtendedTempoEvent, rhs: ExtendedTempoEvent) -> Bool {
//        return lhs.bpm == rhs.bpm
//    }
//    
//    public static func <(lhs: ExtendedTempoEvent, rhs: ExtendedTempoEvent) -> Bool {
//        return lhs.bpm < rhs.bpm
//    }
//
//}
//
//
////
//// MARK: MusicEventUserData
////
//
//extension MusicEventUserData: MIDIEventConvertible {
//    init?(event: MIDIEvent) {
//        guard event.type == .user else { return nil }
//        self = event.decode()
//    }
//    
//    public var hashValue: Int {
//        return length.hashValue
//    }
//    
//    func add(to track: MusicTrack, at: MusicTimeStamp) {
//        var copy = self
//        MusicTrackNewUserEvent(track, at, &copy)
//    }
//    
//    public func ==(lhs: MusicEventUserData, rhs: MusicEventUserData) -> Bool {
//        return lhs.length == rhs.length && lhs.data == rhs.data
//    }
//    
//    public func <(lhs: MusicEventUserData, rhs: MusicEventUserData) -> Bool {
//        return lhs.length < rhs.length
//    }
//}
//
//
//
////
//// MARK: MIDIMetaEvent
////
//
//extension MIDIMetaEvent: MIDIEventConvertible {
//    init?(event: MIDIEvent) {
//        guard event.type == .meta else { return nil }
//        self = event.decode()
//    }
//    public var hashValue: Int {
//        return metaEventType.hashValue
//    }
//    
//    func add(to track: MusicTrack, at: MusicTimeStamp) {
//        var copy = self
//        MusicTrackNewMetaEvent(track, at, &copy)
//    }
//}
//
//public func ==(lhs: MIDIMetaEvent, rhs: MIDIMetaEvent) -> Bool {
//    return lhs.metaEventType == rhs.metaEventType &&
//        lhs.dataLength == rhs.dataLength &&
//        lhs.data == rhs.data
//}
//
//public func <(lhs: MIDIMetaEvent, rhs: MIDIMetaEvent) -> Bool {
//    return lhs.metaEventType < rhs.metaEventType
//}

//
// MARK: MIDINoteMessage
//

extension MIDINoteMessage : MIDIEventConvertible {
    init?(event: MIDIEvent) {
        guard event.type == .note else { return nil }
        self = event.data.decode()
    }
    
    public var hashValue: Int {
        return channel.hashValue ^ note.hashValue
    }
    
    func insert(to track: MIDITrackImpl, at: MIDITimestamp) {
        var copy = self
        MusicTrackNewMIDINoteEvent(track.ref, at.beats, &copy)
    }
    
    public static func ==(lhs: MIDINoteMessage, rhs: MIDINoteMessage) -> Bool {
        return lhs.duration == rhs.duration &&
                lhs.note == rhs.note &&
                lhs.channel == rhs.channel &&
                lhs.velocity == rhs.velocity &&
                lhs.releaseVelocity == rhs.releaseVelocity
    }
    
    public static func <(lhs: MIDINoteMessage, rhs: MIDINoteMessage) -> Bool {
        return lhs.note < rhs.note
    }
}



////
//// MARK: MIDIChannelMessage
////
//
//extension MIDIChannelMessage: MIDIEventConvertible {
//    init?(event: MIDIEvent) {
//        guard event.type == .channelMessage else { return nil }
//        self = event.decode()
//    }
//    
//    public var hashValue: Int {
//        return status.hashValue
//    }
//    
//    func add(to track: MusicTrack, at: MusicTimeStamp) {
//        var copy = self
//        MusicTrackNewMIDIChannelEvent(track, at, &copy)
//    }
//}
//
//public func ==(lhs: MIDIChannelMessage, rhs: MIDIChannelMessage) -> Bool {
//    return lhs.status == rhs.status &&
//        lhs.data1 == rhs.data1 &&
//        lhs.data2 == rhs.data2
//}
//
//public func <(lhs: MIDIChannelMessage, rhs: MIDIChannelMessage) -> Bool {
//    return lhs.status < rhs.status
//}
//
////
//// MARK: MIDIRawData
////
//
//extension MIDIRawData: MIDIEventConvertible {
//    init?(event: MIDIEvent) {
//        guard event.type == .rawData else { return nil }
//        self = event.decode()
//    }
//    public var hashValue: Int {
//        return length.hashValue
//    }
//    
//    func add(to track: MusicTrack, at: MusicTimeStamp) {
//        var copy = self
//        MusicTrackNewMIDIRawDataEvent(track, at, &copy)
//    }
//}
//
//public func ==(lhs: MIDIRawData, rhs: MIDIRawData) -> Bool {
//    return lhs.length == rhs.length && lhs.data == rhs.data
//}
//
//public func <(lhs: MIDIRawData, rhs: MIDIRawData) -> Bool {
//    return lhs.length < rhs.length
//}
//
////
//// MARK: ParameterEvent
////
//
//extension ParameterEvent: MIDIEventConvertible {
//    init?(event: MIDIEvent) {
//        guard event.type == .parameter else { return nil }
//        self = event.decode()
//    }
//    
//    public var hashValue: Int {
//        return scope.hashValue
//    }
//    
//    func add(to track: MusicTrack, at: MusicTimeStamp) {
//        var copy = self
//        MusicTrackNewParameterEvent(track, at, &copy)
//    }
//}
//
//public func ==(lhs: ParameterEvent, rhs: ParameterEvent) -> Bool {
//    return lhs.parameterID == rhs.parameterID &&
//        lhs.scope == rhs.scope &&
//        lhs.element == rhs.element &&
//        lhs.value == rhs.value
//}
//
//public func <(lhs: ParameterEvent, rhs: ParameterEvent) -> Bool {
//    return lhs.scope < rhs.scope && lhs.parameterID < rhs.parameterID
//}
//
////
//// MARK: AUPresetEvent
////
//
//extension AUPresetEvent: MIDIEventConvertible {
//    init?(event: MIDIEvent) {
//        guard event.type == .auPreset else { return nil }
//        self = event.decode()
//    }
//    
//    public var hashValue: Int {
//        return scope.hashValue
//    }
//    
//    func add(to track: MusicTrack, at timestamp: MusicTimeStamp) {
//        var copy = self
//        MusicTrackNewAUPresetEvent(track, timestamp, &copy)
//    }
//}
//
//public func ==(lhs: AUPresetEvent, rhs: AUPresetEvent) -> Bool {
//    return lhs.scope == rhs.scope &&
//        lhs.element == rhs.element &&
//        lhs.preset.toOpaque() == rhs.preset.toOpaque()
//}
//
//public func <(lhs: AUPresetEvent, rhs: AUPresetEvent) -> Bool {
//    return lhs.scope < rhs.scope
//}

