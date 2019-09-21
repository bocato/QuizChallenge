//
//  AppDelegate+Factories.swift
//  QuizChallenge
//
//  Created by Eduardo Sanches Bocato on 21/09/19.
//  Copyright © 2019 Bocato. All rights reserved.
//

import UIKit
import Networking

// This could be done elsewere, but since it's a simple application, i'll put it here for now.
// Also, we could implement a more intricate system/strategy for depency injection with containers or something else.
extension AppDelegate: KeywordsFactoryProtocol {
    
    func makeKeywordsViewController() -> KeywordsViewController {
        
        let countDownTimer = CountDownTimer()
        
        let dispatcher = URLSessionDispatcher()
        let quizService = QuizService(dispatcher: dispatcher)
        let fetchQuizUseCase = FetchQuizUseCase(quizService: quizService)
        
        let viewModel = KeywordsViewModel(countDownTimer: countDownTimer, fetchQuizUseCase: fetchQuizUseCase)
        
        let viewController = KeywordsViewController(viewModel: viewModel)
        viewModel.viewStateRenderer = viewController
        viewModel.viewModelBinder = viewController
        
        return viewController
    }
    
}
