# KoreMIDI: Easiest Standard MIDI File (SMF) Swift library

This project as a wrapper around the AudioToolbox framework and tries to make it look like AVFoundation.

## MIDITimestamp

MIDITimestamp is the timestamp in the context of a . 

```
struct MIDITimestamp : Comparable, Hashable, Strideable, CustomStringConvertible {
    var beats: MusicTimeStamp { get }
    var seconds: Float64 { get }
    func beatTime(for subdivisor: UInt32 = 4) -> CABarBeatTime
    static func +(lhs: MIDITimestamp, rhs: MIDITimestamp) -> MIDITimestamp
}
```

```
struct MIDISequence : Collection, Comparable {
    typealias Index = Int
    typealias Element = MIDITrack
    
    func export() -> Data
    func 
    
}

```


```

```

```
struct MIDITrack : Sequence< Equatable {
    
}
```

```
struct {
}
```

 
