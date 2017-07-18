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
