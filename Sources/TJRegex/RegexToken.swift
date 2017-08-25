// TJRegex - Regular Expression library based on the Swift String struct.
// Copyright (C) 2017  Tjienta Vara
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.

import TJBase

/** Tokens returned after parsing regex.
 * These tokens have short names for easier handling in code and tests.
 *
 * Here are the long translations of short token names:
 * - CR = CharacterRange
 * - R  = Repeat
 * - SG = StartGroup
 * - EG = EndGroup
 * - Or = Or
 * - J  = Join / Concatenation
 */
enum RegexToken: Equatable, TJInfixToken, TJPostfixToken, CustomStringConvertible {
    case CR(CharacterRange)
    case CRA([CharacterRange])
    case R(Int, Int?)
    case SG(Int)
    case EG
    case O
    case J

    var description: String {
        switch self {
            case let .CR(v):                            return "[\(v)]"
            case let .CRA(v):
                if (v.count == 1 && v[0].description.count == 1) {
                    return v[0].description
                } else {
                    return "[" + v.map{$0.description}.reduce(""){$0 + $1} + "]"
                }
            case let .R(v, w) where v == 0 && w == nil: return "*"
            case let .R(v, w) where v == 1 && w == nil: return "+"
            case let .R(v, w) where v == 0 && w == 1:   return "?"
            case let .R(v, w) where w == nil:           return "{\(v),∞}"
            case let .R(v, w) where v == w!:            return "{\(v)}"
            case let .R(v, w):                          return "{\(v),\(w!)}"
            case let .SG(v)   where v < 0:              return "("
            case let .SG(v):                            return "(\(v):"
            case     .EG:                               return ")"
            case     .O:                                return "|"
            case     .J:                                return "."
        }
    }

    static func CharacterGroup(_ elements: [Character], _ ranges: [ClosedRange<Character>] = []) -> RegexToken {
        let closedRanges = elements.map { $0 ... $0 } + ranges
        let universalRanges = closedRanges.map { UniversalRange($0) }
        return .CRA(nonOverlappingMerge(universalRanges))
    }

    static func CharacterGroup(_ ranges: [ClosedRange<Character>]) -> RegexToken {
        return CharacterGroup([], ranges)
    }

    static func CharacterGroup(_ character: Character) -> RegexToken {
        return CharacterGroup([character])
    }

    static func InvertedCharacterGroup(_ elements: [Character], _ ranges: [ClosedRange<Character>] = []) -> RegexToken {
        let closedRanges = elements.map { $0 ... $0 } + ranges
        let universalRanges = closedRanges.map { UniversalRange($0) }
        return .CRA(invertedNonOverlappingMerge(universalRanges))
    }

    static func InvertedCharacterGroup(_ ranges: [ClosedRange<Character>]) -> RegexToken {
        return InvertedCharacterGroup([], ranges)
    }

    static func InvertedCharacterGroup() -> RegexToken {
        return InvertedCharacterGroup([], [])
    }

    static func C() -> RegexToken {
        return .CRA([CharacterRange()])
    }

    static func C(_ character: Character) -> RegexToken {
        return .CRA([CharacterRange(character)])
    }

    static func C(_ characterRange: Range<Character>) -> RegexToken {
        return .CRA([CharacterRange(characterRange)])
    }

    static func C(_ characterRange: ClosedRange<Character>) -> RegexToken {
        return .CRA([CharacterRange(characterRange)])
    }

    static func C(_ characterRange: PartialRangeUpTo<Character>) -> RegexToken {
        return .CRA([CharacterRange(characterRange)])
    }

    static func C(leftOpen characterRange: PartialRangeFrom<Character>) -> RegexToken {
        return .CRA([CharacterRange(leftOpen: characterRange)])
    }

    static func C(leftOpen characterRange: Range<Character>) -> RegexToken {
        return .CRA([CharacterRange(leftOpen: characterRange)])
    }

    var infixTokenType: TJInfixTokenType {
        switch self {
            case .CR: preconditionFailure("CharacterRange should not be part of a infix sequence.")
            case .CRA: return .Operand
            case .SG: return .LeftBracket
            case .EG: return .RightBracket
            case .R: return .Operator(2)
            case .J: return .Operator(1)
            case .O: return .Operator(0)
        }
    }

    var postfixNumberOfOperands: Int {
        switch self {
            case .CR: return 0
            case .CRA: preconditionFailure("CharacterRange Array should not be part of a postfix sequence.")
            case .SG: return 1
            case .EG: preconditionFailure("End-group should not be part of a postfix sequence.")
            case .R: return 1
            case .J: return 2
            case .O: return 2
        }
    }
}

func ==(lhs: RegexToken, rhs: RegexToken) -> Bool {
    switch (lhs, rhs) {
        case let (.CR(lhsCrs), .CR(rhsCrs))
            where lhsCrs == rhsCrs:
                return true
        case let (.CRA(lhsCrs), .CRA(rhsCrs))
            where lhsCrs == rhsCrs:
                return true
        case let (.R(lhsStart, lhsEnd), .R(rhsStart, rhsEnd))
            where lhsStart == rhsStart && lhsEnd == rhsEnd:
                return true
        case let (.SG(lhsI), .SG(rhsI))
            where lhsI == rhsI:
                return true
        case (.EG, .EG): return true
        case (.O, .O): return true
        case (.J,  .J):  return true
        default:         return false
    }
}

extension Array where Element == RegexToken {
    var description: String {
        get {
            return self.reduce("") { $0 + $1.description }
        }
    }
}

