//
//  main.swift
//  KoreMIDI
//
//  Created by Adam Nemecek on 4/5/17.
//  Copyright © 2017 Adam Nemecek. All rights reserved.
//

import Foundation

let path = "/Users/adamnemecek/midi/darude-sandstorm.mid"

let s = MIDISequence(path: path)

for (i,e) in s.enumerated() {
    for ee in e {
        print(i, ee)
    }
}
