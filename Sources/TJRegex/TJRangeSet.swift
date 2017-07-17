//
//  TJRangeSet.swift
//  TJRegexTests
//
//  Created by Tjienta Vara on 2017-07-10.
//

import Foundation

struct TJRangeSet<T: Comparable>: Sequence {
    var elements: [TJRange<T>] = []

    var count: Int {
        return elements.count
    }

    init(full: Bool=false) {
        if full {
            elements.append(TJRange())
        }
    }

    init(_ elementRanges: [ClosedRange<T>], inverted: Bool=false) {
        self.init(full: inverted)

        if inverted {
            for elementRange in elementRanges {
                remove(elementRange)
            }
        } else {
            for elementRange in elementRanges {
                insert(elementRange)
            }
        }
    }

    init(_ elements: [T], _ elementRanges: [ClosedRange<T>] = [], inverted: Bool=false) {
        self.init(elementRanges + elements.map { $0 ... $0 }, inverted: inverted)
    }

    mutating func remove(_ element: TJRange<T>) {
        var i = 0
        while i < elements.count {
            let replacementElements = elements[i] - element

            elements.replaceSubrange(i ..< i + 1, with: replacementElements)

            // The new index is based on how many have been replaced, this could even
            // be zero elements, in that case all later elements have been moved to the current index.
            i += replacementElements.count
        }
    }

    mutating func remove(_ element: ClosedRange<T>) {
        remove(TJRange(element))
    }

    mutating func insert(_ element: TJRange<T>) {
        remove(element)
        elements.append(element)
    }

    mutating func insert(_ element: ClosedRange<T>) {
        insert(TJRange(element))
    }

    func makeIterator() -> IndexingIterator<[TJRange<T>]> {
        return elements.makeIterator()
    }

    static func ~~(lhs: T, rhs: TJRangeSet) -> Bool {
        for element in rhs.elements {
            if lhs ~~ element {
                return true
            }
        }
        return false
    }
}
