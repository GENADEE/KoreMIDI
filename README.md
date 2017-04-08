# KoreMIDI: Easiest Standard MIDI File (SMF) Swift library

This project as a wrapper around the AudioToolbox framework and tries to make it look like AVFoundation.
Collections in KoreMIDI are generally copy-on-write, i.e. following the semantics of the built in Swift collection.

```
struct MIDISequence : MutableCollection, Comparable {
    typealias Index = Int
    typealias Element = MIDITrack
    
    func export() -> Data
    
    /// Create a new sequence
    init()

    /// Import Data containing MIDI
    init(import data: Data)

    /// 
    init(url: URL)

    
  
}

```


```

```

```
struct MIDITrack : Sequence, Hashable, Equatable {
    init()
    var timerange: ClosedRange<MIDITimestamp> { get }
    var startTime: MIDITimestamp { get }
    var endTime: MIDITimestamp { get }

}
```

```
struct {
}
```

 

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
enum MIDIEventType : RawRepresentable {
    case extendedNote, extendedTempo, user, meta, note, channel, rawData, parameter, auPreset
}

```
