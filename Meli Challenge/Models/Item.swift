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
    let currency_id: String
    let installments: Installments
    let shipping: Shipping
    let thumbnail: String
    var thumbnailURL: URL? {
        return URL(string: thumbnail)
    }
    
    static let mock = Item(id: "MLC992560003",
                           title: "Sony Playstation 5 825gb Standard Color Blanco Y Negro",
                           price: 729990,
                           currency_id: "CLP",
                           installments: Installments(quantity: 6, amount: 121665, rate: 0, currency_id: "CLP"),
                           shipping: Shipping(free_shipping: true),
                           thumbnail: "http://http2.mlstatic.com/D_682904-MLA45732843790_042021-I.jpg")
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
