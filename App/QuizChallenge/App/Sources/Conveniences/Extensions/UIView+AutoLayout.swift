//
//  UIView+AutoLayout.swift
//  QuizChallenge
//
//  Created by Eduardo Sanches Bocato on 21/09/19.
//  Copyright © 2019 Bocato. All rights reserved.
//

import UIKit

extension UIView {
    
    /// Anchor all sides of the view into the safe area.
    /// - Parameters:
    ///   - topConstant: current view's top anchor margin
    ///   - leftConstant: current view's left anchor margin
    ///   - bottomConstant: current view's bottom anchor margin
    ///   - rightConstant: current view's right anchor margin
    @available(iOS 9, *) public func anchorToSafeArea(topConstant: CGFloat = 0,
                                                          leftConstant: CGFloat = 0,
                                                          bottomConstant: CGFloat = 0,
                                                          rightConstant: CGFloat = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        if let superview = superview {
            let top = topAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.topAnchor, constant: topConstant)
            let left = leftAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.leftAnchor, constant: leftConstant)
            let bottom = bottomAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.bottomAnchor, constant: bottomConstant)
            let right = rightAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.rightAnchor, constant: rightConstant)
            NSLayoutConstraint.activate([left, right, top, bottom])
        }
    }
    
    /// Add anchors from any side of the current view into the specified anchors and returns the newly added constraints.
    ///
    /// - Parameters:
    ///   - top: current view's top anchor will be anchored into the specified anchor
    ///   - left: current view's left anchor will be anchored into the specified anchor
    ///   - bottom: current view's bottom anchor will be anchored into the specified anchor
    ///   - right: current view's right anchor will be anchored into the specified anchor
    ///   - topConstant: current view's top anchor margin
    ///   - leftConstant: current view's left anchor margin
    ///   - bottomConstant: current view's bottom anchor margin
    ///   - rightConstant: current view's right anchor margin
    ///   - widthConstant: current view's width
    ///   - heightConstant: current view's height
    /// - Returns: array of newly added constraints (if applicable).
    @available(iOS 9, *) @discardableResult public func anchor(
        top: NSLayoutYAxisAnchor? = nil,
        left: NSLayoutXAxisAnchor? = nil,
        bottom: NSLayoutYAxisAnchor? = nil,
        right: NSLayoutXAxisAnchor? = nil,
        topConstant: CGFloat = 0,
        leftConstant: CGFloat = 0,
        bottomConstant: CGFloat = 0,
        rightConstant: CGFloat = 0,
        widthConstant: CGFloat = 0,
        heightConstant: CGFloat = 0) -> [NSLayoutConstraint] {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        var anchors = [NSLayoutConstraint]()
        
        if let top = top {
            anchors.append(topAnchor.constraint(equalTo: top, constant: topConstant))
        }
        
        if let left = left {
            anchors.append(leftAnchor.constraint(equalTo: left, constant: leftConstant))
        }
        
        if let bottom = bottom {
            anchors.append(bottomAnchor.constraint(equalTo: bottom, constant: -bottomConstant))
        }
        
        if let right = right {
            anchors.append(rightAnchor.constraint(equalTo: right, constant: -rightConstant))
        }
        
        if widthConstant > 0 {
            anchors.append(widthAnchor.constraint(equalToConstant: widthConstant))
        }
        
        if heightConstant > 0 {
            anchors.append(heightAnchor.constraint(equalToConstant: heightConstant))
        }
        
        anchors.forEach({$0.isActive = true})
        
        return anchors
    }
    
    /// Anchor center X into current view's superview with a constant margin value.
    ///
    /// - Parameter constant: constant of the anchor constraint (default is 0).
    @available(iOS 9, *) public func anchorCenterXToSuperview(constant: CGFloat = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        if let anchor = superview?.centerXAnchor {
            centerXAnchor.constraint(equalTo: anchor, constant: constant).isActive = true
        }
    }
    
    /// Anchor center Y into current view's superview with a constant margin value.
    ///
    /// - Parameter withConstant: constant of the anchor constraint (default is 0).
    @available(iOS 9, *) public func anchorCenterYToSuperview(constant: CGFloat = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        if let anchor = superview?.centerYAnchor {
            centerYAnchor.constraint(equalTo: anchor, constant: constant).isActive = true
        }
    }
    
    /// Anchor center X and Y into current view's superview
    @available(iOS 9, *) public func anchorCenterSuperview() {
        anchorCenterXToSuperview()
        anchorCenterYToSuperview()
    }
    
    /// Safe area Top Anchor
    var safeTopAnchor: NSLayoutYAxisAnchor {
        if #available(iOS 11.0, *) {
            return self.safeAreaLayoutGuide.topAnchor
        }
        return self.topAnchor
    }
    
    /// Safe area Left Anchor
    var safeLeftAnchor: NSLayoutXAxisAnchor {
        if #available(iOS 11.0, *){
            return self.safeAreaLayoutGuide.leftAnchor
        }
        return self.leftAnchor
    }
    
    /// Safe area Right Anchor
    var safeRightAnchor: NSLayoutXAxisAnchor {
        if #available(iOS 11.0, *){
            return self.safeAreaLayoutGuide.rightAnchor
        }
        return self.rightAnchor
    }
    
    /// Safe area Bottom Anchor
    var safeBottomAnchor: NSLayoutYAxisAnchor {
        if #available(iOS 11.0, *) {
            return self.safeAreaLayoutGuide.bottomAnchor
        }
        return self.bottomAnchor
    }
    
    /// Returns the bottom constraint, and updates when it is changed
    var bottomConstraint: NSLayoutConstraint? {
        get {
            return constraints.first(where: { $0.firstAttribute == .bottom && $0.relation == .equal })
        }
        set { setNeedsLayout() }
    }
    
    /// Returns the top constraint, and updates when changes
    var topConstraint: NSLayoutConstraint? {
        get {
            return constraints.first(where: { $0.firstAttribute == .top && $0.relation == .equal })
        }
        set { setNeedsLayout() }
    }
    
    /// Returns the right constraint, and updates when it is changed
    var rightConstraint: NSLayoutConstraint? {
        get {
            return constraints.first(where: { $0.firstAttribute == .right && $0.relation == .equal })
        }
        set { setNeedsLayout() }
    }
    
    /// Returns the left constraint, and updates when it is changed
    var leftConstraint: NSLayoutConstraint? {
        get {
            return constraints.first(where: { $0.firstAttribute == .left && $0.relation == .equal })
        }
        set { setNeedsLayout() }
    }
    
}
