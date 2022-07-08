//
//  HTTPClient.swift
//  Meli Challenge
//
//  Created by Yoav Zoldan on 07-07-2022.
//

import Foundation

class HTTPClient {
    
    private var urlSession: URLSession
    
    init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }
    
    func sendRequest<T: Decodable>(endpoint: Endpoint, responseModel: T.Type) async -> Result<T, RequestError> {
        
        var components = URLComponents()
        components.scheme = "https"
        if endpoint.baseURL.isEmpty {
            return .failure(.invalidURL)
        } else {
            components.host = endpoint.baseURL
        }
        components.path = endpoint.path
        components.queryItems = endpoint.queryParams
        
        guard let url = components.url else {
            return .failure(.invalidURL)
        }
                
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.allHTTPHeaderFields = endpoint.header
        
        if let body = endpoint.body {
            request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        }
        
        do {
            let (data, response) = try await urlSession.data(for: request, delegate: nil)
            guard let response = response as? HTTPURLResponse else {
                return .failure(.noResponse)
            }
            switch response.statusCode {
            case 200...299:
                guard let decodedResponse = try? JSONDecoder().decode(responseModel, from: data) else {
                    return .failure(.decode)
                }
                return .success(decodedResponse)
            case 401:
                return .failure(.unauthorized)
            default:
                return .failure(.unexpectedStatusCode)
            }
        } catch {
            return .failure(.unknown)
        }
    }
}
