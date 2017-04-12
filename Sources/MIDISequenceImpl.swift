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
    
    internal init(for track: MIDITrack.Impl) {
        ref = MusicTrackGetSequence(track.ref)
    }
    
    internal init(import url: URL) {
        ref = MIDISequenceImport(url)
    }
    
    internal init(import data: Data) {
        ref = MIDISequenceImport(data)
//        MusicSequenceSetUserCallback(ref, MIDISequenceImpl.callback, <#T##inClientData: UnsafeMutableRawPointer?##UnsafeMutableRawPointer?#>)
    }
    
    internal func copy() -> MIDISequenceImpl {
        return MIDISequenceImpl(import: export())
    }
    
    deinit {
        MusicSequenceSetUserCallback(ref, nil, nil)
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
    
    internal var startTime : MIDITimestamp? {
        return lazy.map { $0.startTime }.reduce(combine: Swift.min)
    }

    internal var endTime : MIDITimestamp? {
        return lazy.map { $0.endTime }.reduce(combine: Swift.max)
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
    
    private func _registerCallback() {
        var c = self
        MusicSequenceSetUserCallback(ref, MIDISequenceImpl._callback, &c)
    }
    
    private static let _callback: MusicSequenceUserCallback = {
        ref, seq, mt, timestamp, userData, timestamp2, timestamp3 in
        // Cタイプ関数なのでselfを使えません
        //let mySelf: Sequencer = bridge(obj)
        let impl = unsafeBitCast(ref, to: MIDISequenceImpl.self)
//        for listener in mySelf.midiListeners {
//            OperationQueue.main.addOperation({
//                listener.midiSequenceDidFinish()
//            })
//        }
    }
}
