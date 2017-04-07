//
//  main.swift
//  TestBed
//
//  Created by Adam Nemecek on 4/7/17.
//
//

import Foundation
import AudioToolbox

let path = "/Users/adamnemecek/midi/darude-sandstorm.mid"

let s = MIDISequence(path: path)



//let notes : [MIDINote] = []
//
for (i,track) in s.enumerated() {

    for note in track {
        print(note)
    }
    //    print(e.timeResolution)
}

for (i, track) in s.enumerated() {
    print(i, track)
//    track[note] = note
}


//for a in zip(Timer(), 0...10) {
//    print(a)
//}

//let kls: Classifier<MIDINote, UInt8> = Classifier(notes) { (e: MIDINote) -> UInt8 in
//    e.note
//}
//
//print(kls)
