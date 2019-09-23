//
//  StringExtensionTests.swift
//  QuizChallengeTests
//
//  Created by Eduardo Sanches Bocato on 21/09/19.
//  Copyright © 2019 Bocato. All rights reserved.
//

import XCTest
@testable import QuizChallenge

final class StringExtensionTests: XCTestCase {
    
    func test_whenCapitalizingFirstLetter_thenItShouldReturnAValidOutput() {
        // Given
        let sut = "something"
        let expectedValue = "Something"
        
        // When
        let capitalizingFirstLetter = sut.capitalizingFirstLetter()
        
        // Then
        XCTAssertEqual(capitalizingFirstLetter, expectedValue, "Expected a value with the first letter captalized, but got \(capitalizingFirstLetter)")
    }
    
    func test_whenCapitalizeFirstLetter_thenItShouldReturnAValidOutput() {
        // Given
        var sut = "something"
        let expectedValue = "Something"
        
        // When
        sut.capitalizeFirstLetter()
        
        // Then
        XCTAssertEqual(sut, expectedValue, "Expected a value with the first letter captalized, but got \(sut)")
    }
    
}
