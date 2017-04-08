//
//  MIDISequenceImpl.swift
//  KoreMIDI
//
//  Created by Adam Nemecek on 4/7/17.
//
//

import AudioToolbox.MusicPlayer

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
    
    internal init(for track: MIDITrackImpl) {
        ref = MusicTrackGetSequence(track.ref)
    }
    
    internal init(url: URL) {
        ref = MIDISequenceImport(url: url)
    }
    
    internal init(import data: Data) {
        ref = MIDISequenceImport(import: data)
    }
    
    internal func copy() -> MIDISequenceImpl {
        return MIDISequenceImpl(import: export())
    }
    
    deinit {
        DisposeMusicSequence(ref)
    }
    
    internal static func ==(lhs: MIDISequenceImpl, rhs: MIDISequenceImpl) -> Bool {
        return lhs.ref == rhs.ref
    }
    
    //    internal static func ===(lhs: MIDISequenceImpl, rhs: MIDISequenceImpl) -> Bool {
    //        return lhs.ref == rhs.ref
    //    }
    
    internal static func <(lhs: MIDISequenceImpl, rhs: MIDISequenceImpl) -> Bool {
        return lhs.hashValue < rhs.hashValue
    }
    
    internal var hashValue: Int {
        return ref.hashValue
    }
    
    internal func export() -> Data {
        return MIDISequenceExport(ref: ref)
    }
    
    internal func save(to: URL) {
        fatalError()
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
    
    internal var startIndex: Index {
        return 0
    }
    
    internal var count: IndexDistance {
        return MusicSequenceGetTrackCount(ref: ref)
    }
    
    var startTime : MIDITimestamp? {
        return lazy.map { $0.startTime }.reduce  { Swift.min($0, $1) }
    }

    var endTime : MIDITimestamp? {
        return lazy.map { $0.endTime }.reduce  { Swift.max($0, $1) }
    }
    
    internal var endIndex : Index {
        return startIndex + count
    }
    
    internal func index(after i: Index) -> Index {
        return i + 1
    }
    
    internal subscript(index: Index) -> Element {
        return MIDITrack(seq: self, no: index)
    }
}
