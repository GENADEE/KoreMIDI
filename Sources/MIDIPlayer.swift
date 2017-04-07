//
//  MIDIPlayer.swift
//  KoreMIDI
//
//  Created by Adam Nemecek on 4/7/17.
//  Copyright © 2017 Adam Nemecek. All rights reserved.
//

import AVFoundation

class MIDIPlayer {
    let sequence : MIDISequence

    private var player: AVMIDIPlayer? = nil
    private var isDirty : Bool = true
    
    init(sequence: MIDISequence) {
        self.sequence = sequence
    }
    
    private func reload() {
        if isDirty {
            
            isDirty = false
        }
        
    }

    func prepareToPlay() {
        player?.prepareToPlay()
        
    }
}
