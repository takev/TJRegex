import XCTest
@testable import TJRegex

class TJRegexTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(TJRegex().text, "Hello, World!")
    }


    static var allTests: [(String, (TJRegexTests) -> () -> Void)] = [
        ("testExample", testExample),
    ]
}
