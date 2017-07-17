//
//  TJBoundType.swift
//  TJRegexTests
//
//  Created by Tjienta Vara on 2017-07-10.
//

import Foundation

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

