//
//  CustomViewController.swift
//  QuizChallenge
//
//  Created by Eduardo Sanches Bocato on 21/09/19.
//  Copyright © 2019 Bocato. All rights reserved.
//

import UIKit

/// Defines a ViewController with a custom view
protocol CustomViewController {
    associatedtype CustomView: UIView
}

extension CustomViewController where Self: UIViewController {
    var customView: CustomView {
        guard let customView = view as? CustomView else {
            fatalError("Expected this view controller's view to be of type \(CustomView.self) but got \(type(of: view))")
        }
        return customView
    }
}
