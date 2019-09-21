//
//  StackViewBuilder.swift
//  QuizChallenge
//
//  Created by Eduardo Sanches Bocato on 21/09/19.
//  Copyright © 2019 Bocato. All rights reserved.
//

import UIKit

// Helper class simplify building StackViews
final class StackViewBuilder {
    
    public var axis: NSLayoutConstraint.Axis = .vertical
    public var alignment: UIStackView.Alignment = .fill
    public var spacing: CGFloat = 0.0
    public var distribution: UIStackView.Distribution = .fillProportionally
    public var arrangedSubviews: [UIView] = []
    
    public typealias BuilderClosure = (StackViewBuilder) -> Void
    
    public init(buildClosure: BuilderClosure) {
        buildClosure(self)
    }
    
    public func build() -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: arrangedSubviews)
        stackView.axis = axis
        stackView.alignment = alignment
        stackView.spacing = spacing
        stackView.distribution = distribution
        return stackView
    }
}
