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

extension Sequence {
    public func min<T: Comparable>(by: (Iterator.Element) -> T) -> Iterator.Element? {
        return self.min { by($0) < by($1) }
    }

    public func max<T: Comparable>(by: (Iterator.Element) -> T) -> Iterator.Element? {
        return self.max { by($0) < by($1) }
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

    internal private(set) lazy var tempo = MIDITempoTrack(sequence: self)

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

    public var lyrics: TextTrack<MIDILyricEvent> {
        fatalError()
    }

    public var markers: TextTrack<MIDIMarkerEvent> {
        fatalError()
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
        return self.min { $0.startTime }?.startTime ?? 0
    }

    public var endTime : Timestamp {
        return self.max { $0.endTime }?.endTime ?? 0
    }

    public var startIndex: Index {
        return 0
    }

    public var endIndex: Index {
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

extension MIDISequence : Codable {
    private enum CodingKeys : String, CodingKey {
        case content = "content"
    }

    public convenience init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let data = try container.decode(Data.self, forKey: .content)
        self.init(import: data)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(export(), forKey: .content)
    }
}


