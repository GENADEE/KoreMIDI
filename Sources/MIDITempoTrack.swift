//
//  MIDITempoTrack.swift
//  KoreMIDI
//
//  Created by Adam Nemecek on 4/7/17.
//  Copyright © 2017 Adam Nemecek. All rights reserved.
//

import Foundation
import AudioToolbox.MusicPlayer


public protocol MIDITrackType : Sequence, Hashable {

}

public protocol MIDITrackEventType {
    associatedtype Track : MIDITrackType
    associatedtype Timestamp: Strideable

    var timestamp: Timestamp { get }
    func insert(to track: Track)
}

public struct TempoEvent: CustomStringConvertible, Equatable, Comparable, Hashable, MIDITrackEventType {
    public let timestamp: MIDITimestamp
    private let msg: ExtendedTempoEvent

    public var description: String {
        return "TempoEvent(bpm: \(msg.bpm)"
    }

    public var hashValue: Int {
        return msg.hashValue
    }

    public static func ==(lhs: TempoEvent, rhs: TempoEvent) -> Bool {
        return lhs.msg.bpm == rhs.msg.bpm
    }

    public static func <(lhs: TempoEvent, rhs: TempoEvent) -> Bool {
        return lhs.timestamp < rhs.timestamp
    }

    public func insert(to track: MIDITempoTrack2) {
        MusicTrackNewExtendedTempoEvent(track.ref, timestamp.beats, msg.bpm)
    }
}

public class MIDITempoTrack2 : Hashable, Sequence, MIDITrackType {

    public typealias Element = TempoEvent

    private final let sequence: MIDISequence
    internal final let ref : MusicTrack

    init(sequence: MIDISequence) {
        self.sequence = sequence
        ref = MusicSequenceGetTempoTrack(ref: sequence.ref)
    }

    public static func == (lhs: MIDITempoTrack2, rhs: MIDITempoTrack2) -> Bool {
        return lhs.elementsEqual(rhs)
    }

    public static func === (lhs: MIDITempoTrack2, rhs: MIDITempoTrack2) -> Bool {
        return lhs.ref == rhs.ref || lhs == rhs
    }

    public var hashValue: Int {
        fatalError()
    }

    public func makeIterator() -> AnyIterator<Element> {
        fatalError()
    }

}

