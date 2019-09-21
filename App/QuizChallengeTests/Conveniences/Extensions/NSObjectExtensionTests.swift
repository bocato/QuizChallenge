//
//  NSObjectExtensionTests.swift
//  QuizChallengeTests
//
//  Created by Eduardo Sanches Bocato on 21/09/19.
//  Copyright © 2019 Bocato. All rights reserved.
//

import XCTest
import UIKit
@testable import QuizChallenge

final class NSObjectExtensionTests: XCTestCase {
    
    func test_className_shouldReturnValidName() {
        // Given
        let expectedName = "MockTableViewClass"
        
        // When
        let sut = MockTableViewClass.className
        
        // Then
        XCTAssertEqual(expectedName, sut, "The names should be as expected.")
    }
    
}

private class MockTableViewClass: UITableView {}
