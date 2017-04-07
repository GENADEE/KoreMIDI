//
//  MIDITrack.swift
//  KoreMIDI
//
//  Created by Adam Nemecek on 4/5/17.
//  Copyright © 2017 Adam Nemecek. All rights reserved.
//

import Foundation
import AudioToolbox.MusicPlayer

internal final class MIDITrackImpl : Sequence, Equatable, Comparable, Hashable, CustomStringConvertible {
    internal typealias Iterator = MIDITrackIterator
    internal typealias Element = Iterator.Element
    
    internal let ref : MusicTrack
    internal var parent: MIDISequenceImpl
    
    init() {
//        let s = MIDISequenceImpl()
        
        fatalError()
        //        ref = M
        //        parent = nil
    }
    
    internal init(seq: MIDISequenceImpl) {
        ref = MIDITrackCreate(ref: seq.ref)
        parent = seq
    }
    
    internal init(seq: MIDISequenceImpl, no: Int) {
        ref = MusicSequenceGetIndTrack(ref: seq.ref, no: no)
        parent = seq
    }
    
    internal func copy() -> MIDITrackImpl {
        var cpy = MIDITrackImpl()
        //        fatalError()
        cpy.copyInsert(from: self, in: timerange, at: startTime)
        return cpy
    }
    
    internal var timerange: ClosedRange<MIDITimestamp> {
        return startTime...endTime
    }
    
    internal static func ==(lhs: MIDITrackImpl, rhs: MIDITrackImpl) -> Bool {
        return lhs.ref == rhs.ref || lhs.elementsEqual(rhs)
    }
    
    internal static func <(lhs: MIDITrackImpl, rhs: MIDITrackImpl) -> Bool {
        return lhs.ref.hashValue < rhs.ref.hashValue
    }
    
    internal var description: String {
        var opts: [String] = []
        if soloed {
            opts.append("soloed")
        }
        
        if muted {
            opts.append("muted")
        }
        
        return "MIDITrackImpl(in:\(timerange), \(opts))"
    }
    
    internal subscript(timerange timerange: ClosedRange<MIDITimestamp>) -> AnyIterator<Element> {
        fatalError()
    }
    
    internal var startTime : MIDITimestamp {
        return MIDITimestamp(base: parent, beats: MusicTimeStamp(offsetTime))
    }
    
    internal var endTime : MIDITimestamp {
        return startTime.advanced(by: MusicTimeStamp(duration))
    }
    
    internal func makeIterator() -> Iterator {
        //        return MIDITrackIterator(self)
        fatalError()
    }
    
    internal var hashValue: Int {
        return ref.hashValue
    }
    
    internal var offsetTime : Int {
        get {
            //            let offset = self[.offsetTime]
            return tee(self[.offsetTime])
        }
        set {
            self[.offsetTime] = newValue
        }
    }
    
    internal var duration : Int {
        get {
            return self[.length]
        }
        set {
            self[.length] = newValue
        }
    }
    
    internal var loopInfo : Int {
        get {
            return self[.loopInfo]
        }
        set {
            self[.loopInfo] = newValue
        }
    }
    
    internal var muted : Bool {
        get {
            return Bool(self[.muted])
        }
        set {
            self[.muted] = Int(newValue)
        }
    }
    
    internal var soloed : Bool {
        get {
            return Bool(self[.soloed])
        }
        set {
            self[.soloed] = Int(newValue)
        }
    }
    
    internal var automatedParameters : Bool {
        get {
            return Bool(self[.automatedParams])
        }
        set {
            self[.automatedParams] = Int(newValue)
        }
    }
    
    internal var timeResolution : Int {
        get {
            return self[.resolution]
        }
        set {
            self[.resolution] = newValue
        }
    }
    
    private subscript(prop: MIDITrackProp) -> Int {
        @inline(__always)
        get {
            return MIDITrackGetProperty(ref: ref, prop: prop.rawValue)
        }
        @inline(__always)
        set {
            MIDITrackSetProperty(ref: ref, prop: prop.rawValue, to: newValue)
        }
    }
    
    subscript(element element: Element) -> Element {
        get {
            fatalError()
        }
        set {
            guard element != newValue else { return }
            let i = MIDITrackIterator(self, timerange: element.timerange)
            i[element] = newValue
        }
    }
    
