//
//  TJRegexNFA.swift
//  TJRegexTests
//
//  Created by Tjienta Vara on 2017-07-02.
//

import Foundation

enum TJRegexNFATransition {
    case Epsilon(TJRegexNFAState)
    case Input(TJRegexNFAState, TJRegexToken)
}

class TJRegexNFAState {
    var transitions: [TJRegexNFATransition] = []
    var startCaptureGroupID: Int?
    var endCaptureGroupID: Int?

    func addEpsilonTransition(_ nextState: TJRegexNFAState) {
        transitions.append(.Epsilon(nextState))
    }

    func addInputTransition(_ nextState: TJRegexNFAState, token: TJRegexToken) {
        // assert(case .CG = token, "The token passed must be a .C token.")
        transitions.append(.Input(nextState, token))
    }
}

struct TJRegexNFA {
    var startState: TJRegexNFAState
    var endState: TJRegexNFAState

    init() {
        startState = TJRegexNFAState()
        endState = TJRegexNFAState()
    }

    init(_ startState: TJRegexNFAState, _ endState: TJRegexNFAState) {
        self.startState = startState
        self.endState = endState
    }

    func setCaptureGroup(_ groupID: Int) {
        self.startState.startCaptureGroupID = groupID
        self.endState.endCaptureGroupID = groupID
    }
}

