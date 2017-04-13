//
//  main.swift
//  TestBed
//
//  Created by Adam Nemecek on 4/7/17.
//
//

import Foundation
import AudioToolbox

func test() {
    
    let url = URL(fileURLWithPath: "/Users/adamnemecek/midi/darude-sandstorm.mid")
    
    let s = MIDISequence(import: url)
    
    
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
    
    print(s.dict())
    
    
//    var track = s[4]
    
    
    //print(s.start)
    //print("duration", track.duration)
    //track.insert(<#T##MIDIEvent#>, at: <#T##MIDITimestamp#>)
    
//    print(s.startTime!, s.endTime!.beats)
}
test()

func custom() {
    let track = MIDITrack()
    let m = MIDINoteMessage(channel: 0, note: 60, velocity: 100, releaseVelocity: 0, duration: 20)
    //
    m.insert(to: track, at: 10)
    m.insert(to: track, at: 100)
    //
    for e in track {
        print(e)
    }

    print(track)
}
//print(Array(track))




//for a in zip(Timer(), 0...10) {
//    print(a)
//}

//let kls: Classifier<MIDINote, UInt8> = Classifier(notes) { (e: MIDINote) -> UInt8 in
//    e.note
//}
//
//print(kls)
