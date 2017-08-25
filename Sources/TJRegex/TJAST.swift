// TJRegex - Regular Expression library based on the Swift String struct.
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

struct TJAST<T>: Equatable, CustomStringConvertible where T: Equatable, T: CustomStringConvertible {
    typealias Element = T

    let token: Element
    let children: [TJAST<Element>]

    var description: String {
        var s = token.description

        if children.count > 0 {
            s += "{" + children[0].description
            for i in 1 ..< children.count {
                s += ", "
                s += children[i].description
            }

            s += "}"
        }

        return s
    }


    init(_ token: Element, _ children: [TJAST] = []) {
        self.token = token
        self.children = children
    }

    init(_ token: Element, _ children: ArraySlice<TJAST>) {
        self.init(token, Array<TJAST>(children))
    }

    static func == (lhs: TJAST, rhs: TJAST) -> Bool {
        guard lhs.token == rhs.token else {
            return false
        }

        return lhs.children == rhs.children
    }
}
