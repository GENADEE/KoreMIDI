//
//  MIDIPlayer.swift
//  KoreMIDI
//
//  Created by Adam Nemecek on 4/7/17.
//  Copyright © 2017 Adam Nemecek. All rights reserved.
//

import AVFoundation

struct MIDIBank {
    let path : String
}

class MIDIPlayer {
    let sequence : MIDISequence

    private var _player: AVMIDIPlayer? = nil
    private var _isDirty : Bool = true
    private let _bank : URL?
    
    
    init(sequence: MIDISequence, bank: URL? = nil) {
        self.sequence = sequence
        self._bank = bank
    }
    
    private func reload() {
        if _isDirty {
            _player = try! AVMIDIPlayer(data: sequence.export(), soundBankURL: _bank)
            _isDirty = false
        }
        
    }

    func prepareToPlay() {
        _player?.prepareToPlay()
    }
}
