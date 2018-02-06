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

extension AVMIDIPlayer {
    convenience init(sequence: MIDISequence, soundBankURL: URL? = nil) throws {
        try self.init(data: sequence.export(), soundBankURL: soundBankURL)
    }
}

public class MIDIPlayer {
    let sequence : MIDISequence

    private var player: AVMIDIPlayer
    private var isDirty : Bool = true
    private let bank : URL?

    public init?(sequence: MIDISequence, bank: URL? = nil) {
        self.sequence = sequence
        self.bank = bank

        guard let player = try? AVMIDIPlayer(sequence: sequence, soundBankURL: bank) else { return nil }
        self.player = player
    }

    private func reload() {
        player = try! AVMIDIPlayer(sequence: sequence, soundBankURL: bank)
    }

    public func play(_ callback: @escaping () -> () = {}) {
        player.play(callback)
    }

    public func prepareToPlay() {
        player.prepareToPlay()
    }

    public func stop() {
        player.stop()
    }

    public var rate: Float {
        get {
            return player.rate
        }
        set {
            player.rate = newValue
        }
    }

    public var isPlaying: Bool {
        return player.isPlaying
    }

    public var currentPosition : TimeInterval {
        return player.currentPosition
    }
}
