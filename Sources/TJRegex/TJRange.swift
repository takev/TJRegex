//
//  TJCharacterRange.swift
//  TJRegexTests
//
//  Created by Tjienta Vara on 2017-07-05.
//

import Foundation

infix operator <~: ComparisonPrecedence
infix operator <=~: ComparisonPrecedence
infix operator ~>: ComparisonPrecedence
infix operator ~>=: ComparisonPrecedence
infix operator ~~: ComparisonPrecedence
infix operator <>: ComparisonPrecedence
infix operator <=>: ComparisonPrecedence
infix operator ><: ComparisonPrecedence

enum TJBoundType<T: Comparable> {
    case Min
    case OpenLow(T)
    case Closed(T)
    case OpenHigh(T)
    case Max

    static func compare(_ lhs: TJBoundType, _ rhs: TJBoundType) -> Int {
        switch (lhs, rhs) {
            case     (.Min,          .Min):                         return  0
            case     (.Min,          _):                            return -1
            case     (_,             .Min):                         return  1
            case     (.Max,          .Max):                         return  0
            case     (.Max,          _):                            return  1
            case     (_,             .Max):                         return -1

            case let (.OpenLow(v1),  .OpenLow(v2))  where v1 <  v2: return -1
            case let (.OpenLow(v1),  .OpenLow(v2))  where v1 == v2: return  0
            case let (.OpenLow(v1),  .OpenLow(v2))  where v1 >  v2: return  1

            case let (.OpenLow(v1),  .Closed(v2))   where v1 <= v2: return -1
            case let (.OpenLow(v1),  .Closed(v2))   where v1 >  v2: return  1

            case let (.OpenLow(v1),  .OpenHigh(v2)) where v1 <= v2: return -1
            case let (.OpenLow(v1),  .OpenHigh(v2)) where v1 >  v2: return  1

            case let (.Closed(v1),   .OpenLow(v2))  where v1 <  v2: return -1
            case let (.Closed(v1),   .OpenLow(v2))  where v1 >= v2: return  1

            case let (.Closed(v1),   .Closed(v2))   where v1 <  v2: return -1
            case let (.Closed(v1),   .Closed(v2))   where v1 == v2: return  0
            case let (.Closed(v1),   .Closed(v2))   where v1 >  v2: return  1

            case let (.Closed(v1),   .OpenHigh(v2)) where v1 <= v2: return -1
            case let (.Closed(v1),   .OpenHigh(v2)) where v1 >  v2: return  1

            case let (.OpenHigh(v1), .OpenLow(v2))  where v1 <  v2: return -1
            case let (.OpenHigh(v1), .OpenLow(v2))  where v1 >= v2: return  1

            case let (.OpenHigh(v1), .Closed(v2))   where v1 <  v2: return -1
            case let (.OpenHigh(v1), .Closed(v2))   where v1 >= v2: return  1

            case let (.OpenHigh(v1), .OpenHigh(v2)) where v1 <  v2: return -1
            case let (.OpenHigh(v1), .OpenHigh(v2)) where v1 == v2: return  0
            case let (.OpenHigh(v1), .OpenHigh(v2)) where v1 >  v2: return  1
            default:                                                preconditionFailure("Unreachable")
        }
    }

    static func compare(_ lhs: T, _ rhs: TJBoundType) -> Int {
        return compare(.Closed(lhs), rhs)
    }

    static func compare(_ lhs: TJBoundType, _ rhs: T) -> Int {
        return compare(lhs, .Closed(rhs))
    }

    static func ==(lhs: TJBoundType, rhs: TJBoundType) -> Bool {
        return compare(lhs, rhs) == 0
    }

    static func !=(lhs: TJBoundType, rhs: TJBoundType) -> Bool {
        return compare(lhs, rhs) != 0
    }

    static func >(lhs: TJBoundType, rhs: TJBoundType) -> Bool {
        return compare(lhs, rhs) > 0
    }

    static func <(lhs: TJBoundType, rhs: TJBoundType) -> Bool {
        return compare(lhs, rhs) < 0
    }

    static func >=(lhs: TJBoundType, rhs: TJBoundType) -> Bool {
        return compare(lhs, rhs) >= 0
    }

    static func <=(lhs: TJBoundType, rhs: TJBoundType) -> Bool {
        return compare(lhs, rhs) <= 0
    }

