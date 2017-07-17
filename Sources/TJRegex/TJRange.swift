//
//  TJCharacterRange.swift
//  TJRegexTests
//
//  Created by Tjienta Vara on 2017-07-05.
//

import Foundation

struct TJRange<T: Comparable>: CustomStringConvertible {
    let lowerBound: TJBoundType<T>
    let upperBound: TJBoundType<T>

 var description : String {
        switch (lowerBound, upperBound) {
            case let (.Min, .OpenLow(v2)):                      return "∞ ..< \(v2)"
            case let (.Min, .Closed(v2)):                       return "∞ ... \(v2)"
            case     (.Min, .Max):                              return "∞ ... ∞"
            case let (.Closed(v1), .OpenLow(v2)):               return "\(v1) ..< \(v2)"
            case let (.Closed(v1), .Closed(v2)) where v1 == v2: return "\(v1)"
            case let (.Closed(v1), .Closed(v2)):                return "\(v1) ... \(v2)"
            case let (.Closed(v1), .Max):                       return "\(v1) ... ∞"
            case let (.OpenHigh(v1), .OpenLow(v2)):             return "\(v1) <.< \(v2)"
            case let (.OpenHigh(v1), .Closed(v2)):              return "\(v1) <.. \(v2)"
            case let (.OpenHigh(v1), .Max):                     return "\(v1) <.. ∞"
            default: preconditionFailure("lowerBound, upperBound types combination is not allowed.")
        }
    }

    init(_ lowerBound: TJBoundType<T>, _ upperBound: TJBoundType<T>) {
        switch lowerBound {
            case .Min, .Closed, .OpenHigh: break
            default: assertionFailure("lowerBound must be .Min, .Closed or .OpenHigh")
        }

        switch upperBound {
            case .Max, .Closed, .OpenLow: break
            default: assertionFailure("upperBound must be .Max, .Closed or .OpenLow")
        }
        assert(lowerBound <= upperBound, "upperBound must be greater or equal to lowerBound")

        self.lowerBound = lowerBound
        self.upperBound = upperBound
    }

    init() {
        self.init(.Min, .Max)
    }

    init(_ value: T) {
        self.init(.Closed(value), .Closed(value))
    }

    init(_ range: ClosedRange<T>) {
        self.init(.Closed(range.lowerBound), .Closed(range.upperBound))
    }

    init(_ range: Range<T>) {
        self.init(.Closed(range.lowerBound), .OpenLow(range.upperBound))
    }

    init(_ range: PartialRangeFrom<T>) {
        self.init(.Closed(range.lowerBound), .Max)
    }

    init(_ range: PartialRangeUpTo<T>) {
        self.init(.Min, .OpenLow(range.upperBound))
    }

    static func ~~(lhs: T, rhs: TJRange) -> Bool {
        return lhs >= rhs.lowerBound && lhs <= rhs.upperBound
    }

    static func ~~(lhs: TJBoundType<T>, rhs: TJRange) -> Bool {
        return lhs >= rhs.lowerBound && lhs <= rhs.upperBound
    }

    static func ><(lhs: T, rhs: TJRange) -> Bool {
        return lhs < rhs.lowerBound || lhs > rhs.upperBound
    }

    static func <<(lhs: T, rhs: TJRange) -> Bool {
        return lhs < rhs.lowerBound
    }

    static func >>(lhs: T, rhs: TJRange) -> Bool {
        return lhs > rhs.upperBound
    }

    static func <<(lhs: TJRange, rhs: TJRange) -> Bool {
        return lhs.upperBound < rhs.lowerBound
    }

    static func >>(lhs: TJRange, rhs: TJRange) -> Bool {
        return lhs.lowerBound > rhs.upperBound
    }

    static func ==(lhs: TJRange, rhs: TJRange) -> Bool {
        return lhs.lowerBound == rhs.lowerBound && lhs.upperBound == rhs.upperBound
    }

    static func ~~(lhs: TJRange, rhs: TJRange) -> Bool {
        return lhs.lowerBound >= rhs.lowerBound && lhs.upperBound <= rhs.upperBound
    }

