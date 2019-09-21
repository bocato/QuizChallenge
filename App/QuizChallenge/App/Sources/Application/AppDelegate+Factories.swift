//
//  AppDelegate+Factories.swift
//  QuizChallenge
//
//  Created by Eduardo Sanches Bocato on 21/09/19.
//  Copyright © 2019 Bocato. All rights reserved.
//

import UIKit

// This could be done elsewere, but since it's a simple application, i'll put it here for now.
extension AppDelegate: KeywordsFactoryProtocol {
    func makeKeywordsViewController() -> KeywordsViewController {
        let viewModel = KeywordsViewModel()
        return KeywordsViewController(viewModel: viewModel)
    }
}
