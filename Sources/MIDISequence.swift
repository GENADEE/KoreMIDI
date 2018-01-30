//
//  MIDISequenceImpl.swift
//  KoreMIDI
//
//  Created by Adam Nemecek on 4/7/17.
//
//
import Foundation
import AVFoundation

//extension Array where Element == MIDITrack {
//    fileprivate init(ref: MusicSequence) {
//        let count = MusicSequenceGetTrackCount(ref: ref)
//        self = (0..<count).map {
//            MusicSequence
//        }
//    }
//}

///
/// MIDISequence
///

public final class MIDISequence : RandomAccessCollection, Hashable, Comparable {

    public typealias Index = Int
    public typealias IndexDistance = Index
    public typealias Element = MIDITrack
    public typealias Timestamp = MIDITimestamp

    private var content: [MIDITrack] = []

//    private(set) var tempo: MIDITrack

    internal let ref : MusicSequence

    public init() {
        self.ref = MIDISequenceCreate()
//        tempo = MIDITempoTrack(sequence: self)
    }

    public init(import url: URL) {
        self.ref = MIDISequenceImport(url)
    }

    public init(import data: Data) {
        self.ref = MIDISequenceImport(data)
    }

    public func copy() -> MIDISequence {
        return .init(import: export())
    }

    deinit {
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
        return MusicSequenceGetTrackCount(ref: ref)
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
        return MIDITrack(sequence: self, no: index)
    }


    /*
     typedef CALLBACK_API_C(void,MusicSequenceUserCallback)(
     void *inClientData,
     MusicSequence inSequence,
     MusicTrack inTrack,
     MusicTimeStamp inEventTime,
     const MusicEventUserData *inEventData,
     MusicTimeStamp inStartSliceBeat,
     MusicTimeStamp inEndSliceBeat
     );
     */
    //    func reg(fun: (MIDISequenceImpl, MIDITrack.Impl, MusicTimeStamp, MusicEventUserData, Range<MusicTimeStamp>)) {
    //
    //    }
    //
    //    func register() {
    //
    //    }
    //
    //
    //    internal func register(_ callback: @escaping MusicSequenceUserCallback) {
    //        var c = self
    //        MusicSequenceSetUserCallback(ref, callback, &c)
    //    }
    //
    //    private func unregister() {
    //        MusicSequenceSetUserCallback(ref, nil, nil)
    //    }

    //    private func _registerCallback() {
    //        var c = self
    //        MusicSequenceSetUserCallback(ref, MIDISequenceImpl._callback, &c)
    //    }


}





