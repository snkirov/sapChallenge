//
//  ViewModel.swift
//  SapChallenge
//
//  Created by Svilen Kirov on 10.11.21.
//

import Foundation
import TwoWayBondage

class ViewModel {
    
    var imageData = Observable<[ImageData]>()
    
    var imagesCount: Int {
        imageData.value?.count ?? 0
    }
    
    func searchBy(term: String) {
        Repository.getImages(byTerm: term) { [weak self] response in
            self?.imageData.value = response
        }
    }
    
    func getImageData(for index: Int) -> ImageData? {
        guard index < imagesCount else { return nil }
        return imageData.value?[index]
    }
}
