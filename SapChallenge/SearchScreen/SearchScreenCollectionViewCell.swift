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
    private var repository: Repository = Repository.sharedInstance
    
//    init(repository: Repository = Repository.sharedInstance) {
//        self.repository = repository
//        super.init(frame: <#T##CGRect#>)
//    }
    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    func configureCell(imageData: ImageData?) {
        guard let imageData = imageData,
              self.imageData != imageData else { return }
        
        self.imageData = imageData
        imageView.image = nil
        
        layer.cornerRadius = 5
        loadingIndicator.startAnimating()
        loadingIndicator.isHidden = false
        repository.downloadImage(from: imageData) { [weak self] data in
            guard let strongSelf = self,
                  let data = data else { return }
            strongSelf.loadingIndicator.isHidden = true
            strongSelf.loadingIndicator.stopAnimating()
            strongSelf.imageView.image = UIImage(data: data)
        }
    }
}
