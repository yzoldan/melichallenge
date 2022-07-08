//
//  SearchResponse.swift
//  Meli Challenge
//
//  Created by Yoav Zoldan on 08-07-2022.
//

import Foundation

struct SearchResponse: Codable {
    let query: String
    let results: [Item]
    let paging: Paging
}

struct Paging: Codable {
    let total: Int
    let offset: Int
    let limit: Int
}