    static func ><(lhs: TJRange, rhs: TJRange) -> Bool {
        return lhs.upperBound < rhs.lowerBound || lhs.lowerBound > rhs.upperBound
    }

    static func <>(lhs: TJRange, rhs: TJRange) -> Bool {
        return lhs.lowerBound < rhs.lowerBound && lhs.upperBound > rhs.upperBound
    }

    static func <=>(lhs: TJRange, rhs: TJRange) -> Bool {
        return lhs.lowerBound <= rhs.lowerBound && lhs.upperBound >= rhs.upperBound
    }

    static func <~(lhs: TJRange, rhs: TJRange) -> Bool {
        return lhs.lowerBound < rhs.lowerBound && lhs.upperBound ~~ rhs
    }

    static func <=~(lhs: TJRange, rhs: TJRange) -> Bool {
        return lhs.lowerBound <= rhs.lowerBound && lhs.upperBound ~~ rhs
    }

    static func ~>(lhs: TJRange, rhs: TJRange) -> Bool {
        return lhs.lowerBound ~~ rhs && lhs.upperBound > rhs.upperBound
    }

    static func ~>=(lhs: TJRange, rhs: TJRange) -> Bool {
        return lhs.lowerBound ~~ rhs && lhs.upperBound >= rhs.upperBound
    }

    static func -(lhs: TJRange, rhs: TJRange) -> [TJRange] {
        if lhs <=> rhs {
            // Fully overlapping means the rhs dissapears.
            return []

        } else if lhs >< rhs {
            // Not overlapping.
            return [lhs]

        } else if lhs ~>= rhs {
            // Overlapping on the lower bound, rhs becomes shorter.
            switch (lhs.lowerBound) {
                case     .Min:          return [TJRange(rhs.lowerBound, .Min)]
                case let .OpenLow(v):   return [TJRange(rhs.lowerBound, .OpenLow(v))]
                case let .Closed(v):    return [TJRange(rhs.lowerBound, .OpenLow(v))]
                case let .OpenHigh(v):  return [TJRange(rhs.lowerBound, .Closed(v))]
                case     .Max:          return [TJRange(rhs.lowerBound, .Max)]
            }

        } else if lhs <=~ rhs {
            // Overlapping on the lower bound, rhs becomes shorter.
            switch (lhs.upperBound) {
                case     .Min:          return [TJRange(.Min,           rhs.upperBound)]
                case let .OpenLow(v):   return [TJRange(.Closed(v),     rhs.upperBound)]
                case let .Closed(v):    return [TJRange(.OpenHigh(v),   rhs.upperBound)]
                case let .OpenHigh(v):  return [TJRange(.OpenHigh(v),   rhs.upperBound)]
                case     .Max:          return [TJRange(.Max,           rhs.upperBound)]
            }

        } else {
            // lhs is completely inside rhs without touching the edges.
            var ranges : [TJRange<T>] = []

            switch (lhs.lowerBound) {
                case     .Min:          ranges.append(TJRange(rhs.lowerBound, .Min))
                case let .OpenLow(v):   ranges.append(TJRange(rhs.lowerBound, .OpenLow(v)))
                case let .Closed(v):    ranges.append(TJRange(rhs.lowerBound, .OpenLow(v)))
                case let .OpenHigh(v):  ranges.append(TJRange(rhs.lowerBound, .Closed(v)))
                case     .Max:          ranges.append(TJRange(rhs.lowerBound, .Max))
            }

            switch (lhs.upperBound) {
                case     .Min:          ranges.append(TJRange(.Min,           rhs.upperBound))
                case let .OpenLow(v):   ranges.append(TJRange(.Closed(v),     rhs.upperBound))
                case let .Closed(v):    ranges.append(TJRange(.OpenHigh(v),   rhs.upperBound))
                case let .OpenHigh(v):  ranges.append(TJRange(.OpenHigh(v),   rhs.upperBound))
                case     .Max:          ranges.append(TJRange(.Max,           rhs.upperBound))
            }

            return ranges
        }
    }

    static func -(lhs: TJRange, rhs: ClosedRange<T>) -> [TJRange] {
        return lhs - TJRange(rhs)
    }
}

