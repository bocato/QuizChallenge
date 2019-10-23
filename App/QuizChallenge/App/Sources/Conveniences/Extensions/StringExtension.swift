//
//  StringExtension.swift
//  QuizChallenge
//
//  Created by Eduardo Sanches Bocato on 21/09/19.
//  Copyright © 2019 Bocato. All rights reserved.
//

import Foundation

extension String {
    
    /// Capitalizes the first letter of itself
    ///
    /// - Returns: itself, in order to continue manupilating it (suggar sintax)
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }
    
    /// Capitalizes the first letter of itself
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
    
}
