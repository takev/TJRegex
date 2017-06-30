//
//  TJRegexTree.swift
//  TJRegexTests
//
//  Created by Tjienta Vara on 2017-06-24.
//

import Foundation

indirect enum TJRegexAST {
    case A(Character)
    case C(Character)
    case CG([Character], [ClosedRange<Character>], inverse: Bool)
    case R(Int, Int?, TJRegexAST)
    case G(Int, TJRegexAST)
    case O([TJRegexAST])
    case J([TJRegexAST])
}
