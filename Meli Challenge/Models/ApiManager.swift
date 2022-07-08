//
//  ApiManager.swift
//  Meli Challenge
//
//  Created by Yoav Zoldan on 08-07-2022.
//

import Foundation

class ApiManager {
    
    let httpClient: HTTPClient
    let baseUrl: String
    
    init(httpClient: HTTPClient? = nil, baseUrl: String? = nil) {
        self.httpClient = httpClient ?? HTTPClient()
        self.baseUrl = baseUrl ?? K.baseUrl
    }
    
    func searchItems(forQuery query: String, limit: Int = 20, offset: Int = 0) async -> Result<SearchResponse, RequestError> {
        let params = [
            URLQueryItem(name: "q", value: query),
            URLQueryItem(name: "limit", value: String(limit)),
            URLQueryItem(name: "offset", value: String(offset))
        ]
        let endpoint = Endpoint(baseURL: baseUrl, path: "/sites/MLC/search", queryParams: params, method: .get)
        let result = await httpClient.sendRequest(endpoint: endpoint, responseModel: SearchResponse.self)
        return result
    }
}
