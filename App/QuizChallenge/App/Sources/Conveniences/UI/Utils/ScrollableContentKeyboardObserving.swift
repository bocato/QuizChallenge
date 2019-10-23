//
//  KeyboardObserving.swift
//  QuizChallenge
//
//  Created by Eduardo Sanches Bocato on 22/09/19.
//  Copyright © 2019 Bocato. All rights reserved.
//

import UIKit

protocol ScrollableContentKeyboardObserving {
    func observeKeyboardWillShowNotification(_ scrollView: UIScrollView, onShowHandler onShow: ((CGSize?) -> Void)?)
    func observeKeyboardWillHideNotification(_ scrollView: UIScrollView, onHideHandler onHide: ((CGSize?) -> Void)?)
}
extension ScrollableContentKeyboardObserving {
    
    func observeKeyboardWillShowNotification(_ scrollView: UIScrollView, onShowHandler onShow: ((CGSize?) -> Void)? = nil) {
        _ = NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: nil, using: { notification -> Void in
            let userInfo = notification.userInfo!
            guard let keyboardFrameEndUserInfoKey = userInfo[UIResponder.keyboardFrameEndUserInfoKey] else { return }
            let keyboardSize = (keyboardFrameEndUserInfoKey as AnyObject).cgRectValue.size
            let contentInsets = UIEdgeInsets(top: scrollView.contentInset.top, left: scrollView.contentInset.left, bottom: keyboardSize.height, right: scrollView.contentInset.right)
            
            scrollView.setContentInsetAndScrollIndicatorInsets(contentInsets)
            onShow?(keyboardSize)
        })
    }
    
    func observeKeyboardWillHideNotification(_ scrollView: UIScrollView, onHideHandler onHide: ((CGSize?) -> Void)? = nil) {
        _ = NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: nil, using: { notification -> Void in
            let userInfo = notification.userInfo!
            guard let keyboardFrameEndUserInfoKey = userInfo[UIResponder.keyboardFrameEndUserInfoKey] else { return }
            let keyboardSize = (keyboardFrameEndUserInfoKey as AnyObject).cgRectValue.size
            let contentInsets = UIEdgeInsets(top: scrollView.contentInset.top, left: scrollView.contentInset.left, bottom: 0, right: scrollView.contentInset.right)
            
            scrollView.setContentInsetAndScrollIndicatorInsets(contentInsets)
            onHide?(keyboardSize)
        })
    }
}

extension UIScrollView {
    
    func setContentInsetAndScrollIndicatorInsets(_ edgeInsets: UIEdgeInsets) {
        contentInset = edgeInsets
        scrollIndicatorInsets = edgeInsets
    }
}