    //    mutating
    internal func move(_ timerange: ClosedRange<MIDITimestamp>, to timestamp: MIDITimestamp) {
        MusicTrackMoveEvents(ref,
                             timerange.lowerBound.beats,
                             timerange.upperBound.beats,
                             timestamp.beats)
    }
    
    //    mutating
    internal func clear(_ timerange: ClosedRange<MIDITimestamp>) {
        MusicTrackClear(ref,
                        timerange.lowerBound.beats,
                        timerange.upperBound.beats)
    }
    
    internal func clearAll() {
        clear(timerange)
    }
    
    //    mutating
    internal func cut(_ timerange: ClosedRange<MIDITimestamp>) {
        MusicTrackCut(ref,
                      timerange.lowerBound.beats,
                      timerange.upperBound.beats)
    }
    
    //    mutating
    internal func copyInsert(from other: MIDITrackImpl, in timerange: ClosedRange<MIDITimestamp>, at timestamp: MIDITimestamp) {
        MusicTrackCopyInsert(other.ref,
                             timerange.lowerBound.beats,
                             timerange.upperBound.beats,
                             ref,
                             timestamp.beats)
    }
    
    //    mutating
    internal func merge(with other: MIDITrackImpl, in timerange: ClosedRange<MIDITimestamp>, at timestamp: MIDITimestamp) {
        MusicTrackMerge(other.ref,
                        timerange.lowerBound.beats,
                        timerange.upperBound.beats,
                        ref,
                        timestamp.beats)
    }
    
    //    mutating
    internal func add(_ event: MIDIEvent, at timestamp: MIDITimestamp) {
        event.add(to: self, at: timestamp)
        //        fatalError()
    }
    
    internal func remove<S : Sequence>(_ elements: S) where S.Iterator.Element == Element {
        //        remove(÷
        fatalError()
    }
    
    internal func remove(_ timerange: ClosedRange<MIDITimestamp>) {
        fatalError()
    }
}

