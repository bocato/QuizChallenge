//
//  FetchQuizUseCaseTests.swift
//  QuizChallengeTests
//
//  Created by Eduardo Sanches Bocato on 22/09/19.
//  Copyright © 2019 Bocato. All rights reserved.
//

import XCTest
@testable import QuizChallenge

final class FetchQuizUseCaseTests: XCTestCase {

    func test_whenFechingAQuizWithSuccess_itShouldReturnTheExpectedEventsAndData() {
        // Given
        let quizEntityToReturn = QuizEntity(
            question: "Some question",
            answer: ["a", "b", "c"]
        )
        let expectedViewDataItems = ["A", "B", "C"]
        let resultToReturn: Result<QuizEntity, QuizServiceError> = .success(quizEntityToReturn)
        let quizService = QuizServiceStub(resultToReturn: resultToReturn)
        let sut = FetchQuizUseCase(quizService: quizService)
        let numberOfEventsExpected = 2
        var events = [UseCaseEvent<QuizViewData, FetchQuizUseCaseError>]()
        
        // When
        let executeUseCaseExpectation = expectation(description: "executeUseCaseExpectation")
        sut.execute { event in
            events.append(event)
            if numberOfEventsExpected == events.count {
                executeUseCaseExpectation.fulfill()
            }
        }
        wait(for: [executeUseCaseExpectation], timeout: 1.0)
        
        // Then
        guard case .loading = events[0].status else {
            XCTFail("Expected .loading, but got \(events[0].status)")
            return
        }
        
        guard case let .data(viewData) = events[1].status else {
            XCTFail("Expected .loading, but got \(events[1].status)")
            return
        }
        XCTAssertEqual(viewData.title, quizEntityToReturn.question, "Expected \(viewData.title) but got \(quizEntityToReturn.question).")
        let items = viewData.items.map { $0.text }
        XCTAssertEqual(expectedViewDataItems, items, "Expected \(expectedViewDataItems) but got \(items).")
    }
    
    func test_whenFechingAQuizWithError_itShouldReturnTheExpectedEventsAndData() {
        // Given
        let errorToReturn: QuizServiceError = .networking(.unknown)
        let resultToReturn: Result<QuizEntity, QuizServiceError> = .failure(errorToReturn)
        let quizService = QuizServiceStub(resultToReturn: resultToReturn)
        let sut = FetchQuizUseCase(quizService: quizService)
        let numberOfEventsExpected = 2
        var events = [UseCaseEvent<QuizViewData, FetchQuizUseCaseError>]()
        
        // When
        let executeUseCaseExpectation = expectation(description: "executeUseCaseExpectation")
        sut.execute { event in
            events.append(event)
            if numberOfEventsExpected == events.count {
                executeUseCaseExpectation.fulfill()
            }
        }
        wait(for: [executeUseCaseExpectation], timeout: 1.0)
        
        // Then
        guard case .loading = events[0].status else {
            XCTFail("Expected .loading, but got \(events[0].status)")
            return
        }
        
        guard case let .serviceError(error) = events[1].status else {
            XCTFail("Expected .loading, but got \(events[1].status)")
            return
        }
        
        XCTAssertEqual(errorToReturn.localizedDescription, error.localizedDescription, "Expected \(errorToReturn.localizedDescription) but got \(error.localizedDescription)")
    }

}

// MARK: - Testing Helpers
final class QuizServiceStub: QuizServiceProvider {
    
    private let resultToReturn: Result<QuizEntity, QuizServiceError>
    init(resultToReturn: Result<QuizEntity, QuizServiceError>) {
        self.resultToReturn = resultToReturn
    }
    
    func getQuiz(_ completion: @escaping (Result<QuizEntity, QuizServiceError>) -> Void) {
        completion(resultToReturn)
    }
    
}
