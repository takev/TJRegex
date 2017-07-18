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
                as [TJRegexToken]
        )

        XCTAssertEqual(
            try! TJRegexTokenize("[ab]"),
            [.SG(0), .SG(-1), .C("a"), .O, .C("b"), .EG, .EG]
                as [TJRegexToken]
        )

        XCTAssertEqual(
            try! TJRegexTokenize("[^ab]"),
            [.SG(0), .SG(-1), .C("a"), .O, .C("b"), .EG, .EG]
                as [TJRegexToken]
        )
    }

    func testTJRegexTokenize_R() {
        XCTAssertEqual(
            try! TJRegexTokenize("a+"),
            [.SG(0), .C("a"), .R(1, nil), .EG]
                as [TJRegexToken]
        )

        XCTAssertEqual(
            try! TJRegexTokenize("a*"),
            [.SG(0), .C("a"), .R(0, nil), .EG]
                as [TJRegexToken]
        )

        XCTAssertEqual(
            try! TJRegexTokenize("a?"),
            [.SG(0), .C("a"), .R(0, 1), .EG]
                as [TJRegexToken]
        )

        XCTAssertEqual(
            try! TJRegexTokenize("a{3}"),
            [.SG(0), .C("a"), .R(3, 3), .EG]
                as [TJRegexToken]
        )

        XCTAssertEqual(
            try! TJRegexTokenize("a{34}"),
            [.SG(0), .C("a"), .R(34, 34), .EG]
                as [TJRegexToken]
        )

        XCTAssertEqual(
            try! TJRegexTokenize("a{1,34}"),
            [.SG(0), .C("a"), .R(1, 34), .EG]
                as [TJRegexToken]
        )

        XCTAssertEqual(
            try! TJRegexTokenize("a{12,34}"),
            [.SG(0), .C("a"), .R(12, 34), .EG]
                as [TJRegexToken]
        )
    }

    func testTJRegexTokenize_SG() {
        XCTAssertEqual(
            try! TJRegexTokenize("(a)"),
            [.SG(0), .SG(1), .C("a"), .EG, .EG]
                as [TJRegexToken]
        )
    }

    static var allTests: [(String, (TJRegexTokenizeTests) -> () -> Void)] = [
        ("testTJRegexTokenize_CG", testTJRegexTokenize_CG),
        ("testTJRegexTokenize_R", testTJRegexTokenize_R),
        ("testTJRegexTokenize_SG", testTJRegexTokenize_SG),
    ]
}
