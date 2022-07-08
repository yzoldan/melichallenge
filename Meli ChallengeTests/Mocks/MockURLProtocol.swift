//
//  MockURLProtocol.swift
//  Meli ChallengeTests
//
//  Created by Yoav Zoldan on 07-07-2022.
//

import Foundation
import XCTest

class MockURLProtocol: URLProtocol {
    
    static var stubResponseData: Data?
    static var error: Error?
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canInit(with task: URLSessionTask) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    
    override func startLoading() {
        
        guard let client = client else { return }
        
        do {
            if let error = MockURLProtocol.error {
                client.urlProtocol(self, didFailWithError: error)
            } else {
                let response = try XCTUnwrap(HTTPURLResponse(
                    url: XCTUnwrap(request.url),
                    statusCode: 200,
                    httpVersion: "HTTP/1.1",
                    headerFields: nil
                ))
                client.urlProtocol(self,
                                   didReceive: response,
                                   cacheStoragePolicy: .notAllowed
                )
                client.urlProtocol(self, didLoad: MockURLProtocol.stubResponseData ?? Data())
            }
        } catch {
            client.urlProtocol(self, didFailWithError: error)
        }
        
        self.client?.urlProtocolDidFinishLoading(self)
    }
    
    override func stopLoading() { }
    
}
