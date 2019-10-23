//
//  UIFont+Quiz.swift
//  QuizChallenge
//
//  Created by Eduardo Sanches Bocato on 21/09/19.
//  Copyright © 2019 Bocato. All rights reserved.
//

import UIKit

// MARK: - Custom Font
extension UIFont {
    
    /// Static function that creates a SF Pro font
    ///
    /// - Parameters:
    ///   - fontSize: Font size
    ///   - weight: Font weight
    /// - Returns: SF Pro Font with specified parameters
    class func sfPro(ofSize fontSize: CGFloat, weight: UIFont.QuizWeight) -> UIFont {
        guard let sfProFont = UIFont(name: weight.fontName, size: fontSize) else {
            debugPrint("Failed to load SF Pro Font.")
            return UIFont.systemFont(ofSize: fontSize, weight: weight.asUIFontWeight)
        }
        return sfProFont
    }
    
}

// MARK: - Weight
extension UIFont {
    
    /// Defines font weight
    ///
    /// - regular: Regular weight
    /// - bold: Bold Font
    /// - semibold: Semibold weight
    enum QuizWeight {
        
        // MARK: - Types
        
        case regular
        case bold
        case semibold
        
        // MARK: - Internal Properties
        
        fileprivate var fontName: String {
            switch self {
            case .regular: return "SFProDisplay-Regular"
            case .bold: return "SFProDisplay-Bold"
            case .semibold: return "SFProDisplay-Semibold"
            }
        }
        
        fileprivate var asUIFontWeight: UIFont.Weight {
            switch self {
            case .regular: return .regular
            case .bold: return .bold
            case .semibold: return .semibold
            }
        }
        
    }
    
}
