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
    let condition: String
    let sold_quantity: Int
    let thumbnail: String
    let attributes: Attributes
    
    var thumbnailURL: URL? {
        return URL(string: thumbnail)
    }
    var conditionDescription: String {
        return condition == "new" ? "Nuevo" : "Usado"
    }
    
    static let mock = Item(id: "MLC992560003",
                           title: "Sony Playstation 5 825gb Standard Color Blanco Y Negro",
                           price: 729990,
                           currency_id: "CLP",
                           installments: Installments(quantity: 6, amount: 121665, rate: 0, currency_id: "CLP"),
                           shipping: Shipping(free_shipping: true),
                           condition: "new",
                           sold_quantity: 88,
                           thumbnail: "http://http2.mlstatic.com/D_682904-MLA45732843790_042021-I.jpg",
                           attributes: [Attribute(id: "BRAND",name: "Marca", value_name: "Sony"), Attribute(id: "ITEM_CONDITION",name: "Condición del ítem", value_name: "Nuevo")]
    )
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

struct Attribute: Codable, Identifiable {
    let id: String
    let name: String?
    let value_name: String?
    
    var isValid: Bool {
        return name != nil && !name!.isEmpty && value_name != nil && !value_name!.isEmpty
    }
}

typealias Attributes = [Attribute]