//extension MIDITrackImpl : SetAlgebra {
//    
//    /// Removes the elements of the set that are also in the given set and adds
//    /// the members of the given set that are not already in the set.
//    ///
//    /// In the following example, the elements of the `employees` set that are
//    /// also members of `neighbors` are removed from `employees`, while the
//    /// elements of `neighbors` that are not members of `employees` are added to
//    /// `employees`. In particular, the names `"Alicia"`, `"Chris"`, and
//    /// `"Diana"` are removed from `employees` while the names `"Forlani"` and
//    /// `"Greta"` are added.
//    ///
//    ///     var employees: Set = ["Alicia", "Bethany", "Chris", "Diana", "Eric"]
//    ///     let neighbors: Set = ["Bethany", "Eric", "Forlani", "Greta"]
//    ///     employees.formSymmetricDifference(neighbors)
//    ///     print(employees)
//    ///     // Prints "["Diana", "Chris", "Forlani", "Alicia", "Greta"]"
//    ///
//    /// - Parameter other: A set of the same type.
//    public func formSymmetricDifference(_ other: MIDITrackImpl) {
////        content.formSymmetricDifference(other.content)
//        fatalError()
//    }
//    
//    public var isEmpty: Bool {
////        return content.isEmpty
//        fatalError()
//    }
//    
//    /// Removes the elements of this set that aren't also in the given set.
//    ///
//    /// In the following example, the elements of the `employees` set that are
//    /// not also members of the `neighbors` set are removed. In particular, the
//    /// names `"Alicia"`, `"Chris"`, and `"Diana"` are removed.
//    ///
//    ///     var employees: Set = ["Alicia", "Bethany", "Chris", "Diana", "Eric"]
//    ///     let neighbors: Set = ["Bethany", "Eric", "Forlani", "Greta"]
//    ///     employees.formIntersection(neighbors)
//    ///     print(employees)
//    ///     // Prints "["Bethany", "Eric"]"
//    ///
//    /// - Parameter other: A set of the same type as the current set.
//    public func formIntersection(_ other: MIDITrackImpl) {
////        content.formIntersection(other.content)
//        fatalError()
//    }
//    
//    /// Adds the elements of the given set to the set.
//    ///
//    /// In the following example, the elements of the `visitors` set are added to
//    /// the `attendees` set:
//    ///
//    ///     var attendees: Set = ["Alicia", "Bethany", "Diana"]
//    ///     let visitors: Set = ["Marcia", "Nathaniel"]
//    ///     attendees.formUnion(visitors)
//    ///     print(attendees)
//    ///     // Prints "["Diana", "Nathaniel", "Bethany", "Alicia", "Marcia"]"
//    ///
//    /// If the set already contains one or more elements that are also in
//    /// `other`, the existing members are kept.
//    ///
//    ///     var initialIndices = Set(0..<5)
//    ///     initialIndices.formUnion([2, 3, 6, 7])
//    ///     print(initialIndices)
//    ///     // Prints "[2, 4, 6, 7, 0, 1, 3]"
//    ///
//    /// - Parameter other: A set of the same type as the current set.
//    public func formUnion(_ other: MIDITrackImpl) {
////        content.formUnion(other.content)
//        fatalError()
//    }
//    
//    /// Inserts the given element into the set unconditionally.
//    ///
//    /// If an element equal to `newMember` is already contained in the set,
//    /// `newMember` replaces the existing element. In this example, an existing
//    /// element is inserted into `classDays`, a set of days of the week.
//    ///
//    ///     enum DayOfTheWeek: Int {
//    ///         case sunday, monday, tuesday, wednesday, thursday,
//    ///             friday, saturday
//    ///     }
//    ///
//    ///     var classDays: Set<DayOfTheWeek> = [.monday, .wednesday, .friday]
//    ///     print(classDays.update(with: .monday))
//    ///     // Prints "Optional(.monday)"
//    ///
//    /// - Parameter newMember: An element to insert into the set.
//    /// - Returns: For ordinary sets, an element equal to `newMember` if the set
//    ///   already contained such a member; otherwise, `nil`. In some cases, the
//    ///   returned element may be distinguishable from `newMember` by identity
//    ///   comparison or some other means.
//    ///
//    ///   For sets where the set type and element type are the same, like
//    ///   `OptionSet` types, this method returns any intersection between the
//    ///   set and `[newMember]`, or `nil` if the intersection is empty.
//    @discardableResult
//    public final func update(with newMember: Element) -> Element? {
////        var i = MIDITrackIterator(self, timerange: newMember.time)
//        
//        
////        return content.update(with: newMember)
//        fatalError()
//    }
//    
//    public func subtracting(_ other: MIDITrackImpl) -> Self {
////        return type(of: self).init(content: content.subtracting(other.content))
//        fatalError()
//    }
//    
//    /// Removes the given element and any elements subsumed by the given element.
//    ///
//    /// - Parameter member: The element of the set to remove.
//    /// - Returns: For ordinary sets, an element equal to `member` if `member` is
//    ///   contained in the set; otherwise, `nil`. In some cases, a returned
//    ///   element may be distinguishable from `newMember` by identity comparison
//    ///   or some other means.
//    ///
//    ///   For sets where the set type and element type are the same, like
//    ///   `OptionSet` types, this method returns any intersection between the set
//    ///   and `[member]`, or `nil` if the intersection is empty.
//    @discardableResult
//    public func remove(_ member: Element) -> Element? {
////        return content.remove(member)
//        fatalError()
//    }
//    
//    /// Inserts the given element in the set if it is not already present.
//    ///
//    /// If an element equal to `newMember` is already contained in the set, this
//    /// method has no effect. In this example, a new element is inserted into
//    /// `classDays`, a set of days of the week. When an existing element is
//    /// inserted, the `classDays` set does not change.
//    ///
//    ///     enum DayOfTheWeek: Int {
//    ///         case sunday, monday, tuesday, wednesday, thursday,
//    ///             friday, saturday
//    ///     }
//    ///
//    ///     var classDays: Set<DayOfTheWeek> = [.wednesday, .friday]
//    ///     print(classDays.insert(.monday))
//    ///     // Prints "(true, .monday)"
//    ///     print(classDays)
//    ///     // Prints "[.friday, .wednesday, .monday]"
//    ///
//    ///     print(classDays.insert(.friday))
//    ///     // Prints "(false, .friday)"
//    ///     print(classDays)
//    ///     // Prints "[.friday, .wednesday, .monday]"
//    ///
//    /// - Parameter newMember: An element to insert into the set.
//    /// - Returns: `(true, newMember)` if `newMember` was not contained in the
//    ///   set. If an element equal to `newMember` was already contained in the
//    ///   set, the method returns `(false, oldMember)`, where `oldMember` is the
//    ///   element that was equal to `newMember`. In some cases, `oldMember` may
//    ///   be distinguishable from `newMember` by identity comparison or some
//    ///   other means.
//    @discardableResult
//    public func insert(_ newMember: Element) -> (inserted: Bool, memberAfterInsert: Element) {
////        return content.insert(newMember)
//        fatalError()
//    }
//    
//    /// Returns a new set with the elements that are either in this set or in the
//    /// given set, but not in both.
//    ///
//    /// In the following example, the `eitherNeighborsOrEmployees` set is made up
//    /// of the elements of the `employees` and `neighbors` sets that are not in
//    /// both `employees` *and* `neighbors`. In particular, the names `"Bethany"`
//    /// and `"Eric"` do not appear in `eitherNeighborsOrEmployees`.
//    ///
//    ///     let employees: Set = ["Alicia", "Bethany", "Diana", "Eric"]
//    ///     let neighbors: Set = ["Bethany", "Eric", "Forlani"]
//    ///     let eitherNeighborsOrEmployees = employees.symmetricDifference(neighbors)
//    ///     print(eitherNeighborsOrEmployees)
//    ///     // Prints "["Diana", "Forlani", "Alicia"]"
//    ///
//    /// - Parameter other: A set of the same type as the current set.
//    /// - Returns: A new set.
//    public func symmetricDifference(_ other: MIDITrackImpl) -> MIDITrackImpl {
////        return type(of: self).init(content: content.symmetricDifference(other.content))
//        fatalError()
//    }
//    
//    /// Returns a new set with the elements that are common to both this set and
//    /// the given set.
//    ///
//    /// In the following example, the `bothNeighborsAndEmployees` set is    made up
//    /// of the elements that are in *both* the `employees` and `neighbors` sets.
//    /// Elements that are in either one or the other, but not both, are left out
//    /// of the result of the intersection.
//    ///
//    ///     let employees: Set = ["Alicia", "Bethany", "Chris", "Diana", "Eric"]
//    ///     let neighbors: Set = ["Bethany", "Eric", "Forlani", "Greta"]
//    ///     let bothNeighborsAndEmployees = employees.intersection(neighbors)
//    ///     print(bothNeighborsAndEmployees)
//    ///     // Prints "["Bethany", "Eric"]"
//    ///
//    /// - Parameter other: A set of the same type as the current set.
//    /// - Returns: A new set.
//    ///
//    /// - Note: if this set and `other` contain elements that are equal but
//    ///   distinguishable (e.g. via `===`), which of these elements is present
//    ///   in the result is unspecified.
//    public func intersection(_ other: MIDITrackImpl) -> Self {
////        return type(of: self).init(content: content.intersection(other.content))
//        fatalError()
//    }
//    
//    /// Returns a new set with the elements of both this and the given set.
//    ///
//    /// In the following example, the `attendeesAndVisitors` set is made up
//    /// of the elements of the `attendees` and `visitors` sets:
//    ///
//    ///     let attendees: Set = ["Alicia", "Bethany", "Diana"]
//    ///     let visitors = ["Marcia", "Nathaniel"]
//    ///     let attendeesAndVisitors = attendees.union(visitors)
//    ///     print(attendeesAndVisitors)
//    ///     // Prints "["Diana", "Nathaniel", "Bethany", "Alicia", "Marcia"]"
//    ///
//    /// If the set already contains one or more elements that are also in
//    /// `other`, the existing members are kept.
//    ///
//    ///     let initialIndices = Set(0..<5)
//    ///     let expandedIndices = initialIndices.union([2, 3, 6, 7])
//    ///     print(expandedIndices)
//    ///     // Prints "[2, 4, 6, 7, 0, 1, 3]"
//    ///
//    /// - Parameter other: A set of the same type as the current set.
//    /// - Returns: A new set with the unique elements of this set and `other`.
//    ///
//    /// - Note: if this set and `other` contain elements that are equal but
//    ///   distinguishable (e.g. via `===`), which of these elements is present
//    ///   in the result is unspecified.
//    public func union(_ other: MIDITrackImpl) -> MIDITrackImpl {
////        return type(of: self).init(content: content.union(other.content))
//        fatalError()
//    }
//    
//    public func contains(_ member: Element) -> Bool {
////        return content.contains(member)
//        fatalError()
//    }
//}

