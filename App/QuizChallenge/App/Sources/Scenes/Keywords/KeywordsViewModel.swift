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
}

final class KeywordsViewModel: KeywordsViewModelDisplayLogic {
    
    // MARK: - Dependencies
    
    let countDownTimer: CountDownTimerProtocol
    let fetchQuizUseCase: FetchQuizUseCaseProvider
    let countDownFormatter: CountDownFormatting
    
    // MARK: - Binding
    
    weak var viewStateRenderer: ViewStateRendering?
    weak var viewModelBinder: KeywordsViewModelBinding?
    
    // MARK: - Private Properties
    
    private var possibleAnswers = [QuizViewData.Item]()
    private var isTimerRunning = false
    
    // MARK: - View Properties / Binding
    
    private var viewTitle: String? {
        didSet {
            viewModelBinder?.viewTitleDidChange(viewTitle)
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
        countDownTimer: CountDownTimerProtocol = CountDownTimer(),
        fetchQuizUseCase: FetchQuizUseCaseProvider,
        countDownFormatter: CountDownFormatting = CountDownFormatter()
    ) {
        self.countDownTimer = countDownTimer
        self.fetchQuizUseCase = fetchQuizUseCase
        self.countDownFormatter = countDownFormatter
    }
    
    // MARK: - Display Logic
    
    func onViewDidLoad() {
        bottomButtonTitle = "Reset"
        bottomLeftText = "0/50"
        bottomRightText = "05:00"
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
    
    // MARK: - FetchQuizUseCase Handlers
    
    private func handleViewData(_ viewData: QuizViewData) {
        viewTitle = viewData.title
        possibleAnswers = viewData.items
        bottomRightText = "00/\(viewData.items.count)"
        viewStateRenderer?.render(.content)
    }
    
    private func handleServiceError(_ error: Error) {
        let filler = ViewFiller(title: "Ooops!", subtitle: "Something wrong has happened")
        viewStateRenderer?.render(.error(withFiller: filler))
    }
    
    // MARK: - Timer Logic
    
    private func startTimer() {
        
        let timeLeft = 60 * 5
        
        let onTick: CountDownTimerProtocol.OnTickClosure = { [weak self] timeLeft in
            self?.bottomRightText = self?.countDownFormatter.formatToMinutes(from: timeLeft)
        }
        
        let onFinish: CountDownTimerProtocol.OnFinishClosure = { [weak self] in
            guard let self = self else { return }
            let message = self.buildTimerModalData()
            self.viewModelBinder?.shouldShowTimerFinishedModalWithData(message)
        }
        
        countDownTimer.dispatch(
            for: timeLeft,
            timeInterval: 1.0,
            onTick: onTick,
            onFinish: onFinish
        )
        
    }
    
    private func buildTimerModalData() -> SimpleModalViewData {
        let rightAnswers = 40 // TODO: CHANGE TO REAL DATA
        let title = "Time finished"
        let subtitle = "Sorry, time is up! You got \(rightAnswers) out of \(possibleAnswers.count) answers."
        let buttonText = "Try Again"
        return SimpleModalViewData(
            title: title,
            subtitle: subtitle,
            buttonText: buttonText
        )
    }
    
}
