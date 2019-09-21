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
}

final class KeywordsViewModel {
    
    // MARK: - Dependencies
    let countDownTimer: CountDownTimerProtocol
    let fetchQuizUseCase: FetchQuizUseCaseProvider
    weak var viewStateRenderer: ViewStateRendering?
    weak var viewModelBinder: KeywordsViewModelBinding?
    
    // MARK: - Properties
    
    
    // MARK: - Private Properties
    
    private var answers = [QuizViewData.Item]()
    
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
    
    // MARK: - Computed Properties
    
    var numberOfAnswers: Int {
        return answers.count
    }
    
    // MARK: - Initialization
    
    init(
        countDownTimer: CountDownTimerProtocol = CountDownTimer(),
        fetchQuizUseCase: FetchQuizUseCaseProvider
    ) {
        self.countDownTimer = countDownTimer
        self.fetchQuizUseCase = fetchQuizUseCase
    }
    
    
    // MARK: - Public Functions
    
    func onViewDidLoad() {
        bottomButtonTitle = "Reset"
        bottomLeftText = "0/50"
        bottomRightText = "05:00"
        loadQuizData()
    }
    
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
    
    func answerItem(at index: Int) -> QuizViewData.Item {
        return answers[index]
    }
    
    // MARK: - FetchQuizUseCase Handlers
    
    private func handleViewData(_ viewData: QuizViewData) {
        viewTitle = viewData.title
        answers = viewData.items
        bottomRightText = "00/\(viewData.items.count)"
        viewStateRenderer?.render(.content)
    }
    
    private func handleServiceError(_ error: Error) {
        let filler = ViewFiller(title: "Ooops!", subtitle: "Something wrong has happened")
        viewStateRenderer?.render(.error(withFiller: filler))
    }
    
    
    
}
