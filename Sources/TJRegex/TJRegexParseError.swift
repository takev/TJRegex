//
//  TJRegexParseError.swift
//  TJRegexTests
//
//  Created by Tjienta Vara on 2017-06-21.
//

enum TJRegexParseError: Error {
    case ReverseOrderRepeatGroup(String.Index, Int, Int)
    case BadCharacterInRepeatGroup(String.Index, Character)
    case UnfinishedRepeatGroup
    case UnfinishedCharacterGroup
    case BadCharacterInEscape(String.Index, Character)
    case UnfinishedEscape
    case UnsupportedAchor
}

