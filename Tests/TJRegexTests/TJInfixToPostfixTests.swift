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
import XCTest
@testable import TJRegex

class TJInfixToPostfixTests: XCTestCase {

    func testTJInfixToPostfix() {
        XCTAssertEqual(
            try! TJInfixToPostfix(
                [.SG(0), .C("a"), .J, .C("b"), .J, .C("c"), .EG]
                    as [RegexToken]
            ),
            [.C("a"), .C("b"), .J, .C("c"), .J, .SG(0)]
                as [RegexToken]
        )

        XCTAssertEqual(
            try! TJInfixToPostfix(
                [.SG(0), .C("a"), .J, .C("b"), .R(1, nil), .J, .C("c"), .EG]
                    as [RegexToken]
            ),
            [.C("a"), .C("b"), .R(1, nil), .J, .C("c"), .J, .SG(0)]
                as [RegexToken]
        )

        XCTAssertEqual(
            try! TJInfixToPostfix(
                [.SG(0), .SG(1), .C("a"), .J, .C("b"), .EG, .R(1, nil), .J, .C("c"), .EG]
                    as [RegexToken]
            ),
            [.C("a"), .C("b"), .J, .SG(1), .R(1, nil), .C("c"), .J, .SG(0)]
                as [RegexToken]
        )

    }

    static var allTests: [(String, (TJInfixToPostfixTests) -> () -> Void)] = [
        ("testTJInfixToPostfix", testTJInfixToPostfix),
    ]
}

