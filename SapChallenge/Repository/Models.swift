//
//  Models.swift
//  SapChallenge
//
//  Created by Svilen Kirov on 15.11.21.
//

import Foundation

struct MyResponse: Codable {
    var photos: ImageDataContainer
}

struct ImageDataContainer: Codable {
    var page: Int
    var pages: Int
    var photo: [ImageData]
}

struct ImageData: Codable, Equatable {
    var id: String
    var farm: Int
    var server: String
    var secret: String
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id &&
        lhs.farm == rhs.farm &&
        lhs.server == rhs.server &&
        lhs.secret == rhs.secret
    }
}
