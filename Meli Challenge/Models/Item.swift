//
//  Item.swift
//  Meli Challenge
//
//  Created by Yoav Zoldan on 08-07-2022.
//

import Foundation

struct Item: Codable {
    let id: String
    let title: String
    let price: Int
    let sale_price: Int?
    let currency_id: String
    let thumbnail: String
}
