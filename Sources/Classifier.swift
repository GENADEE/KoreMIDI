//
//  Classifier.swift
//  KoreMIDI
//
//  Created by Adam Nemecek on 4/7/17.
//
//

import Foundation

struct Classifier<Element : Hashable, Prop: Hashable> : Collection {
    typealias Index = Dictionary<Prop, Set<Element>>.Index

    private var content: [Prop: Set<Element>]
    
    init<S : Sequence>(_ content: S, getter: (Element) -> Prop) where S.Iterator.Element == Element {
        self.content = [:]
        content.forEach {
            let prop = getter($0)
            self.content[prop] = (self.content[prop] ?? []).union([$0])
        }
    }
    
    var startIndex : Index {
        return content.startIndex
    }

    var endIndex : Index {
        return content.endIndex
    }
    
    subscript(index : Index) -> Set<Element>? {
        return content[index].value
    }


    func index(after i: Index) -> Index {
        fatalError()
    }
}
