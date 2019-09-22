//
//  KeywordsViewModel.swift
//  QuizChallenge
//
//  Created by Eduardo Sanches Bocato on 21/09/19.
//  Copyright © 2019 Bocato. All rights reserved.
//

import Foundation

protocol KeywordsViewModelBinding: AnyObject {
    func viewTitleDidChange(_ title: String?)
    func textFieldPlaceholderDidChange(_ text: String?)
    func bottomRightTextDidChange(_ text: String?)
    func bottomLeftTextDidChange(_ text: String?)
    func bottomButtonTitleDidChange(_ title: String?)
    func shouldShowTimerFinishedModalWithData(_ modalData: SimpleModalViewData)
}

protocol KeywordsViewModelDisplayLogic {
    var numberOfAnswers: Int { get }
    func answerItem(at index: Int) -> QuizViewData.Item
    func onViewDidLoad()
}

protocol KeywordsViewModelBusinessLogic {
    func loadQuizData()
    func toggleTimer()
    func resetQuiz()
    func verifyTextFieldInput(_ input: String)
}

final class KeywordsViewModel: KeywordsViewModelDisplayLogic {
    
    // MARK: - Dependencies
    
    let timerPeriod: Int
    let countDownTimer: CountDownTimerProtocol
    let fetchQuizUseCase: FetchQuizUseCaseProvider
    let countDownFormatter: CountDownFormatting
    
    // MARK: - Binding
    
    weak var viewStateRenderer: ViewStateRendering?
    weak var viewModelBinder: KeywordsViewModelBinding?
    
    // MARK: - Private Properties
    
    private var possibleAnswers = [QuizViewData.Item]()
    private var userAnswers = [String]()
    
    // MARK: - View Properties / Binding
    
    private var viewTitle: String? {
        didSet {
            viewModelBinder?.viewTitleDidChange(viewTitle)
        }
    }
    private var textFieldPlaceholder: String? {
        didSet {
            viewModelBinder?.textFieldPlaceholderDidChange(textFieldPlaceholder)
        }
    }
    private var bottomRightText: String? {
        didSet {
            viewModelBinder?.bottomRightTextDidChange(bottomRightText)
        }
    }
    private var bottomLeftText: String? {
        didSet {
            viewModelBinder?.bottomLeftTextDidChange(bottomLeftText)
        }
    }
    private var bottomButtonTitle: String? {
        didSet {
            viewModelBinder?.bottomButtonTitleDidChange(bottomButtonTitle)
        }
    }
    
    // MARK: - Initialization
    
    init(
        timerPeriod: Int = 5,//300,
        countDownTimer: CountDownTimerProtocol = CountDownTimer(),
        fetchQuizUseCase: FetchQuizUseCaseProvider,
        countDownFormatter: CountDownFormatting = CountDownFormatter()
    ) {
        self.timerPeriod = timerPeriod
        self.countDownTimer = countDownTimer
        self.fetchQuizUseCase = fetchQuizUseCase
        self.countDownFormatter = countDownFormatter
    }
    
    // MARK: - Display Logic
    
    func onViewDidLoad() {
        viewTitle = ""
        textFieldPlaceholder = "Insert Word"
        bottomButtonTitle = "Start"
        bottomLeftText = "00/00"
        bottomRightText = countDownFormatter.formatToMinutes(from: timerPeriod)
        loadQuizData()
    }
    
    var numberOfAnswers: Int {
        return possibleAnswers.count
    }
    
    func answerItem(at index: Int) -> QuizViewData.Item {
        return possibleAnswers[index]
    }
    
}

// MARK: - KeywordsViewModelBusinessLogic
extension KeywordsViewModel: KeywordsViewModelBusinessLogic {
    
    func loadQuizData() {
        fetchQuizUseCase.execute { [weak self] event in
            switch event.status {
            case let .data(viewData):
                self?.handleViewData(viewData)
            case let .serviceError(serviceError):
                self?.handleServiceError(serviceError)
            case .loading:
                self?.viewStateRenderer?.render(.loading)
            default:
                return
            }
        }
    }
    
    func toggleTimer() {
        if countDownTimer.isRunning {
            countDownTimer.restart()
        } else {
            startTimer()
        }
    }
    
    func resetQuiz() {
        resetTimerInfo()
        loadQuizData()
    }
    
    func verifyTextFieldInput(_ input: String) {
        let capitalizedInput = input.capitalized
        let containsInput = possibleAnswers.contains(where: { $0.text.capitalized == capitalizedInput })
        let isNotOnUserAnswers = userAnswers.contains(where: { $0 == capitalizedInput } ) == false
        if containsInput && isNotOnUserAnswers {
            userAnswers.append(capitalizedInput)
        }
    }
    
    // MARK: - FetchQuizUseCase Handlers
    
    private func handleViewData(_ viewData: QuizViewData) {
        viewTitle = viewData.title
        possibleAnswers = viewData.items
        bottomLeftText = "00/\(viewData.items.count)"
        viewStateRenderer?.render(.content)
    }
    
    private func handleServiceError(_ error: Error) {
        let filler = ViewFiller(title: "Ooops!", subtitle: "Something wrong has happened")
        viewStateRenderer?.render(.error(withFiller: filler))
    }
    
    // MARK: - Timer Logic
    
    private func startTimer() {
        
        bottomButtonTitle = "Reset"
        
        let onTick: CountDownTimerProtocol.OnTickClosure = { [weak self] timeLeft in
            self?.bottomRightText = self?.countDownFormatter.formatToMinutes(from: timeLeft)
        }
        
        let onFinish: CountDownTimerProtocol.OnFinishClosure = { [weak self] in
            self?.handleTimerFinish()
        }
        
        countDownTimer.dispatch(
            for: timerPeriod,
            timeInterval: 1.0,
            onTick: onTick,
            onFinish: onFinish
        )
        
    }
    
    private func handleTimerFinish() {
        let message = self.buildTimerModalData()
        self.viewModelBinder?.shouldShowTimerFinishedModalWithData(message)
        resetTimerInfo()
    }
    
    private func resetTimerInfo() {
        self.bottomButtonTitle = "Start"
        self.bottomRightText = self.countDownFormatter.formatToMinutes(from: self.timerPeriod)
    }
    
    private func buildTimerModalData() -> SimpleModalViewData {
        let title = "Time finished"
        let subtitle = "Sorry, time is up! You got \(userAnswers.count) out of \(possibleAnswers.count) answers."
        let buttonText = "Try Again"
        return SimpleModalViewData(
            title: title,
            subtitle: subtitle,
            buttonText: buttonText
        )
    }
    
}
