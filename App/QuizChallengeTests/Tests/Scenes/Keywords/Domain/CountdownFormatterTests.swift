//
//  CountdownFormatterTests.swift
//  QuizChallengeTests
//
//  Created by Eduardo Sanches Bocato on 22/09/19.
//  Copyright © 2019 Bocato. All rights reserved.
//

import XCTest
@testable import QuizChallenge

final class CountdownFormatterTests: XCTestCase {
    
    private lazy var sut = CountDownFormatter()
    
    func test_whenFormattingFromSeccondsWithMinutes_thenItShouldReturnTheExpectedString() {
        // Given
        let seconds = 60
        let expectedString = "01:00"
        
        // When
        let formatted = sut.formatToMinutes(from: seconds)
        
        // Then
        XCTAssertEqual(expectedString, formatted, "Expected \(expectedString), but got \(formatted).")
    }

}
