//
//  MIDIEventType
//  KoreMIDI
//
//  Created by Adam Nemecek on 4/8/17.
//
//

import AudioToolbox.MusicPlayer

public protocol MIDIEventConvertible {

}

/*
If this flag is set the resultant Sequence will contain a tempo track, 1 track for each MIDI Channel that is found in the SMF, 1 track for SysEx or MetaEvents -
 */

internal protocol MIDITrackEvent : MIDIEventConvertible {
    associatedtype Timestamp = Double
    func insert(to ref: MIDITrack, at timestamp: Timestamp)

    var type: MIDIEventType { get }
}

extension ExtendedNoteOnEvent : Hashable, CustomStringConvertible, MIDIEventConvertible, MIDITrackEvent {
    public static func ==(lhs: ExtendedNoteOnEvent, rhs: ExtendedNoteOnEvent) -> Bool {
        return lhs.instrumentID == rhs.instrumentID &&
            lhs.groupID == rhs.groupID &&
            lhs.duration == rhs.duration
    }

    internal func insert(to ref: MIDITrack, at timestamp: Double) {
        withCopy(of: self) {
            MusicTrackNewExtendedNoteEvent(ref.ref, timestamp, $0)
        }
    }

    public var description: String {
        return "instrumentID: \(instrumentID), groupID: \(groupID), duration: \(duration)"
    }

    public var hashValue: Int {
        return groupID.hashValue
    }

    public var type: MIDIEventType {
        return .extendedNote
    }
}

///
/// MARK: ExtendedTempoEvent
///

extension ExtendedTempoEvent : Hashable, CustomStringConvertible, MIDIEventConvertible, MIDITrackEvent {
    public var hashValue: Int {
        return bpm.hashValue
    }

    public static func ==(lhs: ExtendedTempoEvent, rhs: ExtendedTempoEvent) -> Bool {
        return lhs.bpm == rhs.bpm
    }

    public var description: String {
        return "bpm: \(bpm)"
    }

    public func insert(to ref: MIDITrack, at timestamp: Double) {
        MusicTrackNewExtendedTempoEvent(ref.ref, timestamp, bpm)
    }

    public var type: MIDIEventType {
        return .extendedTempo
    }
}

///
/// MARK: MusicEventUserData
///

extension MusicEventUserData : Hashable, CustomStringConvertible, MIDIEventConvertible, MIDITrackEvent {
    public var hashValue: Int {
        return length.hashValue
    }

    static public func ==(lhs: MusicEventUserData, rhs: MusicEventUserData) -> Bool {
        return lhs.length == rhs.length && lhs.data == rhs.data
    }

    public var description: String {
        return "data: \(data)"
    }

    internal func insert(to ref: MIDITrack, at timestamp: Double) {
        withCopy(of: self) {
            MusicTrackNewUserEvent(ref.ref, timestamp, $0)
        }
    }

    public var type: MIDIEventType {
        return .user
    }
}

///
/// MARK: MIDIMetaEvent
///

extension AudioToolbox.MIDIMetaEvent : Hashable, CustomStringConvertible, MIDIEventConvertible, MIDITrackEvent {

    enum Subtype: UInt8 {
        case sequenceNumber = 0x00,
        textEvent = 0x01,
        copyrightNotice = 0x02,
        trackSequenceName = 0x03,
        instrumentName  = 0x04,
        lyricText = 0x05,
        markerText              = 0x06,
        cuePoint                = 0x07,
        MIDIChannelPrefix       = 0x20,
        endOfTrack              = 0x2F,
        tempoSetting            = 0x51,
        SMPTEOffset             = 0x54,
        timeSignature           = 0x58,
        keySignature            = 0x59,
        sequencerSpecificEvent  = 0x7F,
        invalid                    = 0x66
    }

    public var hashValue: Int {
        return metaEventType.hashValue
    }

    public static func ==(lhs: AudioToolbox.MIDIMetaEvent, rhs: AudioToolbox.MIDIMetaEvent) -> Bool {
        return lhs.metaEventType == rhs.metaEventType &&
            lhs.dataLength == rhs.dataLength &&
            lhs.data == rhs.data
    }

    public var description: String {
        return "metaEventType: \(metaEventType)"
    }

    internal func insert(to ref: MIDITrack, at timestamp: Double) {
        withCopy(of: self) {
            MusicTrackNewMetaEvent(ref.ref, timestamp, $0)
        }
    }

    public var type: MIDIEventType {
        return .meta
    }
}

///
/// MARK: MIDINoteMessage
///
extension MIDINoteMessage : Hashable, CustomStringConvertible, MIDIEventConvertible, MIDITrackEvent {

    init(note: UInt8, duration: Float32, velocity: UInt8 = 100) {
        self.init(channel: 0,
                  note: note,
                  velocity: velocity,
                  releaseVelocity: 0,
                  duration: duration)
    }

    public var description : String {
        return "note: \(note), duration: \(duration)"
    }

