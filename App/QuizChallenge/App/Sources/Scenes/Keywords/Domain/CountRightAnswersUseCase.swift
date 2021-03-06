//
//  CheckForRightAnswersUseCase.swift
//  QuizChallenge
//
//  Created by Eduardo Sanches Bocato on 22/09/19.
//  Copyright © 2019 Bocato. All rights reserved.
//

import Foundation

/// Provides an interface for the CountRightAnswersUseCase
protocol CountRightAnswersUseCaseProvider {
    
    /// Counts the number of answers that were found in the `possibleAnswers`, based on the inputs received
    ///
    /// - Parameter input: a String value, from the user input
    /// - Returns: the number of answers that were found in the `possibleAnswers`
    func execute(input: String?) -> Int
}

final class CountRightAnswersUseCase: CountRightAnswersUseCaseProvider {
    
    private let possibleAnswers: [QuizViewData.Item]
    private var userAnswers = [String]()
    
    init(possibleAnswers: [QuizViewData.Item] = []) {
        self.possibleAnswers = possibleAnswers
    }
    
    func execute(input: String?) -> Int {
        guard let input = input else { return userAnswers.count }
        let capitalizedInput = input.capitalized
        let containsInput = possibleAnswers.contains(where: { $0.text.capitalized == capitalizedInput })
        let isNotOnUserAnswers = userAnswers.contains(where: { $0 == capitalizedInput } ) == false
        if containsInput && isNotOnUserAnswers {
            userAnswers.append(capitalizedInput)
        }
        return userAnswers.count
    }
    
}
