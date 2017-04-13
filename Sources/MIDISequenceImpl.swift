//
//  MIDISequenceImpl.swift
//  KoreMIDI
//
//  Created by Adam Nemecek on 4/7/17.
//
//

import AudioToolbox.MusicPlayer


struct SequenceNotification {
    let sequence: MIDISequenceImpl
    let track: MIDITrack.Impl
    let ts: MusicTimeStamp
    let event: MusicEventUserData
    let ts2: MusicTimeStamp
    let ts3: MusicTimeStamp
}

///
/// MIDISequence
///


internal final class MIDISequenceImpl : Collection, Hashable, Comparable {
    
    internal typealias Index = Int
    internal typealias IndexDistance = Index
    internal typealias Element = MIDITrack
    
    internal let ref : MusicSequence
    
    internal init() {
        ref = MIDISequenceCreate()
    }
    
    internal init(for track: MIDITrack.Impl) {
        ref = MusicTrackGetSequence(track.ref)
    }
    
    internal init(import url: URL) {
        ref = MIDISequenceImport(url)
    }
    
    internal init(import data: Data) {
        ref = MIDISequenceImport(data)
    }
    
    internal func copy() -> MIDISequenceImpl {
        return MIDISequenceImpl(import: export())
    }
    
    deinit {
        DisposeMusicSequence(ref)
    }
    
    
    
//    private static var callback: MusicSequenceUserCallback {
//        get {
//            fatalError()
//        }
//    }
//    
    internal static func ==(lhs: MIDISequenceImpl, rhs: MIDISequenceImpl) -> Bool {
        return lhs === rhs || lhs.elementsEqual(rhs)
    }

    internal static func ===(lhs: MIDISequenceImpl, rhs: MIDISequenceImpl) -> Bool {
        return lhs.ref == rhs.ref
    }

    internal static func <(lhs: MIDISequenceImpl, rhs: MIDISequenceImpl) -> Bool {
        return lhs.hashValue < rhs.hashValue
    }
    
    internal var hashValue: Int {
        return hashValue()
    }
    
    internal func export() -> Data {
        return MIDISequenceExport(ref: ref)
    }
    
    internal func save(to url: URL) throws {
        try export().write(to: url)
    }
    
    internal var type : MusicSequenceType {
        get {
            return MusicSequenceGetSequenceType(ref: ref)
        }
        //        set {
        //            MusicSequenceSetSequenceType(ref, newValue)
        //        }
    }
    
//    func remove
    
    internal var count: IndexDistance {
        return MusicSequenceGetTrackCount(ref: ref)
    }
    
    internal var startTime : MIDITimestamp? {
        return lazy.map { $0.startTime }.reduce(combine: Swift.min)
    }

    internal var endTime : MIDITimestamp? {
        return lazy.map { $0.endTime }.reduce(combine: Swift.max)
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
