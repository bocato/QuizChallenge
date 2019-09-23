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
        let quizServiceStub = QuizServiceStub(resultToReturn: resultToReturn)
        let fetchQuizUseCase = FetchQuizUseCase(quizService: quizServiceStub)
        let sut = KeywordsViewModel(fetchQuizUseCase: fetchQuizUseCase)
        sut.onViewDidLoad()
        
        // When
        let item = sut.answerItem(at: 0)
        
        // Then
        XCTAssertNotNil(item)
    }
    
    // MARK: - KeywordsViewModelBusinessLogic Tests
    
    func test_whenLoadingQuizDataSuccessfully_thenViewControlerShouldReceiveTheCorrectData() {
        // Given
        let viewModelBinderSpy = KeywordsViewModelBindingSpy()
        let viewStateRendererSpy = ViewStateRenderingSpy()
        let quizEntityToReturn = QuizEntity(
            question: "Some question",
            answer: ["a"]
        )
        let expectedViewData = QuizViewData(
            title: "Some question",
            items: [QuizViewData.Item(text: "A")]
        )
        let expectedBottomLeftText = "00/01"
        let resultToReturn: Result<QuizEntity, QuizServiceError> = .success(quizEntityToReturn)
        let quizServiceStub = QuizServiceStub(resultToReturn: resultToReturn)
        let fetchQuizUseCase = FetchQuizUseCase(quizService: quizServiceStub)
        let sut = KeywordsViewModel(fetchQuizUseCase: fetchQuizUseCase)
        sut.viewModelBinder = viewModelBinderSpy
        sut.viewStateRenderer = viewStateRendererSpy
        
        // When
        sut.loadQuizData()
        
        // Then
        
        let viewStates = viewStateRendererSpy.allStatesPassed
        XCTAssertTrue(viewStateRendererSpy.renderStateCalled)
        guard case .loading = viewStates[0] else {
            XCTFail("Expected .loading, but got \(viewStates[0])")
            return
        }
        guard case .content = viewStates[1] else {
            XCTFail("Expected .content, but got \(viewStates[0])")
            return
        }
        
        XCTAssertTrue(viewModelBinderSpy.viewTitleDidChangeCalled, "`viewTitleDidChange` should have been called.")
        XCTAssertEqual(viewModelBinderSpy.titlePassedToViewTitleDidChange, expectedViewData.title, "Expected \(expectedViewData.title), but got \(viewModelBinderSpy.titlePassedToViewTitleDidChange ?? "")")
        
        XCTAssertTrue(viewModelBinderSpy.bottomLeftTextDidChangeCalled, "`bottomLeftTextDidChange` should have been called.")
        XCTAssertEqual(viewModelBinderSpy.textPassedToBottomLeftTextDidChange, expectedBottomLeftText, "Expected \(expectedBottomLeftText), but got \(viewModelBinderSpy.titlePassedToViewTitleDidChange ?? "")")
    }
    
    func test_whenLoadingQuizDataWithError_thenTheViewControllerShouldReceiveAnErrorFillerToHandle() {
        // Given
        let viewModelBinderSpy = KeywordsViewModelBindingSpy()
        let viewStateRendererSpy = ViewStateRenderingSpy()
        let expectedViewFiller = ViewFiller(title: "Ooops!", subtitle: "Something wrong has happened")
        let errorToReturn: QuizServiceError = .networking(.unknown)
        let resultToReturn: Result<QuizEntity, QuizServiceError> = .failure(errorToReturn)
        let quizServiceStub = QuizServiceStub(resultToReturn: resultToReturn)
        let fetchQuizUseCase = FetchQuizUseCase(quizService: quizServiceStub)
        let sut = KeywordsViewModel(fetchQuizUseCase: fetchQuizUseCase)
        sut.viewModelBinder = viewModelBinderSpy
        sut.viewStateRenderer = viewStateRendererSpy
        
        // When
        sut.loadQuizData()
        
        // Then
        let viewStates = viewStateRendererSpy.allStatesPassed
        XCTAssertTrue(viewStateRendererSpy.renderStateCalled)
        guard case .loading = viewStates[0] else {
            XCTFail("Expected .loading, but got \(viewStates[0])")
            return
        }
        guard case let .error(viewFiller) = viewStates[1] else {
            XCTFail("Expected .content, but got \(viewStates[0])")
            return
        }
        XCTAssertNotNil(viewFiller, "Expected a viewFiller, but got nil.")
        XCTAssertEqual(viewFiller?.title, expectedViewFiller.title, "Expected \(expectedViewFiller.title), but got \(viewFiller?.title ?? "").")
        XCTAssertEqual(viewFiller?.subtitle, expectedViewFiller.subtitle, "Expected \(expectedViewFiller.subtitle ?? ""), but got \(viewFiller?.subtitle ?? "").")
    }
    
    func test_whenToggleTimerIsCalledAndTimerIsRunning_timerShouldStartAndReflectOnView() {
        // Given
        let viewModelBinderSpy = KeywordsViewModelBindingSpy()
        let countDownTimerProviderStubSpy = CountDownTimerProviderStubSpy()
        countDownTimerProviderStubSpy.isRunningToReturn = false
        countDownTimerProviderStubSpy.runOnFinish = false
        let sut = KeywordsViewModel(
            timerPeriod: 2,
            countDownTimer: countDownTimerProviderStubSpy,
            fetchQuizUseCase: FetchQuizUseCaseProviderDummy()
        )
        sut.viewModelBinder = viewModelBinderSpy

        // Then
        sut.toggleTimer()

        // When
        XCTAssertTrue(viewModelBinderSpy.bottomButtonTitleDidChangeCalled, "Expected `bottomButtonTitleDidChange` to be called.")
        XCTAssertEqual(viewModelBinderSpy.titlePassedToBottomButtonTitleDidChange, "Reset", "Expected `Reset`, but got \(viewModelBinderSpy.titlePassedToBottomButtonTitleDidChange.debugDescription)")

        XCTAssertTrue(viewModelBinderSpy.bottomRightTextDidChangeCalled, "Expected `bottomRightTextDidChange` to be called.")
        XCTAssertEqual(viewModelBinderSpy.bottomRightTextDidChangeValuesAcumulated.count, 2, "Expected to receive 2 values.")
        XCTAssertEqual(viewModelBinderSpy.textPassedToBottomRightTextDidChange, "00:01", "Expected to receive `00:01` as the last value, but got \(viewModelBinderSpy.textPassedToBottomRightTextDidChange ?? "").")

    }
    
    func test_whenToggleTimerIsCalledAndTimerIsRunning_timerShouldStartAndShowTimeIsUpAndTimerInfoShouldBeReset() {
        // Given
        let viewModelBinderSpy = KeywordsViewModelBindingSpy()
        let countDownTimerProviderStubSpy = CountDownTimerProviderStubSpy()
        countDownTimerProviderStubSpy.isRunningToReturn = false
        countDownTimerProviderStubSpy.runOnFinish = true
        let sut = KeywordsViewModel(
            timerPeriod: 1,
            countDownTimer: countDownTimerProviderStubSpy,
            fetchQuizUseCase: FetchQuizUseCaseProviderDummy()
        )
        sut.viewModelBinder = viewModelBinderSpy
        
        // Then
        sut.toggleTimer()
        
        // When
        XCTAssertTrue(viewModelBinderSpy.showTimerFinishedModalWithDataCalled, "`showTimerFinishedModalWithData` should have been called.")
        
        XCTAssertTrue(viewModelBinderSpy.bottomButtonTitleDidChangeCalled, "`bottomButtonTitleDidChange` should have been called.")
        XCTAssertEqual(viewModelBinderSpy.titlePassedToBottomButtonTitleDidChange, "Start", "Expected `Start``, but got \(viewModelBinderSpy.titlePassedToBottomButtonTitleDidChange ?? "").")
        
        XCTAssertTrue(viewModelBinderSpy.bottomRightTextDidChangeCalled, "`bottomRightTextDidChange` should have been called.")
        XCTAssertEqual(viewModelBinderSpy.textPassedToBottomRightTextDidChange, "00:01", "Expected `00:01`, but got \(viewModelBinderSpy.textPassedToBottomRightTextDidChange ?? "").")
    }
    
    func test_whenToggleTimerIsCalledAndTimerIsRunning_timerShouldStartAndShowWinnerModal() {
        // Given
        let viewModelBinderSpy = KeywordsViewModelBindingSpy()
        let countDownTimerProviderStubSpy = CountDownTimerProviderStubSpy()
        countDownTimerProviderStubSpy.isRunningToReturn = true
        countDownTimerProviderStubSpy.runOnFinish = true
        let quizEntityToReturn = QuizEntity(
            question: "Some question",
            answer: ["a"]
        )
        let resultToReturn: Result<QuizEntity, QuizServiceError> = .success(quizEntityToReturn)
        let quizServiceStub = QuizServiceStub(resultToReturn: resultToReturn)
        let fetchQuizUseCase = FetchQuizUseCase(quizService: quizServiceStub)
        let sut = KeywordsViewModel(
            timerPeriod: 1,
            countDownTimer: countDownTimerProviderStubSpy,
            fetchQuizUseCase: fetchQuizUseCase
        )
        sut.viewModelBinder = viewModelBinderSpy
        sut.loadQuizData()
        sut.verifyTextFieldInput("a")
        
        // Then
        sut.toggleTimer()
        
        // When
        XCTAssertTrue(viewModelBinderSpy.showWinnerModalWithDataCalled, "`showWinnerModalWithData` should have been called.")
    }
    
    func test_whenToggleTimerIsCalledAndTimerIsRunning_timerShouldStartAndShowErrorModal() {
        // Given
        let viewModelBinderSpy = KeywordsViewModelBindingSpy()
        let countDownTimerProviderStubSpy = CountDownTimerProviderStubSpy()
        countDownTimerProviderStubSpy.isRunningToReturn = false
        countDownTimerProviderStubSpy.runOnFinish = true
        let quizEntityToReturn = QuizEntity(
            question: "Some question",
            answer: ["a"]
        )
        let resultToReturn: Result<QuizEntity, QuizServiceError> = .success(quizEntityToReturn)
        let quizServiceStub = QuizServiceStub(resultToReturn: resultToReturn)
        let fetchQuizUseCase = FetchQuizUseCase(quizService: quizServiceStub)
        let sut = KeywordsViewModel(
            timerPeriod: 1,
            countDownTimer: countDownTimerProviderStubSpy,
            fetchQuizUseCase: fetchQuizUseCase
        )
        sut.viewModelBinder = viewModelBinderSpy
        sut.loadQuizData()
        sut.verifyTextFieldInput("a")
        
        // Then
        sut.toggleTimer()
        
        // When
        XCTAssertTrue(viewModelBinderSpy.showErrorModalWithDataCalled, "`showErrorModalWithData` should have been called.")
    }
    
}