    static func ==(lhs: T, rhs: TJBoundType) -> Bool {
        return compare(lhs, rhs) == 0
    }

    static func !=(lhs: T, rhs: TJBoundType) -> Bool {
        return compare(lhs, rhs) != 0
    }

    static func >(lhs: T, rhs: TJBoundType) -> Bool {
        return compare(lhs, rhs) > 0
    }

    static func <(lhs: T, rhs: TJBoundType) -> Bool {
        return compare(lhs, rhs) < 0
    }

    static func >=(lhs: T, rhs: TJBoundType) -> Bool {
        return compare(lhs, rhs) >= 0
    }

    static func <=(lhs: T, rhs: TJBoundType) -> Bool {
        return compare(lhs, rhs) <= 0
    }

    static func ==(lhs: TJBoundType, rhs: T) -> Bool {
        return compare(lhs, rhs) == 0
    }

    static func !=(lhs: TJBoundType, rhs: T) -> Bool {
        return compare(lhs, rhs) != 0
    }

    static func >(lhs: TJBoundType, rhs: T) -> Bool {
        return compare(lhs, rhs) > 0
    }

    static func <(lhs: TJBoundType, rhs: T) -> Bool {
        return compare(lhs, rhs) < 0
    }

    static func >=(lhs: TJBoundType, rhs: T) -> Bool {
        return compare(lhs, rhs) >= 0
    }

    static func <=(lhs: TJBoundType, rhs: T) -> Bool {
        return compare(lhs, rhs) <= 0
    }


}

struct TJRange<T: Comparable> {
    let lowerBound: TJBoundType<T>
    let upperBound: TJBoundType<T>

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

    static func ~~(lhs: TJRange, rhs: TJRange) -> Bool {
        return lhs.lowerBound >= rhs.lowerBound && lhs.upperBound <= rhs.upperBound
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

        } else if rhs >< lhs {
            // Not overlapping.
            return [rhs]

        } else if lhs ~>= rhs {
            // Overlapping on the lower bound, rhs becomes shorter.
            switch (lhs.lowerBound) {
                case .Min:          return [TJRange(rhs.lowerBound, .Min)]
                case .OpenLow(v):   return [TJRange(rhs.lowerBound, .OpenLow(v))]
                case .Closed(v):    return [TJRange(rhs.lowerBound, .OpenLow(v))]
                case .OpenHigh(v):  return [TJRange(rhs.lowerBound, .Closed(v))]
                case .Max:          return [TJRange(rhs.lowerBound, .Max)]
            }

        } else if lhs <=~ rhs {
            // Overlapping on the lower bound, rhs becomes shorter.
            switch (lhs.upperBound) {
                case .Min:          return [TJRange(.Min,           rhs.upperBound)]
                case .OpenLow(v):   return [TJRange(.Closed(v),     rhs.upperBound)]
                case .Closed(v):    return [TJRange(.OpenHigh(v),   rhs.upperBound)]
                case .OpenHigh(v):  return [TJRange(.OpenHigh(v),   rhs.upperBound)]
                case .Max:          return [TJRange(.Max,           rhs.upperBound)]
            }

        } else {
            // lhs is completely inside rhs without touching the edges.
            var ranges = Array<TJRange>()

            switch (lhs.lowerBound) {
                case .Min:          return ranges.append(TJRange(rhs.lowerBound, .Min))
                case .OpenLow(v):   return ranges.append(TJRange(rhs.lowerBound, .OpenLow(v)))
                case .Closed(v):    return ranges.append(TJRange(rhs.lowerBound, .OpenLow(v)))
                case .OpenHigh(v):  return ranges.append(TJRange(rhs.lowerBound, .Closed(v)))
                case .Max:          return ranges.append(TJRange(rhs.lowerBound, .Max))
            }

            switch (lhs.upperBound) {
                case .Min:          return ranges.append(TJRange(.Min,           rhs.upperBound))
                case .OpenLow(v):   return ranges.append(TJRange(.Closed(v),     rhs.upperBound))
                case .Closed(v):    return ranges.append(TJRange(.OpenHigh(v),   rhs.upperBound))
                case .OpenHigh(v):  return ranges.append(TJRange(.OpenHigh(v),   rhs.upperBound))
                case .Max:          return ranges.append(TJRange(.Max,           rhs.upperBound))
            }

            return ranges
        }
        return []
    }

}

