//
//  CountRightAnswersUseCaseTests.swift
//  QuizChallengeTests
//
//  Created by Eduardo Sanches Bocato on 22/09/19.
//  Copyright © 2019 Bocato. All rights reserved.
//

import XCTest
@testable import QuizChallenge

final class CountRightAnswersUseCaseTests: XCTestCase {

    func test_whenGivingARightAnswer_itShouldReturnCountAsOne() {
        // Given
        let possibleAnswers = [QuizViewData.Item(text: "something")]
        let sut = CountRightAnswersUseCase(possibleAnswers: possibleAnswers)
        
        // When
        let rightAnswers = sut.execute(input: "something")
        
        // Then
        XCTAssertEqual(rightAnswers, 1, "Expected 1, but got \(rightAnswers).")
    }
    
    func test_whenGivingARightAnswer_itShouldReturnCountZero() {
        // Given
        let possibleAnswers = [QuizViewData.Item(text: "something")]
        let sut = CountRightAnswersUseCase(possibleAnswers: possibleAnswers)
        
        // When
        let rightAnswers = sut.execute(input: "other_thing")
        
        // Then
        XCTAssertEqual(rightAnswers, 0, "Expected 0, but got \(rightAnswers).")
    }
    
    func test_whenGivingNilInput_itShouldReturnTheCurrentCountOfRightAnswers() {
        // Given
        let possibleAnswers = [QuizViewData.Item(text: "something")]
        let sut = CountRightAnswersUseCase(possibleAnswers: possibleAnswers)
        let expectedRightAnswersCount = 1
        _ = sut.execute(input: "something")
        
        // When
        let rightAnswers = sut.execute(input: nil)
        
        // Then
        XCTAssertEqual(expectedRightAnswersCount, rightAnswers, "Expected \(expectedRightAnswersCount), but got \(rightAnswers).")
    }
    
    func test_whenGivingARightAnswerAgain_itShouldNotChangeTheRightAnswersCount() {
        // Given
        let possibleAnswers = [QuizViewData.Item(text: "something")]
        let expectedRightAnswersCount = 1
        let sut = CountRightAnswersUseCase(possibleAnswers: possibleAnswers)
        _ = sut.execute(input: "something")
        
        // When
        let rightAnswers = sut.execute(input: "something")
        
        // Then
        XCTAssertEqual(expectedRightAnswersCount, rightAnswers, "Expected \(expectedRightAnswersCount), but got \(rightAnswers).")
    }

}
