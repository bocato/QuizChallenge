//
//  EnvironmentTests.swift
//  QuizChallengeTests
//
//  Created by Eduardo Sanches Bocato on 21/09/19.
//  Copyright © 2019 Bocato. All rights reserved.
//

import XCTest
import UIKit
@testable import QuizChallenge

final class EnvironmentTests: XCTestCase {
    
    func test_environment_souldStartAsDev() {
        // Given
        let expectedCurrentEnviroment: EnvironmentType = .development
        guard let expectedBaseURL = URL(string: "https://codechallenge.arctouch.com") else {
            XCTFail("Could not instantiate baseURL.")
            return
        }
        let sut: EnvironmentProvider = Environment.shared
        
        // When
        let currentEnvironment = sut.currentEnvironment
        let baseURL = sut.baseURL
        
        // Then
        XCTAssertEqual(currentEnvironment.rawValue, expectedCurrentEnviroment.rawValue, "The Environments should the same.")
        XCTAssertEqual(baseURL, expectedBaseURL, "The baseURL's should the same.")
    }
    
}
