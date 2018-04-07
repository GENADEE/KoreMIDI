//
//  MIDISequenceImpl.swift
//  KoreMIDI
//
//  Created by Adam Nemecek on 4/7/17.
//
//
import Foundation
import AVFoundation



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

public final class MIDISequence : RandomAccessCollection, Hashable, Comparable, Codable {

    public typealias Index = Int
    public typealias IndexDistance = Index
    public typealias Element = MIDITrack
    public typealias Timestamp = MIDITimestamp

    internal let ref: MusicSequence
    private var content: [MIDITrack] = []

    private var _tempo: MIDITempoTrack? = nil

    public var tempo: MIDITempoTrack {
        if let t = _tempo {
            return t
        }

        _tempo = MIDITempoTrack(sequence: self)
        return _tempo!
    }

    public init() {
        self.ref = MIDISequenceCreate()
        self.content = Array(parent: self)
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

    public var copyright: String? {
        get{
            fatalError()
        }
        set {
            fatalError()
        }
    }

    public var lyrics: MIDIMetaTrack<MIDILyricEvent> {
        fatalError()
    }

    public var markers: MIDIMetaTrack<MIDIMarkerEvent> {
        fatalError()
    }

    public var cues: MIDIMetaTrack<MIDICueEvent> {
        fatalError()
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

    public var start : Timestamp {
        return self.min { $0.start }?.start ?? 0
    }

    public var end : Timestamp {
        return self.max { $0.end }?.end ?? 0
    }

    public var startIndex: Index {
        return 0
    }

    public var endIndex: Index {
        return count
    }

    public var count: IndexDistance {
        return content.count
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

//extension MIDISequence {
//    func callack() {
//        //MusicSequenceSetUserCallback
//        /*
//         typealias MusicSequenceUserCallback = (UnsafeMutableRawPointer?, MusicSequence, MusicTrack, MusicTimeStamp, UnsafePointer<MusicEventUserData>, MusicTimeStamp, MusicTimeStamp) -> Void
//         */
//        MusicSequenceSetUserCallback(ref, { (raw, seq, track, ts, data, ts0, ts1) in
//
//        }, nil)
//    }
//}


///
/// Sequences
///

@inline(__always) fileprivate
func MIDISequenceCreate() -> MusicSequence {
    var ref : MusicSequence? = nil
    OSAssert(NewMusicSequence(&ref))
    return ref!
}

@inline(__always) fileprivate
func MIDISequenceImport(_ url: URL) -> MusicSequence {
    let seq = MIDISequenceCreate()
    OSAssert(MusicSequenceFileLoad(seq, url as CFURL, .midiType, .smf_ChannelsToTracks))
    return seq
}

@inline(__always) fileprivate
func MIDISequenceImport(_ data: Data) -> MusicSequence {
    let seq = MIDISequenceCreate()
    OSAssert(MusicSequenceFileLoadData(seq, data as CFData,
                                       .midiType, .smf_ChannelsToTracks))
    return seq
}

@inline(__always) fileprivate
func MIDISequenceExport(ref: MusicSequence,
                        resolution : Int16 = 960) -> Data {
    var data : Unmanaged<CFData>? = nil
    OSAssert(MusicSequenceFileCreateData(ref, .midiType, .eraseFile, resolution, &data))
    return data!.takeUnretainedValue() as Data
}

@inline(__always) fileprivate
func MIDISequenceSave(ref: MusicSequence,
                      to url: URL,
                      resolution: Int16 = 960) {
    OSAssert(MusicSequenceFileCreate(ref, url as CFURL,
                                     .midiType,
                                     .eraseFile,
                                     resolution))
}

@inline(__always) fileprivate
func MusicSequenceGetTrackCount(ref: MusicSequence) -> Int {
    var c: UInt32 = 0
    OSAssert(MusicSequenceGetTrackCount(ref, &c))
    return Int(c)
}


extension Array where Element == MIDITrack {
    fileprivate init(parent: MIDISequence) {
        let count = MusicSequenceGetTrackCount(ref: parent.ref)
        self = (0..<count).map {
            MIDITrack(sequence: parent, no: $0)
        }
    }
}