// MARK: - Testing Helpers

private final class FetchQuizUseCaseProviderDummy: FetchQuizUseCaseProvider {
    func execute(completion: @escaping (UseCaseEvent<QuizViewData, FetchQuizUseCaseError>) -> Void) {}
}

private final class FetchQuizUseCaseProviderSpy: FetchQuizUseCaseProvider {
    private(set) var executeCalled = false
    func execute(completion: @escaping (UseCaseEvent<QuizViewData, FetchQuizUseCaseError>) -> Void) {
        executeCalled = true
    }
}

private final class KeywordsViewModelBindingSpy: KeywordsViewModelBinding {
    
    private(set) var viewTitleDidChangeCalled = false
    private(set) var titlePassedToViewTitleDidChange: String?
    private(set) var viewTitleDidChangeValuesAcumulated = [String?]()
    func viewTitleDidChange(_ title: String?) {
        viewTitleDidChangeCalled = true
        titlePassedToViewTitleDidChange = title
        viewTitleDidChangeValuesAcumulated.append(title)
    }
    
    private(set) var textFieldPlaceholderDidChangeCalled = false
    private(set) var textPassedToTextFieldPlaceholderDidChange: String?
    private(set) var textFieldPlaceholderDidChangeValuesAcumulated = [String?]()
    func textFieldPlaceholderDidChange(_ text: String?) {
        textFieldPlaceholderDidChangeCalled = true
        textPassedToTextFieldPlaceholderDidChange = text
        textFieldPlaceholderDidChangeValuesAcumulated.append(text)
    }
    
