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
        let header = MemoryLayout<MIDIMetaEvent>.size + MemoryLayout<UInt32>.size
        let alloc = header + data.count

        var data = Data(capacity: alloc)
//        self.init(metaEventType: type,
//                  unused1: 0, unused2: 0, unused3: 0,
//                  dataLength: 0, data: 0)
        fatalError()

    }
}

struct MIDIMetaTimeSignatureEvent {

}
