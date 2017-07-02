//
//  TJRegexParse.swift
//  TJRegexTests
//
//  Created by Tjienta Vara on 2017-06-25.
//

import Foundation

func TJRegexParse(_ pattern: String) throws {
    let infixTokens = try TJRegexTokenize(pattern)
    let postfixTokens = try TJInfixToPostfix(infixTokens)
    let ast = try TJPostfixToAST(postfixTokens)
}
