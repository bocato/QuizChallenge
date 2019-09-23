//
//  UITextFieldExtension.swift
//  QuizChallenge
//
//  Created by Eduardo Sanches Bocato on 21/09/19.
//  Copyright © 2019 Bocato. All rights reserved.
//

import UIKit

extension UITextField {
    
    /// Adds a padding to the textfield
    ///
    /// - Parameters:
    ///   - left: the left padding size
    ///   - right: the right padding size
    /// - Returns: itself, in order to continue configurating whatever is needed (suggar sintax)
    @discardableResult
    func addPadding(left: CGFloat = .zero, right: CGFloat = .zero) -> Self {
        
        if left > 0 {
            let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: left, height: frame.height))
            leftView = leftPaddingView
            leftViewMode = .always
        }
        
        if right > 0 {
            let rightPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: right, height: frame.height))
            rightView = rightPaddingView
            rightViewMode = .always
        }
        
        return self
        
    }
    
}


