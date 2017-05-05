//
//  MIDIProject.swift
//  KoreMIDI
//
//  Created by Adam Nemecek on 4/7/17.
//
//

import Cocoa

class MIDIProject : NSDocument {
    let sequence: MIDISequence
    
    init(url: URL) {
        sequence = MIDISequence(import: url)
    }
}

//class MIDIProject {
//    let sequence : MIDISequence
//}
//
//class MIDIProjectController : MIDIProject {
//    
//}
