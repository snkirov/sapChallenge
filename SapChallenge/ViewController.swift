//
//  ViewController.swift
//  SapChallenge
//
//  Created by Svilen Kirov on 8.11.21.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Repository.getImages(byTerm: "Munich") { response in
            guard let imageData = response?.first else { return }
            Repository.downloadImage(from: imageData) { [weak self] data in
                guard let data = data else { return }
                self?.imageView.image = UIImage(data: data)
            }
        }
    }
}
