//
//  SearchScreenCollectionViewCell.swift
//  SapChallenge
//
//  Created by Svilen Kirov on 11.11.21.
//

import UIKit

class SearchScreenCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    private var imageData: ImageData?
    
    func configureCell(imageData: ImageData?) {
        guard let imageData = imageData,
              self.imageData != imageData else { return }
        
        self.imageData = imageData
        imageView.image = nil
        
        layer.cornerRadius = 5
        loadingIndicator.startAnimating()
        loadingIndicator.isHidden = false
        Repository.downloadImage(from: imageData) { [weak self] data in
            guard let strongSelf = self,
                  let data = data else { return }
            strongSelf.loadingIndicator.isHidden = true
            strongSelf.loadingIndicator.stopAnimating()
            strongSelf.imageView.image = UIImage(data: data)
        }
    }
}
