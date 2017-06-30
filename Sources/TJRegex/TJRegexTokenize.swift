//
//  TJRegexParse.swift
//  TJRegexTests
//
//  Created by Tjienta Vara on 2017-06-19.
//

import Foundation

func TJRegexTokenizeRepeat(_ pattern: String, index: inout String.Index) throws -> TJRegexToken {
    var optionalStartValue: Int? = nil
    var value = 0

    while index < pattern.endIndex {
        let c = pattern[index]
        switch (c) {
            case "}":
                index = pattern.index(index, offsetBy:1)
                if let startValue = optionalStartValue {
                    guard startValue <= value else {
                        throw TJRegexParseError.ReverseOrderRepeatGroup(index, startValue, value)
                    }
                    return .R(startValue, value)
                } else {
                    return .R(value, value)
                }

            case ",":
                optionalStartValue = value
                value = 0

            case "0":   value *= 10
            case "1":   value *= 10; value += 1
            case "2":   value *= 10; value += 2
            case "3":   value *= 10; value += 3
            case "4":   value *= 10; value += 4
            case "5":   value *= 10; value += 5
            case "6":   value *= 10; value += 6
            case "7":   value *= 10; value += 7
            case "8":   value *= 10; value += 8
            case "9":   value *= 10; value += 9
            default:
                throw TJRegexParseError.BadCharacterInRepeatGroup(index, c)
        }

        index = pattern.index(index, offsetBy:1)
    }
    throw TJRegexParseError.UnfinishedRepeatGroup
}

func TJRegexTokenizeCharacterGroup(_ pattern: String, index: inout String.Index, inverse: Bool) throws -> TJRegexToken {
    var canBeEndBracket = true
    var characterRanges: [ClosedRange<Character>] = []

    while index < pattern.endIndex {
        var nextIndex = pattern.index(index, offsetBy:1)

        let c = pattern[index]
        switch (c) {
            case "]":
                if canBeEndBracket {
                    // The first character may be a close-bracket, the close bracket in this case is
                    // a character to match with; not the end of a character group.
                    characterRanges.append("]" ... "]")
                } else {
                    // Found end of character group.
                    index = nextIndex
                    return .CG(characterRanges, inverse:inverse)
                }

            case "-":
                guard nextIndex < pattern.endIndex else {
                    throw TJRegexParseError.UnfinishedCharacterGroup
                }

                let nextCharacter = pattern[nextIndex]
                if nextCharacter == "]" || characterRanges.count == 0 {
                    characterRanges.append(c ... c)
                } else {
                    let characterHalfRange = characterRanges.removeLast()

                    characterRanges.append(characterHalfRange.lowerBound ... nextCharacter)
                    nextIndex = pattern.index(index, offsetBy:1)
                }

            default:
                characterRanges.append(c ... c)
        }
        canBeEndBracket = false
        index = nextIndex
    }
    throw TJRegexParseError.UnfinishedCharacterGroup
}

func TJRegexTokenize(_ pattern: String) throws -> [TJRegexToken] {
    var tokens: [TJRegexToken] = []
    var groupNumber = 0

    // At maximum every charracter in the pattern will be joined together.
    // And a implicit start-group and end-group will be added to.
    tokens.reserveCapacity(pattern.count * 2 + 2)

    // Start with an implicit start-group.
    tokens.append(.SG(groupNumber))
    groupNumber += 1

    var index = pattern.startIndex
    while index < pattern.endIndex {
        var nextIndex = pattern.index(index, offsetBy:1)
        let c = pattern[index]

        // Insert implicit join tokens.
        switch (c) {
            case ")", "|", "?", "*", "+", "{":
                break
            default:
                switch (tokens.last!) {
                case .CG, .EG, .R: tokens.append(.J)
                default: break
                }
        }

        switch (c) {
            case ".":   tokens.append(.CG([], inverse:true))
            case "^":   throw TJRegexParseError.UnsupportedAchor
            case "$":   throw TJRegexParseError.UnsupportedAchor
            case "(":   tokens.append(.SG(groupNumber)); groupNumber += 1
            case ")":   tokens.append(.EG)
            case "|":   tokens.append(.O)
            case "?":   tokens.append(.R(0, 1))
            case "*":   tokens.append(.R(0, nil))
            case "+":   tokens.append(.R(1, nil))
            case "{":   tokens.append(try TJRegexTokenizeRepeat(pattern, index:&nextIndex))

            case "[":
                if nextIndex < pattern.endIndex && pattern[nextIndex] == "^" {
                    nextIndex = pattern.index(nextIndex, offsetBy:1)
                    tokens.append(try TJRegexTokenizeCharacterGroup(pattern, index:&nextIndex, inverse:true))
                } else {
                    tokens.append(try TJRegexTokenizeCharacterGroup(pattern, index:&nextIndex, inverse:false))
                }

            case "\\":
                guard nextIndex < pattern.endIndex else {
                    throw TJRegexParseError.UnfinishedEscape
                }

                let nextCharacter = pattern[nextIndex]
                switch (nextCharacter) {
                    case "w":   tokens.append(.CG(["_" ... "_", "a" ... "z", "A" ... "Z", "0" ... "9"], inverse: false))
                    case "W":   tokens.append(.CG(["_" ... "_", "a" ... "z", "A" ... "Z", "0" ... "9"], inverse: true))
                    case "s":   tokens.append(.CG([" " ... " ", "\t" ... "\t", "\r" ... "\r", "\n" ... "\n", "\u{c}" ... "\u{c}"], inverse: false))
                    case "S":   tokens.append(.CG([" " ... " ", "\t" ... "\t", "\r" ... "\r", "\n" ... "\n", "\u{c}" ... "\u{c}"], inverse: true))
                    case "d":   tokens.append(.CG(["0" ... "9"], inverse: false))
                    case "D":   tokens.append(.CG(["0" ... "9"], inverse: true))
                    case ".", "^", "$", "(", ")", "|", "?", "*", "+", "{", "}", "[", "]", "\\":
                        tokens.append(.C(nextCharacter))

                    default:
                        throw TJRegexParseError.BadCharacterInEscape(nextIndex, nextCharacter)
                }

                // Advance the index beyond the next character.
                nextIndex = pattern.index(nextIndex, offsetBy:1)

            default:
                tokens.append(.C(c))
        }

        index = nextIndex
    }

    // End the implicit group around the whole regex.
    tokens.append(.EG)
    return tokens
}


