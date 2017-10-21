//
//  MIDISequenceImpl.swift
//  KoreMIDI
//
//  Created by Adam Nemecek on 4/7/17.
//
//

import AudioToolbox.MusicPlayer


struct SequenceNotification {
    let sequence: MIDISequence
    let track: MIDITrack
    let ts: MusicTimeStamp
    let event: MusicEventUserData
    let range: Range<MusicTimeStamp>
}

///
/// MIDISequence
///

public final class MIDISequence : RandomAccessCollection, Hashable, Comparable {

    public typealias Index = Int
    public typealias IndexDistance = Index
    public typealias Element = MIDITrack
    public typealias Timestamp = MIDITimestamp

    public var tempo: MIDITrack {
        return .init(parent : self)
    }

    internal let ref : MusicSequence

    //        let clock : Clock

    public init() {
        ref = MIDISequenceCreate()
//        tempo =
        fatalError()
        //            clock = Clock(sequence: ref)
    }

    public init(for track: MIDITrack) {
        ref = MusicTrackGetSequence(track.ref)
        fatalError()
        //            clock = Clock(sequence: ref)
    }

    public init(import url: URL) {
        ref = MIDISequenceImport(url)
        fatalError()
        //            clock = Clock(sequence: ref)
    }

    public init(import data: Data) {
        ref = MIDISequenceImport(data)
        fatalError()
//        tempo =
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
        //            return hashValue()
        fatalError()
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
        return MIDITrack(parent: self, no: index)
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





