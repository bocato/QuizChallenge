//
//  NSObjectExtension.swift
//  QuizChallenge
//
//  Created by Eduardo Sanches Bocato on 21/09/19.
//  Copyright © 2019 Bocato. All rights reserved.
//

import Foundation

extension NSObject {
    
    /// Returns the classes name 
    static var className: String {
        return String(describing: self)
    }
    
}
