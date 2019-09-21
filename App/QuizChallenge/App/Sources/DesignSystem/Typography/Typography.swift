//
//  Typography.swift
//  QuizChallenge
//
//  Created by Eduardo Sanches Bocato on 21/09/19.
//  Copyright © 2019 Bocato. All rights reserved.
//

import UIKit

enum Typography {
    
    // MARK: - Types
    
    case largeTitle
    case body
    case button
    
    // MARK: - Properties
    
    var font: UIFont {
        switch self {
        case .largeTitle:
            return UIFont.sfPro(ofSize: 34, weight: .bold)
        case .body:
            return UIFont.sfPro(ofSize: 17, weight: .regular)
        case .button:
            return UIFont.sfPro(ofSize: 17, weight: .semibold)
        }
    }
    
}
