//
//  MetaEvents.swift
//  KoreMIDI
//
//  Created by Adam Nemecek on 1/31/18.
//

import Foundation



public protocol MIDITextEventType : EventType {
    var text: String { get }
}

extension String {
    public init(_ buffer: UnsafeRawBufferPointer) {
        let bytes = [UInt8](buffer) + [0]
        self.init(cString: bytes)
    }

    internal init(event: MIDIEventPointer) {
        self.init(event.data)
    }
}

public struct MIDIMetaTextEvent : Equatable, Hashable, MIDITextEventType {
    public let timestamp: MIDITimestamp
    public let text: String

    internal init(event: MIDIEventPointer) {
        self.timestamp = event.timestamp
        self.text = String(event: event)
    }
}

public struct MIDICopyrightEvent : Equatable, Hashable, MIDITextEventType {
    public let timestamp: MIDITimestamp
    public let text: String

    internal init(event: MIDIEventPointer) {
        self.timestamp = event.timestamp
        self.text = String(event: event)
    }
}

public struct MIDIInstrumentName : Equatable, Hashable, MIDITextEventType {
    public let timestamp: MIDITimestamp
    public let text: String

    internal init(event: MIDIEventPointer) {
        self.timestamp = event.timestamp
        self.text = String(event: event)
    }
}

public struct MIDILyricEvent : Equatable, Hashable, MIDITextEventType {
    public let timestamp: MIDITimestamp
    public let text: String

    internal init(event: MIDIEventPointer) {
        self.timestamp = event.timestamp
        self.text = String(event: event)
    }
}

public struct MIDIMarkerEvent : Equatable, Hashable, MIDITextEventType {
    public let timestamp: MIDITimestamp
    public let text: String

    internal init(event: MIDIEventPointer) {
        self.timestamp = event.timestamp
        self.text = String(event: event)
    }
}

public struct MIDICueEvent : Equatable, Hashable, MIDITextEventType {
    public let timestamp: MIDITimestamp
    public let text: String

    internal init(event: MIDIEventPointer) {
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


