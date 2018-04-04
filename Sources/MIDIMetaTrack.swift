//
//  MIDIMetaTrack.swift
//  KoreMIDI
//
//  Created by Adam Nemecek on 1/30/18.
//

import AVFoundation

//enum MetaEvent {
//
//}


//public enum MIDIMetaEvent {
//    func insert(to track: MIDIMetaTrack) {
//
//    }
//}

//public class TextTrack<Element: MIDITextEventType & MIDIMetaEventType> : Sequence {
//    private let sequence: MIDISequence
//
//    internal init(sequence: MIDISequence) {
//        fatalError()
//    }
//
//    public func makeIterator() -> AnyIterator<Element> {
////        Element
////        var i = track.makeIterator()
////        Element.byte
//        return AnyIterator {
//            nil
//        }
//
//    }
//}

func yield<I: IteratorProtocol>(i: I) -> I {
//    return I
    fatalError()
}

public final class MIDIMetaTrack<Element : MIDIMetaEventType>: Sequence, Equatable, Hashable {
    private let sequence: MIDISequence

    internal init(sequence: MIDISequence) {
        self.sequence = sequence
    }

    public func makeIterator() -> AnyIterator<Element> {
        var i = sequence.makeIterator()
        return AnyIterator {

/*
            while let n = i.next() {
             if Element.byte ==  {

            }
 */
            fatalError()
        }
    }

    public static func ==(lhs: MIDIMetaTrack, rhs: MIDIMetaTrack) -> Bool {
        return lhs.elementsEqual(rhs)
    }

    public var hashValue: Int {
        fatalError()
    }
}


