//
//  TJInfixToPostfix.swift
//  TJRegexTests
//
//  Created by Tjienta Vara on 2017-06-29.
//

import Foundation

func TJInfixToPostfix<T: TJInfixToken, S: Sequence>(_ infix: S) throws -> [T] where S.Element == T {
    // Only .Operator and .LeftBrackets will be in the stack.
    var stack: [T] = []
    var postfix: [T] = []

    for token in infix {
        switch (token.infixTokenType) {
            case .Operand:
                postfix.append(token)

            case .Operator(let tokenPrecedence):
                // Send operators from the stack to the output, stop when:
                // - End of stack is reached.
                // - Until a left bracket is found.
                // - Until a operator of lower precedence is found.
                while let last = stack.last, case .Operator(let lastPrecedence) = last.infixTokenType, lastPrecedence >= tokenPrecedence {
                    postfix.append(stack.removeLast())
                }
                stack.append(token)

            case .LeftBracket:
                stack.append(token)

            case .RightBracket:
                // Send operators from the stack to the output, stop when:
                // - End of stack is reached.
                // - Until a left bracket is found.
                while let last = stack.last, last.infixTokenType != .LeftBracket {
                    postfix.append(stack.removeLast())
                }

                guard !stack.isEmpty else {
                    throw TJInfixError.MissingLeftBracket
                }

                // We want the left bracket token in case special processing for the token is required downstream.
                postfix.append(stack.removeLast())
        }
    }

    // Send all operators from the stack to the output, stop when:
    // - End of stack is reached.
    // - Until a left bracket is found.
    while let last = stack.last, last.infixTokenType != .LeftBracket {
        postfix.append(stack.removeLast())
    }

    guard stack.isEmpty else {
        throw TJInfixError.MissingRightBracket
    }

    return postfix
}

