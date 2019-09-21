//
//  FetchQuizUseCase.swift
//  QuizChallenge
//
//  Created by Eduardo Sanches Bocato on 21/09/19.
//  Copyright © 2019 Bocato. All rights reserved.
//

import Foundation

/// Defines an error for this domain
enum FetchQuizUseCaseError: Error {}

// Defines a command to request the Quiz data
protocol FetchQuizUseCaseProvider {
    
    /// Fetches the data for the QuizView
    ///
    /// - Parameter completion: async response for the QuizView
    func execute(completion: @escaping (UseCaseEvent<QuizViewData, FetchQuizUseCaseError>) -> Void)
}

final class FetchQuizUseCase: FetchQuizUseCaseProvider {
    
    // MARK: - Dependencies
    
    let quizService: QuizServiceProvider
    
    // MARK: - Initialization
    
    init(quizService: QuizServiceProvider) {
        self.quizService = quizService
    }
    
    // MARK: - Public Functions
    
    func execute(completion: @escaping (UseCaseEvent<QuizViewData, FetchQuizUseCaseError>) -> Void) {
        completion(.loading())
        quizService.getQuiz { (result) in
            do {
                let response = try result.get()
                let items = response.answer.map { QuizViewData.Item(text: $0) }
                let viewData = QuizViewData(title: response.question, items: items)
                completion(.data(viewData))
            } catch {
                completion(.serviceError(error))
            }
        }
    }
    
}
