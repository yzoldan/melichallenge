//
//  Endpoint.swift
//  Meli Challenge
//
//  Created by Yoav Zoldan on 07-07-2022.
//

import Foundation

struct Endpoint {
    var baseURL: String
    var path: String
    var queryParams: [URLQueryItem]?
    var method: RequestMethod
    var header: [String: String]?
    var body: [String: String]?
}
