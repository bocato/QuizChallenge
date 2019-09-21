//
//  KeywordsViewModel.swift
//  QuizChallenge
//
//  Created by Eduardo Sanches Bocato on 21/09/19.
//  Copyright © 2019 Bocato. All rights reserved.
//

import Foundation

protocol KeywordsViewModelDelegate: ViewStateRendering, AnyObject {
    func renderTitle(_ title: String)
}

final class KeywordsViewModel {
    
    // MARK: - Dependencies
    
    let countDownTimer: CountDownTimerProtocol
    let fetchQuizUseCase: FetchQuizUseCaseProvider
    
    // MARK: - Properties
    
    weak var delegate: KeywordsViewModelDelegate?
    
    // MARK: - Private Properties
    
    private var answers = [QuizViewData.Item]()
    
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
        delegate?.render(.loading)
    }
    
    func loadQuizData() {
        fetchQuizUseCase.execute { [weak self] event in
            switch event.status {
            case let .data(viewData):
                self?.handleViewData(viewData)
            case let .serviceError(serviceError):
                self?.handleServiceError(serviceError)
            case .loading:
                self?.delegate?.render(.loading)
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
        delegate?.renderTitle(viewData.title)
        answers = viewData.items
        delegate?.render(.content)
    }
    
    private func handleServiceError(_ error: Error) {
        
    }
    
}
