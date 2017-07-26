import XCTest
@testable import TJRegexTests

XCTMain([
    testCase(TJRegexTokenizeTests.allTests),
    testCase(TJInfixToPostfixTests.allTests),
])