    private(set) var bottomRightTextDidChangeCalled = false
    private(set) var textPassedToBottomRightTextDidChange: String?
    private(set) var bottomRightTextDidChangeValuesAcumulated = [String?]()
    func bottomRightTextDidChange(_ text: String?) {
        bottomRightTextDidChangeCalled = true
        textPassedToBottomRightTextDidChange = text
        bottomRightTextDidChangeValuesAcumulated.append(text)
    }
    
    private(set) var bottomLeftTextDidChangeCalled = false
    private(set) var textPassedToBottomLeftTextDidChange: String?
    private(set) var bottomLeftTextDidChangeValuesAcumulated = [String?]()
    func bottomLeftTextDidChange(_ text: String?) {
        bottomLeftTextDidChangeCalled = true
        textPassedToBottomLeftTextDidChange = text
        bottomLeftTextDidChangeValuesAcumulated.append(text)
    }
    
    private(set) var bottomButtonTitleDidChangeCalled = false
    private(set) var titlePassedToBottomButtonTitleDidChange: String?
    private(set) var bottomButtonTitleDidChangeValuesAcumulated = [String?]()
    func bottomButtonTitleDidChange(_ title: String?) {
        bottomButtonTitleDidChangeCalled = true
        titlePassedToBottomButtonTitleDidChange = title
        bottomButtonTitleDidChangeValuesAcumulated.append(title)
    }
    
    private(set) var textFieldShouldResetCalled = false
    func textFieldShouldReset() {
        textFieldShouldResetCalled = true
    }
    
