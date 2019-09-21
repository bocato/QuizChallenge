//
//  URLRequestToken.swift
//  Networking
//
//  Created by Eduardo Sanches Bocato on 20/09/19.
//  Copyright © 2019 Bocato. All rights reserved.
//

import Foundation

/// Task abstraction in order to make the request cancelable without exposing the URLSessionDataTask.
public final class URLRequestToken {
    
    // MARK: - Properties
    
    private weak var task: URLSessionDataTask?
    
    // MARK: - Initialization
    
    /// Initializer
    ///
    /// - Parameter task: An URLSessionDataTask that can be canceled.
    init(task: URLSessionDataTask) {
        self.task = task
    }
    
    // MARK: - Functions
    
    /// Cancels the data task.
    func cancel() {
        task?.cancel()
    }
    
}
