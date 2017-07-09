//
//  TJRegexToken.swift
//  TJRegexTests
//
//  Created by Tjienta Vara on 2017-06-21.
//

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
enum TJRegexToken: Equatable, TJInfixToken, TJPostfixToken {
    case CG(TJCharacterRange)
    case R(Int, Int?)
    case SG(Int)
    case EG
    case O
    case J

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

