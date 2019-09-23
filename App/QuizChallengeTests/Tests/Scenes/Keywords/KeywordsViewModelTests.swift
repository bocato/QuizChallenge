//
//  KeywordsViewModelTests.swift
//  QuizChallengeTests
//
//  Created by Eduardo Sanches Bocato on 22/09/19.
//  Copyright © 2019 Bocato. All rights reserved.
//

import XCTest
@testable import QuizChallenge

final class KeywordsViewModelTests: XCTestCase {

    // MARK: - KeywordsViewModelDisplayLogic Tests
    
    func test_numberOfAnswersShouldBeZeroOnInit() {
        // When
        let sut = KeywordsViewModel(fetchQuizUseCase: FetchQuizUseCaseProviderDummy())
        // Then
        XCTAssertEqual(sut.numberOfAnswers, 0, "`numberOfAnswers` should be zero on init.")
    }
    
    func test_onViewDidLoad_shouldSetupTheDefaultsAndLoadQuiz() {
        // Given
        let viewModelBinderSpy = KeywordsViewModelBindingSpy()
        let fetchQuizUseCaseSpy = FetchQuizUseCaseProviderSpy()
        let sut = KeywordsViewModel(fetchQuizUseCase: fetchQuizUseCaseSpy)
        sut.viewModelBinder = viewModelBinderSpy
        
        // When
        sut.onViewDidLoad()
        
        // Then
        XCTAssertTrue(viewModelBinderSpy.viewTitleDidChangeCalled, "`viewTitleDidChange` should have been called.")
        XCTAssertEqual(viewModelBinderSpy.titlePassedToViewTitleDidChange, "", "Expected an empty string, but got \(viewModelBinderSpy.titlePassedToViewTitleDidChange ?? "").")
        
        XCTAssertTrue(viewModelBinderSpy.textFieldPlaceholderDidChangeCalled, "`textFieldPlaceholderDidChange` should have been called.")
        XCTAssertEqual(viewModelBinderSpy.textPassedToTextFieldPlaceholderDidChange, "Insert Word", "Expected `Insert Word``, but got \(viewModelBinderSpy.textPassedToTextFieldPlaceholderDidChange ?? "").")
        
        XCTAssertTrue(viewModelBinderSpy.bottomButtonTitleDidChangeCalled, "`bottomButtonTitleDidChange` should have been called.")
        XCTAssertEqual(viewModelBinderSpy.titlePassedToBottomButtonTitleDidChange, "Start", "Expected `Start``, but got \(viewModelBinderSpy.titlePassedToBottomButtonTitleDidChange ?? "").")
        
        XCTAssertTrue(viewModelBinderSpy.bottomLeftTextDidChangeCalled, "`bottomLeftTextDidChange` should have been called.")
        XCTAssertEqual(viewModelBinderSpy.textPassedToBottomLeftTextDidChange, "00/00", "Expected `00/00``, but got \(viewModelBinderSpy.textPassedToBottomLeftTextDidChange ?? "").")
        
        XCTAssertTrue(viewModelBinderSpy.bottomRightTextDidChangeCalled, "`bottomRightTextDidChange` should have been called.")
        XCTAssertEqual(viewModelBinderSpy.textPassedToBottomRightTextDidChange, "05:00", "Expected `05:00`, but got \(viewModelBinderSpy.textPassedToBottomRightTextDidChange ?? "").")
        
        XCTAssertTrue(fetchQuizUseCaseSpy.executeCalled, "`execute` should have been called.")
        
    }
    
    func test_whenNoAnswersWereLoaded_answerItemShouldReturnNil() {
        // Given
        let sut = KeywordsViewModel(fetchQuizUseCase: FetchQuizUseCaseProviderDummy())
        
        // When
        let item = sut.answerItem(at: 1)
        
        // Then
        XCTAssertNil(item, "Expected `nil`, but got \(item.debugDescription)")
    }
    
