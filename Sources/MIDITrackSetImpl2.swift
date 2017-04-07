////
////  MIDITrackSetImpl2.swift
////  KoreMIDI
////
////  Created by Adam Nemecek on 4/7/17.
////
////
//
//import Foundation
//
////
////  SetLike.swift
////  MIDIDB
////
////  Created by Adam Nemecek on 3/10/17.
////  Copyright © 2017 Adam Nemecek. All rights reserved.
////
//
//import Foundation
//
//public class SetLike<Element: Hashable> : Hashable, Collection, ExpressibleByArrayLiteral, CustomStringConvertible {
//    public typealias Index = Set<Element>.Index
//    
//    public required init() {
//        content = []
//    }
//    
//    final internal var content: Set<Element> {
//        didSet {
//            didChange()
//        }
//    }
//    
//    public required init<S : Sequence>(content: S) where S.Iterator.Element == Element {
//        self.content = Set(content)
//    }
//    
//    public var description: String {
//        return content.description
//    }
//    
//    public static func ==(lhs: SetLike, rhs: SetLike) -> Bool {
//        return lhs.content == rhs.content
//    }
//    
//    public required init(arrayLiteral literal: Element...) {
//        content = Set(literal)
//    }
//    
//    public var hashValue: Int {
//        return content.hashValue
//    }
//    
//    internal func didChange() {
//        
//    }
//    
//    public final var startIndex: Index {
//        return content.startIndex
//    }
//    
//    public final var endIndex: Index {
//        return content.endIndex
//    }
//    
//    public final subscript(index: Index) -> Element {
//        return content[index]
//    }
//    
//    public final func index(after i: Index) -> Index {
//        return content.index(after: i)
//    }
//}
//
//extension SetLike : SetAlgebra {
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
//    public final func formSymmetricDifference(_ other: SetLike) {
//        content.formSymmetricDifference(other.content)
//    }
//    
//    public final var isEmpty: Bool {
//        return content.isEmpty
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
//    public final func formIntersection(_ other: SetLike) {
//        content.formIntersection(other.content)
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
//    public final func formUnion(_ other: SetLike) {
//        content.formUnion(other.content)
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
//        return content.update(with: newMember)
//    }
//    
//    public final func subtracting(_ other: SetLike) -> Self {
//        return type(of: self).init(content: content.subtracting(other.content))
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
//    public final func remove(_ member: Element) -> Element? {
//        return content.remove(member)
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
//    public final func insert(_ newMember: Element) -> (inserted: Bool, memberAfterInsert: Element) {
//        return content.insert(newMember)
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
//    public final func symmetricDifference(_ other: SetLike) -> Self {
//        return type(of: self).init(content: content.symmetricDifference(other.content))
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
//    public final func intersection(_ other: SetLike) -> Self {
//        return type(of: self).init(content: content.intersection(other.content))
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
//    public final func union(_ other: SetLike) -> Self {
//        return type(of: self).init(content: content.union(other.content))
//    }
//    
//    public final func contains(_ member: Element) -> Bool {
//        return content.contains(member)
//    }
//}
