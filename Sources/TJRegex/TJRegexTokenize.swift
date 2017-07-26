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

import TJBase

func TJRegexParseRepeat(_ pattern: String, index: inout String.Index) throws -> TJRegexToken {
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

func TJRegexParseCharacterGroup(_ pattern: String, index: inout String.Index) throws -> [ClosedRange<Character>] {
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
                    return characterRanges
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
                    nextIndex = pattern.index(index, offsetBy:2)
                }

            default:
                characterRanges.append(c ... c)
        }
        canBeEndBracket = false
        index = nextIndex
    }
    throw TJRegexParseError.UnfinishedCharacterGroup
}

/// Example
/// "x[a-cM-Z]x"
/// "x([a-c]|[M-Z])x"
func TJTokenizeCharacterGroup(_ characterRanges: TJRangeSet<Character>) -> [TJRegexToken] {
    var tokens: [TJRegexToken] = []

    if characterRanges.count > 1 {
        tokens.append(.SG(-1))
    }

    for characterRange in characterRanges {
        tokens.append(.CG(characterRange))
        tokens.append(.O)
    }
    _ = tokens.popLast()

    if characterRanges.count > 1 {
        tokens.append(.EG)
    }

    return tokens
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
            case ".":   tokens.append(.C())
            case "^":   throw TJRegexParseError.UnsupportedAchor
            case "$":   throw TJRegexParseError.UnsupportedAchor
            case "(":   tokens.append(.SG(groupNumber)); groupNumber += 1
            case ")":   tokens.append(.EG)
            case "|":   tokens.append(.O)
            case "?":   tokens.append(.R(0, 1))
            case "*":   tokens.append(.R(0, nil))
            case "+":   tokens.append(.R(1, nil))
            case "{":   tokens.append(try TJRegexParseRepeat(pattern, index:&nextIndex))

            case "[":
                if nextIndex < pattern.endIndex && pattern[nextIndex] == "^" {
                    nextIndex = pattern.index(nextIndex, offsetBy:1)
                    let characterGroups = try TJRegexParseCharacterGroup(pattern, index:&nextIndex)
                    tokens += TJTokenizeCharacterGroup(TJRangeSet(characterGroups, inverted: true))
                } else {
                    let characterGroups = try TJRegexParseCharacterGroup(pattern, index:&nextIndex)
                    tokens += TJTokenizeCharacterGroup(TJRangeSet(characterGroups))
                }

            case "\\":
                guard nextIndex < pattern.endIndex else {
                    throw TJRegexParseError.UnfinishedEscape
                }

                let nextCharacter = pattern[nextIndex]
                switch (nextCharacter) {
                    case "w":
                        tokens += TJTokenizeCharacterGroup(TJRangeSet(["_"], ["a" ... "z", "A" ... "Z", "0" ... "9"]))
                    case "W":
                        tokens += TJTokenizeCharacterGroup(TJRangeSet(["_"], ["a" ... "z", "A" ... "Z", "0" ... "9"], inverted: true))
                    case "s":
                        tokens += TJTokenizeCharacterGroup(TJRangeSet([" ", "\t", "\r", "\n", "\u{c}"]))
                    case "S":
                        tokens += TJTokenizeCharacterGroup(TJRangeSet([" ", "\t", "\r", "\n", "\u{c}"], inverted: true))
                    case "d":
                        tokens += TJTokenizeCharacterGroup(TJRangeSet(["0" ... "9"]))
                    case "D":
                        tokens += TJTokenizeCharacterGroup(TJRangeSet(["0" ... "9"], inverted: true))
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


