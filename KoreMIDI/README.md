#KoreMIDI: Easiest Standard MIDI File (SMF) Swift library

This project as a wrapper around the AudioToolbox framework and tries to make it look like AVFoundation.

#MIDITimestamp

```
struct MIDITimestamp : Comparable, Hashable, Strideable, CustomStringConvertible {
    var beats: MusicTimeStamp { get }
    var seconds: Float64 { get }
    func beatTime(for subdivisor: UInt32 = 4) -> CABarBeatTime
    static func +(lhs: MIDITimestamp, rhs: MIDITimestamp) -> MIDITimestamp
}
```

```
struct MIDISequence : Collection {
    typealias Index = Int
    typealias Element = MIDITrack
    
    
}

```


```

```

```
struct MIDITrack {
    
}
```

```
struct {
}
```

 
