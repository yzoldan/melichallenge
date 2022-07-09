//
//  Double+Meli.swift
//  Meli Challenge
//
//  Created by Yoav Zoldan on 08-07-2022.
//

import Foundation

extension Double {
    func toCurrency(locale: Locale) -> String {
        let formatter = NumberFormatter()
        formatter.locale = locale
        formatter.numberStyle = .currency
        return formatter.string(from: NSNumber(value: self)) ?? ""
    }
    
    func toCurrency() -> String {
        return toCurrency(locale: .init(identifier: "es_CL"))
    }
    
    func toCurrency(currencyCode: String) -> String {
        switch currencyCode {
        case "CLP":
            return toCurrency(locale: .init(identifier: "es_CL"))
        default:
            return toCurrency(locale: .current)
        }
    }
    
    func toThousands() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: self)) ?? ""
    }
}
