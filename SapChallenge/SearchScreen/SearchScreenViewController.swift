//
//  SearchScreenViewController.swift
//  SapChallenge
//
//  Created by Svilen Kirov on 8.11.21.
//

import UIKit

class SearchScreenViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var viewModel = SearchScreenViewModel()
    private let reuseIdentifier = "SearchScreenCollectionViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Search"
        
        viewModel.searchBy(term: "Munich")
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tap)
        
        bindEvents()
    }
    
    @IBAction func didTapHistory(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: "HistoryScreenTableViewController") as? HistoryScreenTableViewController else { return }
        vc.delegate = self
        vc.viewModel = HistoryScreenViewModel()
        vc.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Clear", style: .plain, target: self, action: #selector(clearHistory))
        navigationController?.show(vc, sender: self)
        handleTap()
    }
    
    private func bindEvents() {
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
    
    @objc private func clearHistory() {
        HistoryTracker.clearHistory()
    }
    
    @objc private func handleTap() {
        guard searchBar.isFirstResponder else { return }
        searchBar.resignFirstResponder()
    }
}

extension SearchScreenViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
}

extension SearchScreenViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == viewModel.imagesCount - 1 {
            viewModel.loadNextPage()
        }
    }
}

extension SearchScreenViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.imagesCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as? SearchScreenCollectionViewCell else { return UICollectionViewCell() }
        
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

extension SearchScreenViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        viewModel.searchBy(term: searchBar.text ?? "")
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    }
}

extension SearchScreenViewController: HistoryDelegate {
    func didCloseHistoryScreen(didCancel: Bool, term: String) {
        guard !didCancel else { return }
        searchBar.text = term
        viewModel.searchBy(term: term)
    }
}
