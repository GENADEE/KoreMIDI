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

public class MIDISoundbankPlayer {
    private var player: AVMIDIPlayer
    private let bank : URL?

    public var sequence : MIDISequence {
        didSet {
            guard oldValue != sequence else { return }
            reload()
        }
    }

    public init?(sequence: MIDISequence, bank: URL? = nil) {
        guard let player = try? AVMIDIPlayer(sequence: sequence,
                                             soundBankURL: bank) else { return nil }
        self.player = player
        self.sequence = sequence
        self.bank = bank
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

public class Player {
    private let content: MusicPlayer

    public var sequence : MIDISequence {
        didSet {
            guard oldValue != sequence else { return }
            reload()
        }
    }

    init(sequence: MIDISequence) {
        content = MIDIPlayerCreate()
        self.sequence = sequence
        reload() // todo do i need this?
    }

    private func reload() {
        OSAssert(MusicPlayerSetSequence(content, sequence.ref))
    }

    deinit {
        DisposeMusicPlayer(content)
    }

    public func play() {
        OSAssert(MusicPlayerStart(content))
    }

    public func stop() {
        OSAssert(MusicPlayerStop(content))
    }

    func preroll() {
        OSAssert(MusicPlayerPreroll(content))
//        public func MusicPlayerGetBeatsForHostTime(_ inPlayer: MusicPlayer, _ inHostTime: UInt64, _ outBeats: UnsafeMutablePointer<MusicTimeStamp>) -> OSStatus
//
//        public func MusicPlayerGetHostTimeForBeats(_ inPlayer: MusicPlayer, _ inBeats: MusicTimeStamp, _ outHostTime: UnsafeMutablePointer<UInt64>) -> OSStatus
//
//        public func MusicPlayerGetTime(_ inPlayer: MusicPlayer, _ outTime: UnsafeMutablePointer<MusicTimeStamp>) -> OSStatus
//        public func MusicPlayerSetTime(_ inPlayer: MusicPlayer, _ inTime: MusicTimeStamp) -> OSStatus



    }

    public var rate: Float {
        get {
            var rate: Float64 = 0
            OSAssert(MusicPlayerGetPlayRateScalar(content, &rate))
            return Float(rate)
        }
        set {
            OSAssert(MusicPlayerSetPlayRateScalar(content, Float64(newValue)))
        }
    }

    public var isPlaying: Bool {
        var ret: DarwinBoolean = false
        OSAssert(MusicPlayerIsPlaying(content, &ret))
        return Bool(ret)
    }

    public var currentPosition : TimeInterval {
        fatalError()
    }
}

@inline(__always) fileprivate
func MIDIPlayerCreate() -> MusicPlayer {
    var ref : MusicPlayer? = nil
    OSAssert(NewMusicPlayer(&ref))
    return ref!
}

//class MIDIPlayer2 : AVMIDIPlayer {
//    init(sequence: MIDISequence, bank: URL? = nil) {
//
//    }
//}


//class MIDIPlayer2 {
//    private let player: MusicPlayer
//    var sequence: MIDISequence {
//        didSet {
//
//        }
//    }
//
//    var time: MusicTimeStamp {
//        get {
//            fatalError()
//        }
//        set {
//            fatalError()
//        }
//    }
//
//    private init() {
//        player = MIDIPlayerCreate()
//        fatalError()
//    }
//
//    static let shared = MIDIPlayer2()
//
//    deinit {
//        DisposeMusicPlayer(player)
//    }
////    init(sequence: MIDISequence) {
////
////    }
//
//    public var isPlaying: Bool {
//        fatalError()
//    }
//
//
//}

