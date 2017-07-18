// TJRegex - A Swift package for working with large integers.
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

/** Tokens returned after parsing regex.
 * These tokens have short names for easier handling in code and tests.
 *
 * Here are the long translations of short token names:
 * - CG = CharacterGroup
 * - R  = Repeat
 * - SG = StartGroup
 * - EG = EndGroup
 * - Or = Or
 * - J  = Join / Concatenation
 */
enum TJRegexToken: Equatable, TJInfixToken, TJPostfixToken, CustomStringConvertible {
    case CG(TJRange<Character>)
    case R(Int, Int?)
    case SG(Int)
    case EG
    case O
    case J

    var description: String {
        switch self {
            case let .CG(v):                            return "[\(v)]"
            case let .R(v, w) where v == 0 && w == nil: return "*"
            case let .R(v, w) where v == 1 && w == nil: return "+"
            case let .R(v, w) where v == 0 && w == 1:   return "?"
            case let .R(v, w) where w == nil:           return "{\(v)}"
            case let .R(v, w):                          return "{\(v), \(w!)}"
            case let .SG(v)   where v < 0:              return "("
            case let .SG(v):                            return "(\(v)"
            case     .EG:                               return ")"
            case     .O:                                return "|"
            case     .J:                                return "."
        }
    }

    static func C() -> TJRegexToken {
        return .CG(TJRange())
    }

    static func C(_ character: Character) -> TJRegexToken {
        return .CG(TJRange(character))
    }

    static func C(_ characterRange: ClosedRange<Character>) -> TJRegexToken {
        return .CG(TJRange(characterRange))
    }

    var infixTokenType: TJInfixTokenType {
        switch self {
            case .CG: return .Operand
            case .SG: return .LeftBracket
            case .EG: return .RightBracket
            case .R: return .Operator(2)
            case .J: return .Operator(1)
            case .O: return .Operator(0)
        }
    }

    var postfixNumberOfOperands: Int {
        switch self {
            case .CG: return 0
            case .SG: return 1
            case .EG: preconditionFailure("End-group should not be part of a postfix sequence.")
            case .R: return 1
            case .J: return 2
            case .O: return 2
        }
    }
}

func ==(lhs: TJRegexToken, rhs: TJRegexToken) -> Bool {
    switch (lhs, rhs) {
        case let (.CG(lhsCrs), .CG(rhsCrs))
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

