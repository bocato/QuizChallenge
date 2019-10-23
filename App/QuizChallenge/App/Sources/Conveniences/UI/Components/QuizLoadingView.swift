//
//  QuizLoadingView.swift
//  QuizChallenge
//
//  Created by Eduardo Sanches Bocato on 22/09/19.
//  Copyright © 2019 Bocato. All rights reserved.
//

import UIKit

/// Defines a loadingView for the quiz
final class QuizLoadingView: UIView {
    
    // MARK: - Constants
    
    static let tag = 11111
    private let roundedCornerContainerSide: CGFloat = 150
    
    // MARK: - UI
    
    private lazy var blurView: UIView = {
        let view = UIView(frame: frame)
        view.backgroundColor = .black
        view.alpha = 0.5
        return view
    }()
    
    private lazy var roundedCornerContainer: UIView = {
        let view = UIView(frame: .zero)
        view.layer.masksToBounds = true
        view.clipsToBounds = true
        view.layer.cornerRadius = 12
        view.backgroundColor = .black
        view.alpha = 0.9
        return view
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .whiteLarge)
        view.color = .quizGray
        return view
    }()
    
    private lazy var textLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textAlignment = .center
        label.apply(typography: .body, with: .quizGray)
        label.textColor = .quizGray
        label.numberOfLines = 0
        label.text = "Loading..."
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        return StackViewBuilder {
            $0.arrangedSubviews = [
                self.activityIndicator,
                self.textLabel
            ]
            $0.spacing = Metrics.Margin.default
            $0.axis = .vertical
            $0.alignment = .fill
            $0.distribution = .fill
        }.build()
    }()
    
    // MARK: - Properties
    var text: String? {
        didSet {
            textLabel.isHidden = text == nil
            textLabel.text = text
        }
    }
    
    // MARK: - Life Cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: - Setup
    
    private func setup() {
        tag = QuizLoadingView.tag
        addSubviews()
    }
    
    // MARK: - Layout
    
    private func addSubviews() {
        constrainBlurView()
        constrainRoundedCornerContainer()
        constrainStackView()
    }
    
    private func constrainBlurView() {
        addSubview(blurView)
        blurView.anchor(
            top: topAnchor,
            left: leftAnchor,
            bottom: bottomAnchor,
            right: rightAnchor
        )
    }
    
    private func constrainRoundedCornerContainer() {
        addSubview(roundedCornerContainer)
        roundedCornerContainer.anchorCenterSuperview()
        roundedCornerContainer.heightAnchor.constraint(equalToConstant: roundedCornerContainerSide).isActive = true
        roundedCornerContainer.widthAnchor.constraint(equalToConstant: roundedCornerContainerSide).isActive = true
    }
    
    func constrainStackView() {
        roundedCornerContainer.addSubview(stackView)
        stackView.anchorCenterSuperview()
        stackView.widthAnchor.constraint(equalToConstant: roundedCornerContainerSide).isActive = true
        stackView.heightAnchor.constraint(lessThanOrEqualToConstant: roundedCornerContainerSide).isActive = true
    }

    // MARK: - Public Functions

    /// Starts the loading animation
    public func startAnimating() {
        activityIndicator.startAnimating()
    }

    /// Stops the loading animation
    public func stopAnimating() {
        activityIndicator.stopAnimating()
    }
    
}
