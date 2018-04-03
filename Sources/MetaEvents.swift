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

/// todo: make internal
public protocol MIDIMetaEventType : Equatable {
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
/*
public struct Copyright : StringProtocol {
    public typealias StringLiteralType = String.StringLiteralType
    public typealias UTF8View = String.UTF8View
    public typealias UTF16View = String.UTF16View
    public typealias UnicodeScalarView = String.UnicodeScalarView

    public var utf8: String.UTF8View {
        fatalError()
    }

    public var utf16: String.UTF16View {
        fatalError()
    }

    public var unicodeScalars: String.UnicodeScalarView {
        fatalError()
    }

    public func hasPrefix(_ prefix: String) -> Bool {
        fatalError()
    }

    public func hasSuffix(_ prefix: String) -> Bool {
        fatalError()
    }

    public func lowercased() -> String {
        fatalError()
    }

    public func uppercased() -> String {
        fatalError()
    }

    public init<C, Encoding>(decoding codeUnits: C, as sourceEncoding: Encoding.Type) where C : Collection, Encoding : _UnicodeEncoding, C.Element == Encoding.CodeUnit {
        fatalError()
    }

    public init(cString nullTerminatedUTF8: UnsafePointer<CChar>) {
        fatalError()
    }

    public init<Encoding>(decodingCString nullTerminatedCodeUnits: UnsafePointer<Encoding.CodeUnit>, as sourceEncoding: Encoding.Type) where Encoding : _UnicodeEncoding {
        fatalError()
    }

    public func withCString<Result>(_ body: (UnsafePointer<CChar>) throws -> Result) rethrows -> Result {
        fatalError()
    }

    public func withCString<Result, Encoding>(encodedAs targetEncoding: Encoding.Type, _ body: (UnsafePointer<Encoding.CodeUnit>) throws -> Result) rethrows -> Result where Encoding : _UnicodeEncoding {
        fatalError()
    }


    public init(stringLiteral description: String) {
        fatalError()
    }

    public init?(_ description: String) {
        fatalError()
    }

    public var description: String {
        fatalError()
    }

    public mutating func write(_ string: String) {
        fatalError()
    }

    public func write<Target>(to target: inout Target) where Target : TextOutputStream {
        fatalError()
    }
}*/

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


