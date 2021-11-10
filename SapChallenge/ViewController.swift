//
//  ViewController.swift
//  SapChallenge
//
//  Created by Svilen Kirov on 8.11.21.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        Repository.getImages(byTerm: "Munich") { response in
            debugPrint(response)
        }
    }
}
