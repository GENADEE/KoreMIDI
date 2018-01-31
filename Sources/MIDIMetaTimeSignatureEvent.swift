//
//  MIDIMetaTimeSignatureEvent.swift
//  KoreMIDI
//
//  Created by Adam Nemecek on 1/31/18.
//

import AudioToolbox.MusicPlayer
import Foundation



extension AudioToolbox.MIDIMetaEvent {

//    var data: Data {
//
//        return Data(bytesNoCopy: <#T##UnsafeMutableRawPointer#>, count: <#T##Int#>, deallocator: <#T##Data.Deallocator#>)
//    }

    init(type: UInt8, data: Data) {
        let header = MemoryLayout<AudioToolbox.MIDIMetaEvent>.size - MemoryLayout<UInt8>.size
        let alloc = header + data.count

        var data = Data(capacity: alloc)
//        self.init(metaEventType: type,
//                  unused1: 0, unused2: 0, unused3: 0,
//                  dataLength: 0, data: 0)
        fatalError()

    }
}

struct MIDIMetaEvent2 {
    enum Subtype: UInt8 {
        case sequenceNumber = 0x00,
        textEvent = 0x01,
        copyrightNotice = 0x02,
        trackSequenceName = 0x03,
        instrumentName  = 0x04,
        lyricText = 0x05,
        markerText              = 0x06,
        cuePoint                = 0x07,
        MIDIChannelPrefix       = 0x20,
        endOfTrack              = 0x2F,
        tempoSetting            = 0x51,
        SMPTEOffset             = 0x54,
        timeSignature           = 0x58,
        keySignature            = 0x59,
        sequencerSpecificEvent  = 0x7F,
        invalid                    = 0x66
    }

    private var data: Data

    

    init(type: Subtype, data: Data) {
        let header = MemoryLayout<AudioToolbox.MIDIMetaEvent>.size - MemoryLayout<UInt8>.size
        let alloc = header + data.count
        fatalError()
    }

    func insert(to: MIDIMetaTrack) {

    }
}
struct MIDIMetaTimeSignatureEvent {

}