    private(set) var showTimerFinishedModalWithDataCalled = false
    private(set) var modalDataPassedToShowTimerFinishedModalWithData: SimpleModalViewData?
    private(set) var showTimerFinishedModalWithDataValuesAcumulated = [SimpleModalViewData]()
    func showTimerFinishedModalWithData(_ modalData: SimpleModalViewData) {
        showTimerFinishedModalWithDataCalled = true
        modalDataPassedToShowTimerFinishedModalWithData = modalData
        showTimerFinishedModalWithDataValuesAcumulated.append(modalData)
    }
    
    private(set) var showWinnerModalWithDataCalled = false
    private(set) var modalDataPassedToShowWinnerModalWithData: SimpleModalViewData?
    private(set) var showWinnerModalWithDataValuesAcumulated = [SimpleModalViewData]()
    func showWinnerModalWithData(_ modalData: SimpleModalViewData) {
        showWinnerModalWithDataCalled = true
        modalDataPassedToShowWinnerModalWithData = modalData
        showWinnerModalWithDataValuesAcumulated.append(modalData)
    }
    
    private(set) var showErrorModalWithDataCalled = false
    private(set) var modalDataPassedToShowErrorModalWithData: SimpleModalViewData?
    private(set) var showErrorModalWithDataValuesAcumulated = [SimpleModalViewData]()
    func showErrorModalWithData(_ modalData: SimpleModalViewData) {
        showErrorModalWithDataCalled = true
        modalDataPassedToShowErrorModalWithData = modalData
        showErrorModalWithDataValuesAcumulated.append(modalData)
    }
    
}

private final class ViewStateRenderingSpy: ViewStateRendering {
    
    private(set) var renderStateCalled = false
    private(set) var lastStatePassed: ViewState?
    private(set) var allStatesPassed = [ViewState]()
    func render(_ state: ViewState) {
        renderStateCalled = true
        lastStatePassed = state
        allStatesPassed.append(state)
    }
    
}

private final class CountDownTimerProviderStubSpy: CountDownTimerProvider {
    
    private var lastTimerPeriod: Int = 0
    private var lastTimeInterval: TimeInterval = 1.0
    private var lastOnTickClosure: ((_ remainingSeconds: Int) -> Void)?
    private var lastOnFinishClosure: (() -> Void)?
    private var timerWasStopped: Bool = false
    private var timeLeft: Int = 0
    
    var runOnFinish = true
    var runOnTick = true
    private(set) var dispatchCalled = false
    private(set) var periodPassedToDispatch: Int?
    private(set) var timeIntervalPassedToDispatch: TimeInterval?
    private(set) var onTickPassedToDispatch: ((Int) -> Void)?
    private(set) var onFinishPassedToDispatch: (() -> Void)?
    func dispatch(
        forTimePeriodInSeconds period: Int,
        timeInterval: TimeInterval = 1.0,
        onTick: ((Int) -> Void)?,
        onFinish: (() -> Void)?
    ) {
        
        // Spy Logic
        dispatchCalled = true
        periodPassedToDispatch = period
        timeIntervalPassedToDispatch = timeInterval
        onTickPassedToDispatch = onTick
        onFinishPassedToDispatch = onFinish
        
        // Stub Logic
        timeLeft = period
        lastTimerPeriod = period
        lastTimeInterval = timeInterval
        lastOnTickClosure = onTick
        lastOnFinishClosure = onFinish
        isRunningToReturn = true
        
        if runOnTick {
            let step = Int(timeInterval)
            for x in stride(from: period, to: 0, by: -step) {
                if stopCalled {
                    return
                }
                timeLeft = x
                if timeLeft <= 0 {
                    stop()
                    onFinish?()
                    return
                }
                onTick?(x)
            }
        }
       
        if runOnFinish {
            onFinish?()
        }
        
    }
    
    private(set) var restartCalled = false
    func restart() {
        
        // Spy Logic
        restartCalled = true
        
        // Stub Logic
        isRunningToReturn = false
        timeLeft = lastTimerPeriod
        
        dispatch(
            forTimePeriodInSeconds: lastTimerPeriod,
            timeInterval: lastTimeInterval,
            onTick: lastOnTickClosure,
            onFinish: lastOnFinishClosure
        )
        
    }
    
    private(set) var stopCalled = false
    func stop() {
        // Spy Logic
        stopCalled = true
        isRunningToReturn = false
    }
    
    var isRunningToReturn: Bool?
    var isRunning: Bool {
        if stopCalled { return false }
        return isRunningToReturn ?? false
    }
    
}

private class CountRightAnswersUseCaseProviderStub: CountRightAnswersUseCaseProvider {
    
    var numberOfRightAnswersToReturn = 0
    func execute(input: String?) -> Int {
        return numberOfRightAnswersToReturn
    }
    
}