    public static func ==(lhs: MIDINoteMessage, rhs: MIDINoteMessage) -> Bool {
        return lhs.duration == rhs.duration &&
            lhs.note == rhs.note &&
            lhs.channel == rhs.channel &&
            lhs.velocity == rhs.velocity &&
            lhs.releaseVelocity == rhs.releaseVelocity
    }

    public var hashValue: Int {
        return note.hashValue
    }

    internal func insert(to ref: MIDITrack, at timestamp: Double) {
        withCopy(of: self) {
            MusicTrackNewMIDINoteEvent(ref.ref, timestamp, $0)
        }
    }

    public var type: MIDIEventType {
        return .note
    }

}

///
/// MARK: MIDIChannelMessage
///

extension MIDIChannelMessage : Hashable, CustomStringConvertible, MIDIEventConvertible, MIDITrackEvent {

    enum Subtype : UInt {
        case polyphonicKeyPressure        = 0xA0,
        controlChange                = 0xB0,
        programChange                = 0xC0,
        channelPressure                = 0xD0,
        pitchBendChange                = 0xE0
    }

    public static func ==(lhs: MIDIChannelMessage, rhs: MIDIChannelMessage) -> Bool {
        return lhs.status == rhs.status && lhs.data1 == rhs.data1 && lhs.data2 == rhs.data2
    }

    public var hashValue: Int {
        return status.hashValue
    }

    public var description: String {
        return "cc: \(status): [\(data1), \(data2)]"
    }

    internal func insert(to ref: MIDITrack, at timestamp: Double) {
        withCopy(of: self) {
            MusicTrackNewMIDIChannelEvent(ref.ref, timestamp, $0)
        }
    }

    public var type: MIDIEventType {
        return .channel
    }

}

///
/// MARK: MIDIRawData
///

extension MIDIRawData : Hashable, CustomStringConvertible, MIDIEventConvertible, MIDITrackEvent {
    public static func ==(lhs: MIDIRawData, rhs: MIDIRawData) -> Bool {
        return lhs.length == rhs.length && lhs.data == rhs.data
    }

    public var hashValue: Int {
        return length.hashValue
    }

    public var description: String {
        return "\(length) \(data)"
    }

    internal func insert(to ref: MIDITrack, at timestamp: Double) {
        withCopy(of: self) {
            MusicTrackNewMIDIRawDataEvent(ref.ref, timestamp, $0)
        }
    }

    public var type: MIDIEventType {
        return .rawData
    }

}

///
/// MARK: ParameterEvent
///

extension ParameterEvent : Hashable, CustomStringConvertible, MIDIEventConvertible, MIDITrackEvent {
    public static func ==(lhs: ParameterEvent, rhs: ParameterEvent) -> Bool {
        return lhs.parameterID == rhs.parameterID &&
            lhs.scope == rhs.scope &&
            lhs.element == rhs.element &&
            lhs.value == rhs.value
    }

    public var hashValue: Int {
        return scope.hashValue
    }

    public var description: String {
        return ""
    }

    internal func insert(to ref: MIDITrack, at timestamp: Double) {
        withCopy(of: self) {
            MusicTrackNewParameterEvent(ref.ref, timestamp, $0)
        }
    }

    public var type: MIDIEventType {
        return .parameter
    }

}

///
/// MARK: AUPresetEvent
///

extension AUPresetEvent : Hashable, CustomStringConvertible, MIDIEventConvertible, MIDITrackEvent {
    static public func ==(lhs: AUPresetEvent, rhs: AUPresetEvent) -> Bool {
        return lhs.scope == rhs.scope &&
                lhs.element == rhs.element &&
                lhs.preset.toOpaque() == rhs.preset.toOpaque()
    }

    public var hashValue: Int {
        return scope.hashValue
    }

    public var description: String {
        return ""
    }

    internal func insert(to ref: MIDITrack, at timestamp: Double) {
        withCopy(of: self) {
            MusicTrackNewAUPresetEvent(ref.ref, timestamp, $0)
        }
    }

    public var type: MIDIEventType {
        return .auPreset
    }

}

extension ExtendedControlEvent : Hashable, CustomStringConvertible, MIDIEventConvertible, MIDITrackEvent {
    static public func ==(lhs: ExtendedControlEvent, rhs: ExtendedControlEvent) -> Bool {
//        return lhs.scope == rhs.scope && lhs.element == rhs.element
        //        return lhs.scope == rhs.scope &&
        //            lhs.element == rhs.element &&
        //            lhs.preset.toOpaque() == rhs.preset.toOpaque()
        fatalError()
    }

    public var hashValue: Int {
        //        return scope.hashValue
        fatalError()
    }

    public var description: String {
        return ""
    }

    internal func insert(to ref: MIDITrack, at timestamp: Double) {
        fatalError()
//        withCopy(of: self) {
//            MusicTrackNewExtendedNoteEvent(ref.ref, timestamp, $0)
//        }
    }

    public var type: MIDIEventType {
        fatalError()
    }

}

