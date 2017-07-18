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

func TJRegexASTToNFA(_ ast: TJAST<TJRegexToken>) -> TJRegexNFA {
    switch (ast.token) {
        case .CG:
            precondition(ast.children.count == 0, "Expect a character operator to have no operands.")

            let nfa = TJRegexNFA()
            nfa.startState.addInputTransition(nfa.endState, token: ast.token)
            return nfa

        case .J:
            precondition(ast.children.count >= 1, "Expect a join operator to have one or more operands.")

            let nfa = TJRegexNFA()
            var startState = nfa.startState

            for child in ast.children {
                let childNFA = TJRegexASTToNFA(child)
                startState.addEpsilonTransition(childNFA.startState)
                startState = childNFA.endState
            }

            startState.addEpsilonTransition(nfa.endState)
            return nfa

        case .O:
            precondition(ast.children.count >= 1, "Expect a join operator to have one or more operands.")

            let nfa = TJRegexNFA()
            for child in ast.children {
                let childNFA = TJRegexASTToNFA(child)
                nfa.startState.addEpsilonTransition(childNFA.startState)
                childNFA.endState.addEpsilonTransition(nfa.endState)
            }
            return nfa

        case let .R(minimumCount, optionalMaximumCount):
            precondition(ast.children.count == 1, "Expect a character operator to have one operand.")
            let child = ast.children[0]

            let nfa = TJRegexNFA()
            var startState = nfa.startState

            // First join the child NFA multiple times for the minimumCount.
            for _ in 0 ..< minimumCount {
                let childNFA = TJRegexASTToNFA(child)
                startState.addEpsilonTransition(childNFA.startState)
                startState = childNFA.endState
            }

            if let maximumCount = optionalMaximumCount {
                // Second join the child NFA multiple times for maximumCount - minimumCount.
                // Add an epsilon in front of each child NFA to the end state.
                for _ in 0 ..< (maximumCount - minimumCount) {
                    let childNFA = TJRegexASTToNFA(child)
                    startState.addEpsilonTransition(childNFA.startState)
                    startState.addEpsilonTransition(nfa.endState)
                    startState = childNFA.endState
                }
                startState.addEpsilonTransition(nfa.endState)

            } else {
                // Have a single child NFA, and have an epsilon loop from child-end to -start state.
                // Add an epsilon in from of this child to the end state
                let childNFA = TJRegexASTToNFA(child)
                startState.addEpsilonTransition(childNFA.startState)
                startState.addEpsilonTransition(nfa.endState)

                childNFA.endState.addEpsilonTransition(childNFA.startState)
                childNFA.endState.addEpsilonTransition(nfa.endState)
            }

            return nfa

        case let .SG(groupID):
            precondition(ast.children.count == 1, "Expect a start group operator to have one operand.")

            let child = ast.children[0]
            let childNFA = TJRegexASTToNFA(child)
            childNFA.setCaptureGroup(groupID)

            return childNFA

        case .EG:
            preconditionFailure("EndGroup is unexpected in an AST.")
    }
}

