//
//  MetaEvents.swift
//  KoreMIDI
//
//  Created by Adam Nemecek on 1/31/18.
//

import Foundation
import AVFoundation

//internal protocol MIDIMetaEventType {
//
//}

public protocol MIDITextEventType : EventType {
    var text: String { get }

}

/// make internal
public protocol MIDIMetaEventType {
    static var byte: MIDIMetaEvent.Subtype { get }
}

extension String {
    public init(_ buffer: UnsafeRawBufferPointer) {
        let bytes = [UInt8](buffer) + [0]
        self.init(cString: bytes)
    }

    internal init(event: MIDIRawEvent) {
        self.init(event.data)
    }
}

public class TextTrack<Element: MIDITextEventType & MIDIMetaEventType> : Sequence {
    private let sequence: MIDISequence

    internal init(sequence: MIDISequence) {
        fatalError()
    }

    public func makeIterator() -> AnyIterator<Element> {
//        Element
//        var i = track.makeIterator()
//        Element.byte
        return AnyIterator {
            nil
        }

    }
}

public struct MIDIMetaTextEvent : Equatable, Hashable, MIDITextEventType, MIDIMetaEventType {
    public static var byte: MIDIMetaEvent.Subtype {
        return .textEvent
    }

    public let timestamp: MIDITimestamp
    public let text: String

    internal init(event: MIDIRawEvent) {
        self.timestamp = event.timestamp
        self.text = String(event: event)
    }
}

internal struct MIDICopyrightEvent : Equatable, Hashable, MIDITextEventType, MIDIMetaEventType {
    static var byte: MIDIMetaEvent.Subtype {
        return .copyrightNotice
    }

    public let timestamp: MIDITimestamp
    public let text: String

    internal init(event: MIDIRawEvent) {
        self.timestamp = event.timestamp
        self.text = String(event: event)
    }
}

///
/// at the beginning of each track
///
internal struct MIDIInstrumentName : Equatable, Hashable, MIDITextEventType, MIDIMetaEventType {
    static var byte: MIDIMetaEvent.Subtype {
        return .instrumentName
    }

    public let timestamp: MIDITimestamp
    public let text: String

    internal init(event: MIDIRawEvent) {
        self.timestamp = event.timestamp
        self.text = String(event: event)
    }
}

public struct MIDILyricEvent : Equatable, Hashable, MIDITextEventType, MIDIMetaEventType {
    public static var byte: MIDIMetaEvent.Subtype {
        return .lyricText
    }

    public let timestamp: MIDITimestamp
    public let text: String

    internal init(event: MIDIRawEvent) {
        self.timestamp = event.timestamp
        self.text = String(event: event)
    }
}

public struct MIDIMarkerEvent : Equatable, Hashable, MIDITextEventType, MIDIMetaEventType {
    public static func ==(lhs: MIDIMarkerEvent, rhs: MIDIMarkerEvent) -> Bool {
        fatalError()
    }


    public static var byte: MIDIMetaEvent.Subtype {
        return .markerText
    }

    public let timestamp: MIDITimestamp
    public let text: String

    internal init(event: MIDIRawEvent) {
        self.timestamp = event.timestamp
        self.text = String(event: event)
    }
}

public struct MIDICueEvent : Equatable, Hashable, MIDITextEventType, MIDIMetaEventType {
    public static var byte: MIDIMetaEvent.Subtype {
        return .cuePoint
    }

    public let timestamp: MIDITimestamp
    public let text: String

    internal init(event: MIDIRawEvent) {
        self.timestamp = event.timestamp
        self.text = String(event: event)
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


