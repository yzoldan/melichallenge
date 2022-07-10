//
//  Picture.swift
//  Meli Challenge
//
//  Created by Yoav Zoldan on 09-07-2022.
//

import Foundation

struct PicturesResponse: Codable {
    let pictures: Pictures
}

struct Picture: Codable, Identifiable {
    let id: String
    let url: String
    let secure_url: String
    let size: String
    let max_size: String
    let quality: String
    
    func getUrl() -> URL? {
        return URL(string: url)
    }
    
    static let mock = Picture(id: "682904-MLA45732843790_042021",
                              url: "http://http2.mlstatic.com/D_682904-MLA45732843790_042021-O.jpg",
                              secure_url: "https://http2.mlstatic.com/D_682904-MLA45732843790_042021-O.jpg",
                              size: "385x500",
                              max_size: "924x1197",
                              quality: "")
}

typealias Pictures = [Picture]
