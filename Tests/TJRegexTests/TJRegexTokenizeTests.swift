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
            try! TJRegexTokenize("a").description,
            "(0:a)"
        )

        XCTAssertEqual(
            try! TJRegexTokenize("[ab]").description,
            "(0:[ab])"
        )

        XCTAssertEqual(
            try! TJRegexTokenize("[^ab]").description,
            "(0:[∞-aa-bb-∞])"
        )

        XCTAssertEqual(
            try! TJRegexTokenize("[a-z]").description,
            "(0:[a/z])"
        )

        XCTAssertEqual(
            try! TJRegexTokenize("[^a-z]").description,
            "(0:[∞-az-∞])"
        )

        XCTAssertEqual(
            try! TJRegexTokenize("[a-yb-z]").description,
            "(0:[a/-bb/z])"
        )

        XCTAssertEqual(
            try! TJRegexTokenize("[^a-yb-z]").description,
            "(0:[∞-az-∞])"
        )
    }

    func testTJRegexTokenize_R() {
        XCTAssertEqual(
            try! TJRegexTokenize("a+").description,
            "(0:a+)"
        )

        XCTAssertEqual(
            try! TJRegexTokenize("a*").description,
            "(0:a*)"
        )

        XCTAssertEqual(
            try! TJRegexTokenize("a?").description,
            "(0:a?)"
        )

        XCTAssertEqual(
            try! TJRegexTokenize("a{3}").description,
            "(0:a{3})"
        )

        XCTAssertEqual(
            try! TJRegexTokenize("a{34}").description,
            "(0:a{34})"
        )

        XCTAssertEqual(
            try! TJRegexTokenize("a{1,34}").description,
            "(0:a{1,34})"
        )

        XCTAssertEqual(
            try! TJRegexTokenize("a{12,34}").description,
            "(0:a{12,34})"
        )
    }

    func testTJRegexTokenize_SG() {
        XCTAssertEqual(
            try! TJRegexTokenize("(a)").description,
            "(0:(1:a))"
        )
    }

    func testTJRegexTokenize_O() {
        XCTAssertEqual(
            try! TJRegexTokenize("a|b").description,
            "(0:a|b)"
        )
    }

    func testTJRegexTokenize_J() {
        XCTAssertEqual(
            try! TJRegexTokenize("ab").description,
            "(0:a.b)"
        )

        XCTAssertEqual(
            try! TJRegexTokenize("a(b)").description,
            "(0:a.(1:b))"
        )

        XCTAssertEqual(
            try! TJRegexTokenize("(a)b").description,
            "(0:(1:a).b)"
        )

        XCTAssertEqual(
            try! TJRegexTokenize("ab*").description,
            "(0:a.b*)"
        )

        XCTAssertEqual(
            try! TJRegexTokenize("a*b").description,
            "(0:a*.b)"
        )

        XCTAssertEqual(
            try! TJRegexTokenize("ab+").description,
             "(0:a.b+)"
       )

        XCTAssertEqual(
            try! TJRegexTokenize("a+b").description,
             "(0:a+.b)"
        )

        XCTAssertEqual(
            try! TJRegexTokenize("ab?").description,
             "(0:a.b?)"
        )

        XCTAssertEqual(
            try! TJRegexTokenize("a?b").description,
             "(0:a?.b)"
        )

        XCTAssertEqual(
            try! TJRegexTokenize("ab{2}").description,
             "(0:a.b{2})"
        )

        XCTAssertEqual(
            try! TJRegexTokenize("a{2}b").description,
             "(0:a{2}.b)"
        )

        XCTAssertEqual(
            try! TJRegexTokenize("a[b]").description,
             "(0:a.b)"
        )

        XCTAssertEqual(
            try! TJRegexTokenize("[a]b").description,
             "(0:a.b)"
        )

        XCTAssertEqual(
            try! TJRegexTokenize("a|bc").description,
             "(0:a|b.c)"
        )

        XCTAssertEqual(
            try! TJRegexTokenize("ab|c").description,
             "(0:a.b|c)"
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
