//
//  MIDITrumTrack.swift
//  KoreMIDI
//
//  Created by Adam Nemecek on 4/3/18.
//

import Foundation


public struct MIDIDrumEvent {
    public typealias Timestamp = MIDITimestamp
    public let timestamp: Timestamp
}


class MIDIDrumTrack : Sequence {
    public typealias Element = MIDIDrumEvent
    public typealias Timestamp = Element.Timestamp


    internal init(timestamp: Timestamp, drum: Int8) {
        fatalError()
    }

    public func makeIterator() -> AnyIterator<Element> {
        fatalError()
    }


}