    func test_whenNoAnswersWereLoaded_answerItemShouldReturnAnItem() {
        // Given
        let quizEntityToReturn = QuizEntity(
            question: "Some question",
            answer: ["a", "b", "c"]
        )
        let resultToReturn: Result<QuizEntity, QuizServiceError> = .success(quizEntityToReturn)
        let quizService = QuizServiceStub(resultToReturn: resultToReturn)
        let fetchQuizUseCase = FetchQuizUseCase(quizService: quizService)
        let sut = KeywordsViewModel(fetchQuizUseCase: fetchQuizUseCase)
        sut.onViewDidLoad()
        
        // When
        let item = sut.answerItem(at: 0)
        
        // Then
        XCTAssertNotNil(item)
    }

}

// MARK: - Testing Helpers

private class FetchQuizUseCaseProviderDummy: FetchQuizUseCaseProvider {
    func execute(completion: @escaping (UseCaseEvent<QuizViewData, FetchQuizUseCaseError>) -> Void) {}
}

private class FetchQuizUseCaseProviderSpy: FetchQuizUseCaseProvider {
    private(set) var executeCalled = false
    func execute(completion: @escaping (UseCaseEvent<QuizViewData, FetchQuizUseCaseError>) -> Void) {
        executeCalled = true
    }
}

private class KeywordsViewModelBindingSpy: KeywordsViewModelBinding {
    
    private(set) var viewTitleDidChangeCalled = false
    private(set) var titlePassedToViewTitleDidChange: String?
    func viewTitleDidChange(_ title: String?) {
        viewTitleDidChangeCalled = true
        titlePassedToViewTitleDidChange = title
    }
    
    private(set) var textFieldPlaceholderDidChangeCalled = false
    private(set) var textPassedToTextFieldPlaceholderDidChange: String?
    func textFieldPlaceholderDidChange(_ text: String?) {
        textFieldPlaceholderDidChangeCalled = true
        textPassedToTextFieldPlaceholderDidChange = text
    }
    
    private(set) var bottomRightTextDidChangeCalled = false
    private(set) var textPassedToBottomRightTextDidChange: String?
    func bottomRightTextDidChange(_ text: String?) {
        bottomRightTextDidChangeCalled = true
        textPassedToBottomRightTextDidChange = text
    }
    
    private(set) var bottomLeftTextDidChangeCalled = false
    private(set) var textPassedToBottomLeftTextDidChange: String?
    func bottomLeftTextDidChange(_ text: String?) {
        bottomLeftTextDidChangeCalled = true
        textPassedToBottomLeftTextDidChange = text
    }
    
    private(set) var bottomButtonTitleDidChangeCalled = false
    private(set) var titlePassedToBottomButtonTitleDidChange: String?
    func bottomButtonTitleDidChange(_ title: String?) {
        bottomButtonTitleDidChangeCalled = true
        titlePassedToBottomButtonTitleDidChange = title
    }
    
    private(set) var showTimerFinishedModalWithDataCalled = false
    private(set) var modalDataPassedToShowTimerFinishedModalWithData: SimpleModalViewData?
    func showTimerFinishedModalWithData(_ modalData: SimpleModalViewData) {
        showTimerFinishedModalWithDataCalled = true
        modalDataPassedToShowTimerFinishedModalWithData = modalData
    }
    
    private(set) var showWinnerModalWithDataCalled = false
    private(set) var modalDataPassedToShowWinnerModalWithData: SimpleModalViewData?
    func showWinnerModalWithData(_ modalData: SimpleModalViewData) {
        showWinnerModalWithDataCalled = true
        modalDataPassedToShowWinnerModalWithData = modalData
    }
    
    private(set) var showErrorModalWithDataCalled = false
    private(set) var modalDataPassedToShowErrorModalWithData: SimpleModalViewData?
    func showErrorModalWithData(_ modalData: SimpleModalViewData) {
        showErrorModalWithDataCalled = true
        modalDataPassedToShowErrorModalWithData = modalData
    }
    
    
}
