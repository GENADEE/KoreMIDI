//
//  MIDIEventConvertible.swift
//  KoreMIDI
//
//  Created by Adam Nemecek on 4/8/17.
//
//

import Foundation
import AudioToolbox.MusicPlayer



protocol MIDIEventConvertible {
    static var type : MIDIEventType { get }
    func insert(to: MIDITrackImpl, at timestamp: MIDITimestamp)
}

extension MIDINoteMessage : MIDIEventConvertible, Hashable, Comparable, CustomStringConvertible {
    
    public static var type : MIDIEventType {
        return .note
    }
    
    public var description: String {
        return "MIDIMsg(\(note), duration: \(duration))"
    }
    
    internal func insert(to track: MIDITrackImpl, at timestamp: MIDITimestamp) {
        var cpy = self
        MusicTrackNewMIDINoteEvent(track.ref, timestamp.beats, &cpy)
    }
    
    public static func ==(lhs: MIDINoteMessage, rhs: MIDINoteMessage) -> Bool {
        return (lhs.channel, lhs.note, lhs.velocity, lhs.releaseVelocity, lhs.duration) ==
            (rhs.channel, rhs.note, rhs.velocity, rhs.releaseVelocity, rhs.duration)
    }
    
    public static func <(lhs: MIDINoteMessage, rhs: MIDINoteMessage) -> Bool {
        return lhs.note < rhs.note
    }
    
    public var hashValue: Int {
        return note.hashValue
    }
}
