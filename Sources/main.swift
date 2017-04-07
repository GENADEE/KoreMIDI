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



let notes : [MIDINote] = []

for (i,e) in s.enumerated() {
    
    for (ts, msg) in e {
        let note = MIDINote(timestamp: ts, msg: msg)
        
        print(i, note)
    }
//    print(e.timeResolution)
}


let kls: Classifier<MIDINote, UInt8> = Classifier(notes) { (e: MIDINote) -> UInt8 in
    e.note
}

print(kls)
