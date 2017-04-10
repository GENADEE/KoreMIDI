//
//  KoreMIDI.swift
//  KoreMIDI
//
//  Created by Adam Nemecek on 4/5/17.
//  Copyright © 2017 Adam Nemecek. All rights reserved.
//



//struct MIDIEventTrack<Event : MIDIEvent> : Sequence {
//    private let ref : MIDITrack
//    
//    init(ref: MIDITrack) {
//        self.ref = ref
//    }
//
//    func makeIterator() -> AnyIterator<Event> {
//        let i = ref.makeIterator()
//        return AnyIterator {
//            while let n = i.next() {
//                if let nn = n as? Event {
//                    return nn
//                }
//            }
//            return nil
//        }
//    }
//}



