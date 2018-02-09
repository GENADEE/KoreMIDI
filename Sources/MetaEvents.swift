//
//  MetaEvents.swift
//  KoreMIDI
//
//  Created by Adam Nemecek on 1/31/18.
//

import Foundation

//internal protocol MIDIMetaEventType {
//
//}

public protocol MIDITextEventType : EventType {
    var text: String { get }
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

public class TextTrack<Element: MIDITextEventType> : Sequence {
    internal init(sequence: MIDISequence) {
        fatalError()
    }

    public func makeIterator() -> AnyIterator<Element> {
        fatalError()
    }
}

public struct MIDIMetaTextEvent : Equatable, Hashable, MIDITextEventType {
    public let timestamp: MIDITimestamp
    public let text: String

    internal init(event: MIDIRawEvent) {
        self.timestamp = event.timestamp
        self.text = String(event: event)
    }
}

internal struct MIDICopyrightEvent : Equatable, Hashable, MIDITextEventType {
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
internal struct MIDIInstrumentName : Equatable, Hashable, MIDITextEventType {
    public let timestamp: MIDITimestamp
    public let text: String

    internal init(event: MIDIRawEvent) {
        self.timestamp = event.timestamp
        self.text = String(event: event)
    }
}

public struct MIDILyricEvent : Equatable, Hashable, MIDITextEventType {
    public let timestamp: MIDITimestamp
    public let text: String

    internal init(event: MIDIRawEvent) {
        self.timestamp = event.timestamp
        self.text = String(event: event)
    }
}

public struct MIDIMarkerEvent : Equatable, Hashable, MIDITextEventType {
    public let timestamp: MIDITimestamp
    public let text: String

    internal init(event: MIDIRawEvent) {
        self.timestamp = event.timestamp
        self.text = String(event: event)
    }
}

public struct MIDICueEvent : Equatable, Hashable, MIDITextEventType {
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


