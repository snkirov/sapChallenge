//
//  Repository.swift
//  SapChallenge
//
//  Created by Svilen Kirov on 10.11.21.
//

import Foundation
import Alamofire

let url = """
https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=37ad288835e4c64fc0cb8af3f3a1a65d&format=json&nojsoncallback=1&safe_search=1&text=
"""
let imageUrl = "https://farm%@.static.flickr.com/%@/%@_%@.jpg"

class Repository {
    
    public static func getImages(byTerm term: String, completion: @escaping (Dummy?) -> Void) {
        AF.request(url + term).responseDecodable(of: MyResponse.self) { response in
            completion(response.value?.photos)
        }
    }
    
    public static func getPageFor(term: String, _ pageNumber: Int, completion: @escaping ([ImageData]?) -> Void) {
        AF.request(url + term + "&page=\(pageNumber)").responseDecodable(of: MyResponse.self) { response in
            completion(response.value?.photos.photo)
        }
    }
    
    public static func downloadImage(from data: ImageData, completion: @escaping (Data?) -> Void) {
        let downloadUrl = String(format: imageUrl, String(data.farm), data.server, data.id, data.secret)
        AF.download(downloadUrl).responseData { response in
            completion(response.value)
        }
    }
}

struct MyResponse: Codable {
    var photos: Dummy
}

struct Dummy: Codable {
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
