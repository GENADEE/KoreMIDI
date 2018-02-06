//
//  MIDIMetaTrack.swift
//  KoreMIDI
//
//  Created by Adam Nemecek on 1/30/18.
//

import AudioToolbox.MusicPlayer

//enum MetaEvent {
//
//}


//public enum MIDIMetaEvent {
//    func insert(to track: MIDIMetaTrack) {
//
//    }
//}



public class MIDIMetaTrack: Sequence, Equatable, Hashable {
    public typealias Element = MIDIMetaEvent

//    public enum Event {'
//
//    }
    public func makeIterator() -> AnyIterator<Element> {
        fatalError()
    }

    public static func ==(lhs: MIDIMetaTrack, rhs: MIDIMetaTrack) -> Bool {
        fatalError()
    }

    public var hashValue: Int {
        fatalError()
    }
}


