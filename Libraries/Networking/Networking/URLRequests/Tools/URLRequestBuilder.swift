//
//  URLRequestBuilder.swift
//  Networking
//
//  Created by Eduardo Sanches Bocato on 20/09/19.
//  Copyright © 2019 Bocato. All rights reserved.
//

import Foundation

final class URLRequestBuilder {
    
    // MARK: - Properties
    
    private var baseURL: URL
    private var path: String?
    private var method: HTTPMethod = .get
    private var headers: [String: Any]?
    private var parameters: URLRequestParameters?
    private var adapters: [URLRequestAdapter] = []
    
    // MARK: - Initialization
    
    /// Initializes the request.
    ///
    /// - Parameters:
    ///   - baseURL: A base URL.
    ///   - path: A path for the request.
    public init(with baseURL: URL,
                path: String?) {
        self.baseURL = baseURL
        self.path = path
    }
    
    // MARK: - Builder methods
    
    /// Sets the method.
    ///
    /// - Parameter method: A HTTPMethod.
    /// - Returns: Itself, for sugar syntax purposes.
    @discardableResult
    public func set(method: HTTPMethod) -> Self {
        self.method = method
        return self
    }
    
    /// Sets the request path.
    ///
    /// - Parameter path: A path.
    /// - Returns: Itself, for sugar syntax purposes.
    @discardableResult
    public func set(path: String) -> Self {
        self.path = path
        return self
    }
    
    /// Sets the request headers.
    ///
    /// - Parameter headers: the headers
    /// - Returns: Itself, for sugar syntax purposes.
    @discardableResult
    public func set(headers: [String: Any]?) -> Self {
        self.headers = headers
        return self
    }
    
    /// Sets the request parameters.
    ///
    /// - Parameter parameters: some parameters
    /// - Returns: Itself, for sugar syntax purposes.
    @discardableResult
    public func set(parameters: URLRequestParameters?) -> Self {
        self.parameters = parameters
        return self
    }
    
    /// Sets an adapter, Ex: OAuthAdapter.
    ///
    /// - Parameter adapter: An adapter.
    /// - Returns: Itself, for sugar syntax purposes.
    @discardableResult
    public func add(adapter: URLRequestAdapter?) -> Self {
        guard let adapter = adapter else { return self }
        adapters.append(adapter)
        return self
    }
    
    /// Builds an URLRequest as previously defined.
    ///
    /// - Returns: A configured URLRequest.
    public func build() throws -> URLRequest {
        
        var url = baseURL
        if let path = path {
            url = baseURL.appendingPathComponent(path)
        }
        
        var urlRequest = URLRequest(url: url,
                                    cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
                                    timeoutInterval: 100)
        
        urlRequest.httpMethod = method.name
        setupRequest(&urlRequest, with: parameters)
        
        headers?
            .compactMapValues { $0 as? String }
            .forEach {
                urlRequest.addValue($0.value, forHTTPHeaderField: $0.key)
        }
        
        do {
            try adapters.forEach {
                urlRequest = try $0.adapt(urlRequest)
            }
            
        } catch {
            throw error
        }
        
        return urlRequest
    }
    
    // MARK: - Private Functions
    
    private func setupRequest(_ request: inout URLRequest, with parameters: URLRequestParameters?) {
        
        guard let parameters = parameters else { return }
        
        switch parameters {
        case .body(let bodyParameters):
            guard let bodyParameters = bodyParameters,
                let payload = try? JSONSerialization.data(withJSONObject: bodyParameters, options: []) else { return }
            request.httpBody = payload
        case .url(let urlParameters):
            
            guard let urlParameters = urlParameters,
                let url = request.url,
                var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true) else { return }
            
            urlComponents.queryItems = urlParameters.map { URLQueryItem(name: $0.key, value: $0.value) }
            request.url = urlComponents.url
        }
        
    }
    
}
