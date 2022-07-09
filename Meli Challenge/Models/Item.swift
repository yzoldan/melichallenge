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
    let price: Double
    let sale_price: Int?
    let currency_id: String
    let installments: Installments
    let shipping: Shipping
    let thumbnail: String
    var thumbnailURL: URL? {
        return URL(string: thumbnail)
    }
}

struct Installments: Codable {
    let quantity: Int
    let amount: Double
    let rate: Double
    let currency_id: String
    
    var description: String {
        var desc = "\(quantity) x \(amount.toCurrency(currencyCode: currency_id))"
        if rate == 0 {
            desc.append(contentsOf: " sin interés")
        }
        return desc
    }
}

struct Shipping: Codable {
    let free_shipping: Bool
}
