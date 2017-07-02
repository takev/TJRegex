//
//  TJPostfixToAST.swift
//  TJRegexTests
//
//  Created by Tjienta Vara on 2017-06-30.
//

import Foundation

func TJPostfixToAST<T: TJPostfixToken, S: Sequence>(_ postfix: S) throws -> TJAST<T> where S.Element == T {
    var stack: [TJAST<T>] = []

    for token in postfix {
        let numberOfOperants = token.postfixNumberOfOperands
        guard stack.count >= numberOfOperants else {
            throw TJPostfixError.NotEnoughOperants
        }

        let children = stack[stack.count - numberOfOperants ..< stack.count]
        stack.removeLast(numberOfOperants)

        let node = TJAST(token, children)
        stack.append(node)
    }

    guard stack.count == 1 else {
        throw TJPostfixError.OperandsLeftOnStack
    }
    return stack.last!
}
