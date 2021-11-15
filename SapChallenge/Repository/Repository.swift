//
//  Repository.swift
//  SapChallenge
//
//  Created by Svilen Kirov on 10.11.21.
//

import Foundation
import Alamofire

private let url = """
https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=37ad288835e4c64fc0cb8af3f3a1a65d&format=json&nojsoncallback=1&safe_search=1&text=
"""
private let nextPageUrl = "%@%@&page=%@"
private let imageUrl = "https://farm%@.static.flickr.com/%@/%@_%@.jpg"

protocol RepositoryProtocol: AnyObject {
    func getImages(byTerm term: String, completion: @escaping (ImageDataContainer?) -> Void)
    func getPageFor(term: String, _ pageNumber: Int, completion: @escaping ([ImageData]?) -> Void)
    func downloadImage(from data: ImageData, completion: @escaping (Data?) -> Void)
}

class Repository {
    static let sharedInstance = Repository()
}

// MARK: - RepositoryProtocol
extension Repository: RepositoryProtocol {
    public func getImages(byTerm term: String, completion: @escaping (ImageDataContainer?) -> Void) {
        let requestUrl = url + term
        AF.request(requestUrl).responseDecodable(of: MyResponse.self) { response in
            guard response.error == nil else {
                print("Error while getting images for \(term): \(response.error!)")
                return
            }
            completion(response.value?.photos)
        }
    }
    
    public func getPageFor(term: String, _ pageNumber: Int, completion: @escaping ([ImageData]?) -> Void) {
        let requestUrl = String(format: nextPageUrl, url, term, String(pageNumber))
        AF.request(requestUrl).responseDecodable(of: MyResponse.self) { response in
            guard response.error == nil else {
                print("Error while geting page for \(term) with number \(pageNumber): \(response.error!)")
                return
            }
            completion(response.value?.photos.photo)
        }
    }
    
    public func downloadImage(from data: ImageData, completion: @escaping (Data?) -> Void) {
        let downloadUrl = String(format: imageUrl, String(data.farm), data.server, data.id, data.secret)
        AF.download(downloadUrl).responseData { response in
            guard response.error == nil else {
                print("Error while downloading image: \(response.error!)")
                return
            }
            completion(response.value)
        }
    }
}
