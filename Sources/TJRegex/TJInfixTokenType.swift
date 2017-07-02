//
//  TJInfixTokenType.swift
//  TJRegexTests
//
//  Created by Tjienta Vara on 2017-06-30.
//

import Foundation

enum TJInfixTokenType: Equatable {
    case Operand
    case Operator(Int)  // Argument: Presedence 
    case LeftBracket
    case RightBracket
}

func ==(lhs: TJInfixTokenType, rhs: TJInfixTokenType) -> Bool {
    switch (lhs, rhs) {
        case (.Operand, .Operand): return true
        case (.Operator(let lhsP), .Operator(let rhsP)) where lhsP == rhsP: return true
        case (.LeftBracket, .LeftBracket): return true
        case (.RightBracket, .RightBracket): return true
        default: return false
    }
}
