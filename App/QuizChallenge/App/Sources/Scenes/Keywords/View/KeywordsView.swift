//
//  KeywordsView.swift
//  QuizChallenge
//
//  Created by Eduardo Sanches Bocato on 21/09/19.
//  Copyright © 2019 Bocato. All rights reserved.
//

import UIKit

final class KeywordsView: UIView {
    
    // MARK: - Public Properties

    var bottomView: KeywordsBottomViewProtocol {
        return _bottomView
    }
    
    // MARK: - Private Properties
    
    private var refreshControllAction: (() -> Void)
    private var bottomViewButtonAction: (() -> Void)

    // MARK: UI
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        return label
    }()
    
    private lazy var textField: UITextField = {
        let textField = UITextField(frame: .zero)
        textField.borderStyle = .roundedRect
        textField.placeholder = "Insert Word"
        textField.anchor(heightConstant: Metrics.Height.textField)
        return textField
    }()
    
    private let refreshControl = UIRefreshControl()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshControllDidChangeValue), for: .valueChanged)
        
        tableView.keyboardDismissMode = UIScrollView.KeyboardDismissMode.onDrag
        
        // layout
        tableView.estimatedRowHeight = 50.0
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .singleLine
        
        return tableView
    }()
    
    private lazy var listContainerStackView: UIStackView = {
        return StackViewBuilder {
            $0.arrangedSubviews = [
                self.titleLabel,
                self.textField,
                self.tableView
            ]
            $0.axis = .vertical
            $0.distribution = .fillProportionally
        }.build()
    }()
    
    private lazy var _bottomView: KeywordsBottomView = {
        let view = KeywordsBottomView(buttonAction: bottomViewButtonAction)
        return view
    }()
    
    // MARK: - Initialization
    
    init(
        refreshControllAction: @escaping (() -> Void),
        bottomViewButtonAction: @escaping (() -> Void)
    ) {
        self.refreshControllAction = refreshControllAction
        self.bottomViewButtonAction = bottomViewButtonAction
        super.init(frame: .zero)
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    private func setup() {
        
    }
    
    // MARK: - Layout
    
    private func addSubViews() {
        constrainBottomView()
        constrainListContainerStackView()
    }
    
    private func constrainBottomView() {
        addSubview(_bottomView)
        _bottomView.anchor(
            left: leftAnchor,
            bottom: bottomAnchor,
            right: rightAnchor,
            heightConstant: 150
        )
    }
    
    private func constrainListContainerStackView() {
        addSubview(listContainerStackView)
        listContainerStackView.anchor(
            bottom: _bottomView.topAnchor,
            topConstant: Metrics.Margin.default,
            leftConstant: Metrics.Margin.default,
            rightConstant: Metrics.Margin.default
        )
    }
    
    // MARK: - Actions
    
    @objc private func refreshControllDidChangeValue() {
        refreshControl.beginRefreshing()
        ThreadUtils.runAfterDelay(1) {
            self.refreshControllAction()
        }
    }

}
