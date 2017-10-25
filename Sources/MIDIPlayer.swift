//
//  MIDIPlayer.swift
//  KoreMIDI
//
//  Created by Adam Nemecek on 4/7/17.
//  Copyright © 2017 Adam Nemecek. All rights reserved.
//

import AVFoundation

//struct MIDIBank {
//    let path : String
//}

//enum Status {
//    case
//}

public class MIDIPlayer {
    let sequence : MIDISequence

    private var player: AVMIDIPlayer
    private var isDirty : Bool = true
    private let bank : URL?

    public init?(sequence: MIDISequence, bank: URL? = nil) {
        self.sequence = sequence
        self.bank = bank
        do {
            player = try! AVMIDIPlayer(data: sequence.export(), soundBankURL: bank)
        }
        catch {
            return nil
        }
    }

    private func reload() {
        player = try! AVMIDIPlayer(data: sequence.export(), soundBankURL: bank)
    }

    public func play(_ callback: @escaping () -> () = {}) {
        player.play(callback)
    }

    public func prepareToPlay() {
        player.prepareToPlay()
    }

    public var currentPosition : TimeInterval {
        return player.currentPosition
    }
}
