//
//  KeywordsConfigurator.swift
//  QuizChallenge
//
//  Created by Eduardo Sanches Bocato on 21/09/19.
//  Copyright © 2019 Bocato. All rights reserved.
//

import UIKit

protocol KeywordsFactoryProtocol {
    
    /// Creates a new instance of KeywordsViewController with all it's dependecies
    func makeKeywordsViewController() -> KeywordsViewController
}
