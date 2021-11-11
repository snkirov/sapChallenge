//
//  ViewController.swift
//  SapChallenge
//
//  Created by Svilen Kirov on 8.11.21.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var viewModel = ViewModel()
    private let reuseIdentifier = "CollectionViewCell"
    
    override func viewWillLoad(animated: Bool) {
        navigationItem.title = "Search results"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "History", style: .plain, target: nil, action: #selector(openHistory))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.searchBy(term: "Munich")
        
        viewModel.imageData.bindAndFire { [weak self] _ in
            guard let strongSelf = self else { return }
            if (strongSelf.viewModel.isInitialyLoading.value ?? true) {
                strongSelf.collectionView.reloadData()
            } else {
                UIView.performWithoutAnimation({
                    strongSelf.collectionView.reloadData()
                })
            }
        }
        
        viewModel.isInitialyLoading.bindAndFire { [weak self] isLoading in
            guard let strongSelf = self else { return }
            strongSelf.loadingIndicator.isHidden = !isLoading
            if isLoading {
                strongSelf.loadingIndicator.startAnimating()
            } else {
                strongSelf.loadingIndicator.stopAnimating()
            }
        }
    }
    
    @objc func openHistory() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "TableViewController")
        navigationController?.show(vc, sender: self)
    }
}

extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == viewModel.imagesCount - 1 {
            viewModel.loadNextPage()
        }
    }
}

extension ViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.imagesCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as? CollectionViewCell else { return UICollectionViewCell() }
        
        let data = viewModel.getImageData(for: indexPath.row)
        cell.configureCell(imageData: data)
                
        return cell
    }
    
    // MARK: - UICollectionViewFlowDelegate
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let size = Int((collectionView.frame.size.width - 40) / 3)
        return CGSize(width: size, height: size)
    }
}

extension ViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.searchBy(term: "")
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        let keyword = searchBar.text ?? ""
        viewModel.searchBy(term: searchBar.text ?? "")
//        var titleString = ""
//        titleString = keyword != "" ? "\"\(keyword)\"" : "Search for a word"
//        navigationItem.title = titleString
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    }
}
