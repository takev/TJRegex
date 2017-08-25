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

enum TJRegexNFATransition {
    case Epsilon(TJRegexNFAState)
    case Input(TJRegexNFAState, RegexToken)
}

class TJRegexNFAState {
    var transitions: [TJRegexNFATransition] = []
    var startCaptureGroupID: Int?
    var endCaptureGroupID: Int?

    func addEpsilonTransition(_ nextState: TJRegexNFAState) {
        transitions.append(.Epsilon(nextState))
    }

    func addInputTransition(_ nextState: TJRegexNFAState, token: RegexToken) {
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

