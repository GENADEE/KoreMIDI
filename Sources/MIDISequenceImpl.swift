//
//  MIDISequenceImpl.swift
//  KoreMIDI
//
//  Created by Adam Nemecek on 4/7/17.
//
//

import AudioToolbox.MusicPlayer


struct SequenceNotification {
    let sequence: MIDISequence.Impl
    let track: MIDITrack.Impl
    let ts: MusicTimeStamp
    let event: MusicEventUserData
    let range: Range<MusicTimeStamp>
}

///
/// MIDISequence
///

extension MIDISequence {
    internal final class Impl : Collection, Hashable, Comparable {

        internal typealias Index = Int
        internal typealias IndexDistance = Index
        internal typealias Element = MIDITrack
        internal typealias Timestamp = MIDITimestamp

        internal let ref : MusicSequence

        //        let clock : Clock

        internal init() {
            ref = MIDISequenceCreate()
            //            clock = Clock(sequence: ref)
        }

        internal init(for track: MIDITrack.Impl) {
            ref = MusicTrackGetSequence(track.ref)
            //            clock = Clock(sequence: ref)
        }

        internal init(import url: URL) {
            ref = MIDISequenceImport(url)
            //            clock = Clock(sequence: ref)
        }

        internal init(import data: Data) {
            ref = MIDISequenceImport(data)
            //            clock = Clock(sequence: ref)
        }

        internal func copy() -> Impl {
            return Impl(import: export())
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
        internal static func ==(lhs: Impl, rhs: Impl) -> Bool {
            return lhs === rhs || lhs.elementsEqual(rhs)
        }

        internal static func ===(lhs: Impl, rhs: Impl) -> Bool {
            return lhs.ref == rhs.ref
        }

        internal static func <(lhs: Impl, rhs: Impl) -> Bool {
            return lhs.hashValue < rhs.hashValue
        }

        internal var hashValue: Int {
            //            return hashValue()
            fatalError()
        }

        internal func export() -> Data {
            return MIDISequenceExport(ref: ref)
        }

        internal func save(to url: URL) {
            MIDISequenceExport(ref: ref, to: url)
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

        internal var count: IndexDistance {
            return MusicSequenceGetTrackCount(ref: ref)
        }

        internal var startTime : Timestamp {
            return lazy.map { $0.startTime }.reduce(combine: Swift.min) ?? 0
        }

        internal var endTime : Timestamp {
            return lazy.map { $0.endTime }.reduce(combine: Swift.max) ?? 0
        }

        internal var startIndex: Index {
            return 0
        }

        internal var endIndex : Index {
            return count
        }

        internal func index(after i: Index) -> Index {
            return i + 1
        }

        internal subscript(index: Index) -> Element {
            return MIDITrack(seq: self, no: index)
        }

        internal lazy var tempoTrack: MIDITrack.Impl = ({
            return MIDITrack.Impl(tempoTrack: self)
        })()
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
}
