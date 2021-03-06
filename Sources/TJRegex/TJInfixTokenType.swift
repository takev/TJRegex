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

enum TJInfixTokenType: Equatable {
    case Operand
    case Operator(Int)  // Argument: Presedence 
    case LeftBracket
    case RightBracket
}

func ==(lhs: TJInfixTokenType, rhs: TJInfixTokenType) -> Bool {
    switch (lhs, rhs) {
        case (.Operand, .Operand): return true
        case (.Operator(let lhsP), .Operator(let rhsP)) where lhsP == rhsP: return true
        case (.LeftBracket, .LeftBracket): return true
        case (.RightBracket, .RightBracket): return true
        default: return false
    }
}
