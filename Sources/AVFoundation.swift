//
//  AVFoundation.swift
//  KoreMIDI
//
//  Created by Adam Nemecek on 4/7/17.
//  Copyright © 2017 Adam Nemecek. All rights reserved.
//

import AVFoundation

class MIDIPlayer : AVMIDIPlayer {
    let sequence : MIDISequence
    
    private var isDirty : Bool = false
    
    init(sequence: MIDISequence) {
        self.sequence = sequence
        super.init()
    }
    
    private func reload() {
        if isDirty {
            
            isDirty = false
        }
        
    }

    override func prepareToPlay() {
        super.prepareToPlay()
        reload()
    }
}
