import XCTest
@testable import TJRegex

class TJRegexTests: XCTestCase {
    func testTJRegexParse() {

        XCTAssertEqual(
            try! TJRegexTokenize("abc"),
            [.SG(0), .C("a"), .J, .C("b"), .J, .C("c"), .EG]
                as [TJRegexToken]
        )

        XCTAssertEqual(
            try! TJRegexTokenize("ab+c"),
            [.SG(0), .C("a"), .J, .C("b"), .R(1, nil), .J, .C("c"), .EG]
                as [TJRegexToken]
        )

        XCTAssertEqual(
            try! TJRegexTokenize("(ab)+c"),
            [.SG(0), .SG(1), .C("a"), .J, .C("b"), .EG, .R(1, nil), .J, .C("c"), .EG]
                as [TJRegexToken]
        )

        XCTAssertEqual(
            try! TJRegexTokenize("ab*c"),
            [.SG(0), .C("a"), .J, .C("b"), .R(0, nil), .J, .C("c"), .EG]
                as [TJRegexToken]
        )

        XCTAssertEqual(
            try! TJRegexTokenize("ab?c"),
            [.SG(0), .C("a"), .J, .C("b"), .R(0, 1), .J, .C("c"), .EG]
                as [TJRegexToken]
        )

        XCTAssertEqual(
            try! TJRegexTokenize("ab{3}c"),
            [.SG(0), .C("a"), .J, .C("b"), .R(3, 3), .J, .C("c"), .EG]
                as [TJRegexToken]
        )

        XCTAssertEqual(
            try! TJRegexTokenize("ab{34}c"),
            [.SG(0), .C("a"), .J, .C("b"), .R(34, 34), .J, .C("c"), .EG]
                as [TJRegexToken]
        )

        XCTAssertEqual(
            try! TJRegexTokenize("ab{1,34}c"),
            [.SG(0), .C("a"), .J, .C("b"), .R(1, 34), .J, .C("c"), .EG]
                as [TJRegexToken]
        )

        XCTAssertEqual(
            try! TJRegexTokenize("ab{12,34}c"),
            [.SG(0), .C("a"), .J, .C("b"), .R(12, 34), .J, .C("c"), .EG]
                as [TJRegexToken]
        )

    }

    func testTJInfixToPostfix() {
        XCTAssertEqual(
            try! TJInfixToPostfix(
                [.SG(0), .C("a"), .J, .C("b"), .J, .C("c"), .EG]
                    as [TJRegexToken]
            ),
            [.C("a"), .C("b"), .J, .C("c"), .J, .SG(0)]
                as [TJRegexToken]
        )

        XCTAssertEqual(
            try! TJInfixToPostfix(
                [.SG(0), .C("a"), .J, .C("b"), .R(1, nil), .J, .C("c"), .EG]
                    as [TJRegexToken]
            ),
            [.C("a"), .C("b"), .R(1, nil), .J, .C("c"), .J, .SG(0)]
                as [TJRegexToken]
        )

        XCTAssertEqual(
            try! TJInfixToPostfix(
                [.SG(0), .SG(1), .C("a"), .J, .C("b"), .EG, .R(1, nil), .J, .C("c"), .EG]
                    as [TJRegexToken]
            ),
            [.C("a"), .C("b"), .J, .SG(1), .R(1, nil), .C("c"), .J, .SG(0)]
                as [TJRegexToken]
        )

    }

    static var allTests: [(String, (TJRegexTests) -> () -> Void)] = [
        ("testTJRegexParse", testTJRegexParse),
        ("testTJInfixToPostfix", testTJRegexParse),
    ]
}
