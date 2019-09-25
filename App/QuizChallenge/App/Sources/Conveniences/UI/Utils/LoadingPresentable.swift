//
//  UIView+Loading.swift
//  QuizChallenge
//
//  Created by Eduardo Sanches Bocato on 22/09/19.
//  Copyright © 2019 Bocato. All rights reserved.
//

import UIKit

protocol LoadingPresentable {
    func showLoading()
    func hideLoading()
}
extension LoadingPresentable where Self: UIViewController {

    /// Shows a loading view on top oa some ViewControler
    func showLoading() {
        let loadingView = QuizLoadingView(frame: view.frame)
        loadingView.text = "Loading..."
        view.addSubview(loadingView)
        loadingView.startAnimating()
    }

    /// Tries to hide the loadingView that is visible
    func hideLoading() {
        DispatchQueue.main.async {
            let loadingView = self.view.viewWithTag(QuizLoadingView.tag)
            UIView.animate(withDuration: 0.25, animations: {
                loadingView?.alpha = 0
            }, completion: { completed in
                if completed {
                    (loadingView as? QuizLoadingView)?.stopAnimating()
                    loadingView?.removeFromSuperview()
                }
            })
        }
    }

}
