//
//  Metrics.swift
//  QuizChallenge
//
//  Created by Eduardo Sanches Bocato on 21/09/19.
//  Copyright © 2019 Bocato. All rights reserved.
//

import UIKit

struct Metrics {
    
    private init() {}
    
    struct Margin {
        
        private init() {}
        
        /// 0 points of spacing.
        static let none: CGFloat = 0
        
        /// 16 points of spacing.
        static let `default`: CGFloat = 16.0
        
        /// 44 points of spacing.
        static let top: CGFloat = 44.0
        
        /// 4 points of spacing
        static let tiny: CGFloat = 4.0
    }
    
    struct Height {
        
        private init() {}
        
        /// Default button height, 54 points
        static let fatButton: CGFloat = 54.0
        
        // Default TextField height, 60 points
        static let textField: CGFloat = 54.0
    }
    
}
