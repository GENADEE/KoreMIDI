//
//  main.swift
//  KoreMIDI
//
//  Created by Adam Nemecek on 4/5/17.
//  Copyright © 2017 Adam Nemecek. All rights reserved.
//

import Foundation
import AudioToolbox

let path = "/Users/adamnemecek/midi/darude-sandstorm.mid"

let s = MIDISequence(path: path)

struct Note : Equatable, CustomStringConvertible {
    let note: UInt8
    let timestamp: Timestamp
    let duration: Float32
    
    
    init(timestamp: Timestamp, msg: MIDINoteMessage) {
        self.timestamp = timestamp
        self.note = msg.note
        self.duration = msg.duration
    }
    
    var description: String {
        return "Note(note: \(note), timestamp: \(timestamp), duration: \(duration))"
    }
    
    static func ==(lhs: Note, rhs: Note) -> Bool {
        return lhs.note == rhs.note && lhs.timestamp == rhs.timestamp && lhs.duration == rhs.duration
    }
}

for (i,e) in s.enumerated() {
    
    for (ts, msg) in e {
        let note = Note(timestamp: ts, msg: msg)
        print(i, note)
    }
}
