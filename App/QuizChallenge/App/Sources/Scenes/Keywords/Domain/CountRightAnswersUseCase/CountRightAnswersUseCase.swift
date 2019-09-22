//
//  CheckForRightAnswersUseCase.swift
//  QuizChallenge
//
//  Created by Eduardo Sanches Bocato on 22/09/19.
//  Copyright © 2019 Bocato. All rights reserved.
//

import Foundation

protocol CountRightAnswersUseCaseProtocol {
    func execute(input: String) -> Int
}

final class CountRightAnswersUseCase: CountRightAnswersUseCaseProtocol {
    
    private let possibleAnswers: [QuizViewData.Item]
    private var userAnswers = [String]()
    
    init(possibleAnswers: [QuizViewData.Item] = []) {
        self.possibleAnswers = possibleAnswers
    }
    
    func execute(input: String) -> Int {
        let capitalizedInput = input.capitalized
        let containsInput = possibleAnswers.contains(where: { $0.text.capitalized == capitalizedInput })
        let isNotOnUserAnswers = userAnswers.contains(where: { $0 == capitalizedInput } ) == false
        if containsInput && isNotOnUserAnswers {
            userAnswers.append(capitalizedInput)
        }
        return userAnswers.count
    }
    
}
