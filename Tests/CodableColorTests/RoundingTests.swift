//
//  RoundingTests.swift
//  
//
//  Created by PJ on 18/03/2024.
//

import XCTest

final class RoundingTests: XCTestCase {

    func test_rounding() throws {
        XCTAssertEqual(Double(10.98765432).rounded(to: 2), 10.99)
        XCTAssertEqual(CGFloat(10.98765432).rounded(to: 2), 10.99)
        XCTAssertEqual(Float(10.98765432).rounded(to: 2), 10.99)
    }

}
