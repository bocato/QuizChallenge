//
//  DependencyInjection.swift
//  QuizChallenge
//
//  Created by Eduardo Sanches Bocato on 21/09/19.
//  Copyright © 2019 Bocato. All rights reserved.
//

import Foundation
import Networking

// Simple implementation of a DependencyInjection container
final class DependencyInjection {
    
    // MARK: - Private
    
    private init() {}
    
    
    // MARK: - Public
    static let urlSessionDispatcher: URLRequestDispatching = URLSessionDispatcher()
    
}
