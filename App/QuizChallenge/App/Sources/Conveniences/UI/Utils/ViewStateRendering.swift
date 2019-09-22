//
//  ViewStateRendering.swift
//  QuizChallenge
//
//  Created by Eduardo Sanches Bocato on 21/09/19.
//  Copyright © 2019 Bocato. All rights reserved.
//

import UIKit

/// Defines an struct to fill the view on some states
struct ViewFiller {
    
    let title: String
    let subtitle: String?
    let image: UIImage?
    
    init(title: String, subtitle: String? = nil, image: UIImage? = nil) {
        self.title = title
        self.subtitle = subtitle
        self.image = image
    }
    
}

/// Defines the possible states of a view
///
/// - loading: showing some kind of loader
/// - content: showing the expected content
/// - error: describing some error for the user
/// - empty: describing an empty state
enum ViewState {
    case loading
    case content
    case error(withFiller: ViewFiller?)
    case empty(withFiller: ViewFiller?)
}

/// Defines that some view will need to render states
protocol ViewStateRendering: AnyObject {
    
    /// Renders some state on the view
    ///
    /// - Parameter state: the state to be rendered
    func render(_ state: ViewState)
}
