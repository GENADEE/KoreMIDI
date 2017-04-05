//
//  Disposables.swift
//  KoreMIDI
//
//  Created by Adam Nemecek on 4/5/17.
//  Copyright © 2017 Adam Nemecek. All rights reserved.
//

import Foundation

import AudioToolbox

protocol Disposable {
    func dispose()
    
}
//
//struct MIDITrack : Disposable {
//    private let ref : MusicTrack
//    
//    func dispose() {
//        MusicTrack
//    }
//}

////class MIDIRef {
////    let ref: OpaquePointer
////}
//
//class MIDITrackRef : MIDIRef {
//    deinit {
//        
//    }
//}
