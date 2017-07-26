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

class TJRegexTokenizeTests: XCTestCase {
    func testTJRegexTokenize_CG() {
        XCTAssertEqual(
            try! TJRegexTokenize("a"),
            [.SG(0), .C("a"), .EG]
        )

        XCTAssertEqual(
            try! TJRegexTokenize("[ab]"),
            [.SG(0), .SG(-1), .C("a"), .O, .C("b"), .EG, .EG]
        )

        XCTAssertEqual(
            try! TJRegexTokenize("[^ab]"),
            [.SG(0), .SG(-1), .C(..<"a"), .O, .C(leftOpen: "a" ..< "b"), .O, .C(leftOpen: "b"...), .EG, .EG]
        )

        XCTAssertEqual(
            try! TJRegexTokenize("[a-z]"),
            [.SG(0), .C("a" ... "z"), .EG]
        )

        XCTAssertEqual(
            try! TJRegexTokenize("[^a-z]"),
            [.SG(0), .SG(-1), .C(..<"a"), .O, .C(leftOpen: "z"...), .EG, .EG]
        )

        XCTAssertEqual(
            try! TJRegexTokenize("[a-yb-z]"),
            [.SG(0), .SG(-1), .C("a" ..< "b"), .O, .C("b" ... "z"), .EG, .EG]
        )

        XCTAssertEqual(
            try! TJRegexTokenize("[^a-yb-z]"),
            [.SG(0), .SG(-1), .C(..<"a"), .O, .C(leftOpen:"z"...), .EG, .EG]
        )
    }

    func testTJRegexTokenize_R() {
        XCTAssertEqual(
            try! TJRegexTokenize("a+"),
            [.SG(0), .C("a"), .R(1, nil), .EG]
        )

        XCTAssertEqual(
            try! TJRegexTokenize("a*"),
            [.SG(0), .C("a"), .R(0, nil), .EG]
        )

        XCTAssertEqual(
            try! TJRegexTokenize("a?"),
            [.SG(0), .C("a"), .R(0, 1), .EG]
        )

        XCTAssertEqual(
            try! TJRegexTokenize("a{3}"),
            [.SG(0), .C("a"), .R(3, 3), .EG]
        )

        XCTAssertEqual(
            try! TJRegexTokenize("a{34}"),
            [.SG(0), .C("a"), .R(34, 34), .EG]
        )

        XCTAssertEqual(
            try! TJRegexTokenize("a{1,34}"),
            [.SG(0), .C("a"), .R(1, 34), .EG]
        )

        XCTAssertEqual(
            try! TJRegexTokenize("a{12,34}"),
            [.SG(0), .C("a"), .R(12, 34), .EG]
        )
    }

    func testTJRegexTokenize_SG() {
        XCTAssertEqual(
            try! TJRegexTokenize("(a)"),
            [.SG(0), .SG(1), .C("a"), .EG, .EG]
        )
    }

    func testTJRegexTokenize_O() {
        XCTAssertEqual(
            try! TJRegexTokenize("a|b"),
            [.SG(0), .C("a"), .O, .C("b"), .EG]
        )
    }

    func testTJRegexTokenize_J() {
        XCTAssertEqual(
            try! TJRegexTokenize("ab"),
            [.SG(0), .C("a"), .J, .C("b"), .EG]
        )

        XCTAssertEqual(
            try! TJRegexTokenize("a(b)"),
            [.SG(0), .C("a"), .J, .SG(1), .C("b"), .EG, .EG]
        )

        XCTAssertEqual(
            try! TJRegexTokenize("(a)b"),
            [.SG(0), .SG(1), .C("a"), .EG, .J, .C("b"), .EG]
        )

        XCTAssertEqual(
            try! TJRegexTokenize("ab*"),
            [.SG(0), .C("a"), .J, .C("b"), .R(0, nil), .EG]
        )

        XCTAssertEqual(
            try! TJRegexTokenize("a*b"),
            [.SG(0), .C("a"), .R(0, nil), .J, .C("b"), .EG]
        )

        XCTAssertEqual(
            try! TJRegexTokenize("ab+"),
            [.SG(0), .C("a"), .J, .C("b"), .R(1, nil), .EG]
        )

        XCTAssertEqual(
            try! TJRegexTokenize("a+b"),
            [.SG(0), .C("a"), .R(1, nil), .J, .C("b"), .EG]
        )

        XCTAssertEqual(
            try! TJRegexTokenize("ab?"),
            [.SG(0), .C("a"), .J, .C("b"), .R(0, 1), .EG]
        )

        XCTAssertEqual(
            try! TJRegexTokenize("a?b"),
            [.SG(0), .C("a"), .R(0, 1), .J, .C("b"), .EG]
        )

        XCTAssertEqual(
            try! TJRegexTokenize("ab{2}"),
            [.SG(0), .C("a"), .J, .C("b"), .R(2, 2), .EG]
        )

        XCTAssertEqual(
            try! TJRegexTokenize("a{2}b"),
            [.SG(0), .C("a"), .R(2, 2), .J, .C("b"), .EG]
        )

        XCTAssertEqual(
            try! TJRegexTokenize("a[b]"),
            [.SG(0), .C("a"), .J, .C("b"), .EG]
        )

        XCTAssertEqual(
            try! TJRegexTokenize("[a]b"),
            [.SG(0), .C("a"), .J, .C("b"), .EG]
        )

        XCTAssertEqual(
            try! TJRegexTokenize("a|bc"),
            [.SG(0), .C("a"), .O, .C("b"), .J, .C("c"), .EG]
        )

        XCTAssertEqual(
            try! TJRegexTokenize("ab|c"),
            [.SG(0), .C("a"), .J, .C("b"), .O, .C("c"), .EG]
        )
   }

    static var allTests: [(String, (TJRegexTokenizeTests) -> () -> Void)] = [
        ("testTJRegexTokenize_CG", testTJRegexTokenize_CG),
        ("testTJRegexTokenize_R", testTJRegexTokenize_R),
        ("testTJRegexTokenize_SG", testTJRegexTokenize_SG),
        ("testTJRegexTokenize_O", testTJRegexTokenize_O),
        ("testTJRegexTokenize_J", testTJRegexTokenize_J),
    ]
}
