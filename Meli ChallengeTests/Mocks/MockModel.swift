//
//  MockModel.swift
//  Meli ChallengeTests
//
//  Created by Yoav Zoldan on 07-07-2022.
//

import Foundation

struct MockModel: Codable {
    let success: Bool
    let message: String?
    
    static let successMock = MockModel(success: true, message: nil)
    static let failMock = MockModel(success: false, message: "An error has occurred")
}

struct DifferentMockModel: Codable {
    let status: String
    
    static let mock = DifferentMockModel(status: "ok")
}
