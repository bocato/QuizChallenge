//
//  Environment.swift
//  QuizChallenge
//
//  Created by Eduardo Sanches Bocato on 21/09/19.
//  Copyright © 2019 Bocato. All rights reserved.
//

import Foundation

/// Provides an interface for the services enviroment properties
protocol EnvironmentProvider {
    /// Defines the current enviroment
    var currentEnvironment: EnvironmentType { get set }
    /// Provides de base URL for the services
    var baseURL: URL { get }
}

// MARK: - Enums

/// Defines de current application environment
///
/// - dev: development servers
enum EnvironmentType: String {
    case development
}

/// Defines a single instance for the EnvironmentProvider
/// NOTE: Simplified implementation, that could be extendend.
final class Environment: EnvironmentProvider {
    
    // MARK: - Singleton
    
    static let shared = Environment()
    
    // MARK: - Private Properties
    
    private var _baseURL: URL?
    
    // MARK: - Public Properties
    
    /// Defines the current enviroment
    var currentEnvironment: EnvironmentType {
        didSet {
            setup()
        }
    }
    
    /// Provides de base URL for the services
    var baseURL: URL {
        guard let url = _baseURL else {
            fatalError("There are no requests without a baseURL, it must be set!")
        }
        return url
    }
    
    // MARK: - Initialization
    
    private init(currentEnvironment: EnvironmentType = .development) {
        self.currentEnvironment = currentEnvironment
        setup()
    }
    
    // MARK: - Configuration
    
    // This could be done loading a plist or something else
    private func setup() {
        switch currentEnvironment {
        case .development:
            guard let url = URL(string: "https://codechallenge.arctouch.com") else {
                fatalError("Invalid URL.")
            }
            _baseURL = url
        }
    }
    
}
