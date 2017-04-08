# KoreMIDI: Easiest Standard MIDI File (SMF) Swift library

This project as a wrapper around the AudioToolbox framework and tries to make it look like AVFoundation.
Collections in KoreMIDI are generally copy-on-write, i.e. following the semantics of the built in Swift collection.

```
struct MIDISequence : MutableCollection, RangeReplaceableCollection, Hashable, Comparable {
    typealias Index = Int
    typealias Element = MIDITrack
    

    
    /// Create a new sequence
    init()

    /// Import Data containing MIDI
    init(import data: Data)

    /// 
    init(url: URL)

    /// 
    var type : MusicSequenceType { get }
    
    /// export sequence as data
    func export() -> Data

    ///
    func save(to url: URL)

    ///
    public var tempoTrack: MIDITrack<> { get }
}

```


```

```

```
struct MIDITrack <Element> : Sequence, Hashable, Equatable {
    init()
    var timerange: ClosedRange<MIDITimestamp> { get }
    var startTime: MIDITimestamp { get }
    var endTime: MIDITimestamp { get }
    var duration : Int { get set }

    /// 
    subscript(timerange timerange: ClosedRange<MIDITimestamp>) -> AnyIterator<Element>

    var loopInfo : Int { get set }
    var muted : Bool { get set }
    var soloed : Bool { get set }
    var automatedParams : Bool { get set }
    var timeResolution : Int { get set } 
    
    mutating func move(_ timerange: ClosedRange<MIDITimestamp>, to timestamp: MIDITimestamp)
    
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
