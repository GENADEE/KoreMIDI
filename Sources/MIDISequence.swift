//
//  MIDISequenceImpl.swift
//  KoreMIDI
//
//  Created by Adam Nemecek on 4/7/17.
//
//
import Foundation
import AVFoundation

extension Array where Element == MIDITrack {
    fileprivate init(parent: MIDISequence) {
        let count = MusicSequenceGetTrackCount(ref: parent.ref)
        self = (0..<count).map {
            MIDITrack(sequence: parent, no: $0)
        }
    }
}

///
/// MIDISequence
///

public final class MIDISequence : RandomAccessCollection, Hashable, Comparable {

    public typealias Index = Int
    public typealias IndexDistance = Index
    public typealias Element = MIDITrack
    public typealias Timestamp = MIDITimestamp

    private var content: [MIDITrack] = []

//    internal private(set) var _tempo: MIDITempoTrack! = nil
    internal private(set) lazy var tempo = MIDITempoTrack(sequence: self)
//        return
//    }


    internal let ref: MusicSequence

    public init() {
        self.ref = MIDISequenceCreate()
        self.content = Array(parent: self)
//        _tempo = MIDITempoTrack(sequence: self)
    }

    public init(import url: URL) {
        self.ref = MIDISequenceImport(url)
        self.content = Array(parent: self)
    }

    public init(import data: Data) {
        self.ref = MIDISequenceImport(data)
        self.content = Array(parent: self)
    }

    public func copy() -> MIDISequence {
        return .init(import: export())
    }

    deinit {
        content = []
        DisposeMusicSequence(ref)
    }

    private static var callback: MusicSequenceUserCallback {
        get {
            fatalError()
        }
        set {

        }
    }
    public static func ==(lhs: MIDISequence, rhs: MIDISequence) -> Bool {
        return lhs === rhs || lhs.elementsEqual(rhs)
    }

    public static func ===(lhs: MIDISequence, rhs: MIDISequence) -> Bool {
        return lhs.ref == rhs.ref
    }

    public static func <(lhs: MIDISequence, rhs: MIDISequence) -> Bool {
        return lhs.hashValue < rhs.hashValue
    }

    public var hashValue: Int {
        return ref.hashValue
    }

    public func export() -> Data {
        return MIDISequenceExport(ref: ref)
    }

    public func save(to url: URL) {
        MIDISequenceSave(ref: ref, to: url)
    }

    //        func _validate() {
    //            guard _type != .beats else { return }
    //            _type = .beats
    //        }
    //
    //        private var _type : MusicSequenceType {
    //            get {
    //                return MusicSequenceGetSequenceType(ref: ref)
    //            }
    //            set {
    //                assert(newValue == .beats)
    //                guard _type != newValue else { return }
    //                MusicSequenceSetSequenceType(ref, newValue)
    //            }
    //        }

    //    func remove

    public var count: IndexDistance {
        return content.count
    }

    public var startTime : Timestamp {
        return lazy.map { $0.startTime }.reduce(0, Swift.min)
    }

    public var endTime : Timestamp {
        return lazy.map { $0.endTime }.reduce(0, Swift.max)
    }

    public var startIndex: Index {
        return 0
    }

    public var endIndex : Index {
        return count
    }

    public func index(after i: Index) -> Index {
        return i + 1
    }

    public func index(before i: Index) -> Index {
        return i - 1
    }

    public subscript(index: Index) -> Element {
        return content[index]
    }
}





