//
//  MIDIProject.swift
//  KoreMIDI
//
//  Created by Adam Nemecek on 4/7/17.
//
//

import Cocoa

class _MIDIEvent : NSData {

}

class MIDIProject : NSDocument {

    let sequence: MIDISequence
    let url : URL

    init(url: URL) {
        self.url = url
        self.sequence = MIDISequence(import: url)
        super.init()
    }
}

//class MIDIProject {
//    let sequence : MIDISequence
//}
//
//class MIDIProjectController : MIDIProject {
//    
//}
