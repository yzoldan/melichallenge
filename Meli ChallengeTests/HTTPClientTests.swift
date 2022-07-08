//
//  HTTPClientTests.swift
//  Meli ChallengeTests
//
//  Created by Yoav Zoldan on 07-07-2022.
//

import XCTest
@testable import Meli_Challenge

class HTTPClientTests: XCTestCase {
    
    var sut: HTTPClient!
    var endpoint: Endpoint!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        let urlSession = URLSession(configuration: config)
        sut = HTTPClient(urlSession: urlSession)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sut = nil
        endpoint = nil
        MockURLProtocol.stubResponseData = nil
        MockURLProtocol.error = nil
    }
    
    private func setupSuccessResponse() throws {
        let successMock = MockModel.successMock
        let data = try JSONEncoder().encode(successMock)
        MockURLProtocol.stubResponseData = data
        endpoint = Endpoint(baseURL: "test.com", path: "", method: .post, body: ["test": "ok"])
    }
    
    private func setFailingResponse() {
        
    }
    func testHTTPClient_WhenGivenSuccesfullResponse_ReturnSuccess() async throws {
        // Arrange
        try setupSuccessResponse()
        
        // Act
        let result = await sut.sendRequest(endpoint: endpoint, responseModel: MockModel.self)
        let responseModel = try result.get()
        
        // Assert
        XCTAssertTrue(responseModel.success)
    }
    
    func testHTTPClient_WhenGivenDifferentResponseModel_ReturnsCorrectError() async throws {
        //Arrange
        try setupSuccessResponse()
        
        // Act
        let result = await sut.sendRequest(endpoint: endpoint, responseModel: DifferentMockModel.self)
        switch result {
        case .success(_):
            XCTFail("When given different model should fail")
        case .failure(let error):
            XCTAssertEqual(error, RequestError.decode)
        }
    }
    
    func testHTTPClient_WhenGivenInvalidURL_ReturnsCorrectError() async {
        // Arrange
        endpoint = Endpoint(baseURL: "", path: "", method: .get)
        // Act
        let result = await sut.sendRequest(endpoint: endpoint, responseModel: MockModel.self)
        
        // Assert
        switch result {
        case .success(_):
            XCTFail("When given invalid url should fail")
        case .failure(let error):
            XCTAssertEqual(error, RequestError.invalidURL)
        }
    }
    
    func testHTTPClient_WhenGivenUnauthorizedResponse_ReturnsCorrectError() async {
        // Arrange
        
        // Act
        
        // Assert
    }

}
