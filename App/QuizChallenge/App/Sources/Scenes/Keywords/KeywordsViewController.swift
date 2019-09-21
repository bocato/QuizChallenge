//
//  KeywordsViewController.swift
//  QuizChallenge
//
//  Created by Eduardo Sanches Bocato on 21/09/19.
//  Copyright © 2019 Bocato. All rights reserved.
//

import UIKit

final class KeywordsViewController: UIViewController, CustomViewController {
    
    // MARK: - Aliases
    
    typealias CustomView = KeywordsView
    
    // MARK: - Properties
    
    let viewModel: KeywordsViewModel
    
    // MARK: - Initialization
    
    init(viewModel: KeywordsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func loadView() {
        setupCustomView()
    }
    
    private func setupCustomView () {
        
        let refreshControllAction: (() -> Void) = {
            debugPrint("refreshControllAction")
        }
        
        let bottomViewButtonAction: (() -> Void) = {
            debugPrint("bottomViewButtonAction")
        }
        
        view = CustomView(
            refreshControllAction: refreshControllAction,
            bottomViewButtonAction: bottomViewButtonAction
        )
    }

}
