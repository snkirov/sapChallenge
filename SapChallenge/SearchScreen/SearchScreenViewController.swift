//
//  SearchScreenViewController.swift
//  SapChallenge
//
//  Created by Svilen Kirov on 8.11.21.
//

import UIKit

protocol HistoryScreenViewControllerProtocol: AnyObject {
    func didClearHistory()
}

class SearchScreenViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var noResultsLabel: UILabel!
    weak var historyController: HistoryScreenViewControllerProtocol?
    
    var viewModel = SearchScreenViewModel()
    private let reuseIdentifier = "SearchScreenCollectionViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Search"
        viewModel.searchBy(term: "Munich")
        searchBar.text = "Munich"
        
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
        historyController = vc
        handleTap() // Sets the search bar properly
        navigationController?.show(vc, sender: self)
    }
    
    private func bindEvents() {
        viewModel.imageData.bindAndFire { [weak self] results in
            guard let strongSelf = self else { return }
            DispatchQueue.main.async {
                strongSelf.noResultsLabel.isHidden = (!results.isEmpty || (strongSelf.viewModel.isLoading.value ?? false))
                if (strongSelf.viewModel.isLoading.value ?? true) {
                    strongSelf.collectionView.reloadData()
                } else {
                    // Avoid animation during infinite scroll
                    UIView.performWithoutAnimation({
                        strongSelf.collectionView.reloadData()
                    })
                }
            }
        }
        
        viewModel.isLoading.bindAndFire { [weak self] isLoading in
            guard let strongSelf = self else { return }
            DispatchQueue.main.async {
                strongSelf.loadingIndicator.isHidden = !isLoading
                if isLoading {
                    strongSelf.loadingIndicator.startAnimating()
                } else {
                    strongSelf.loadingIndicator.stopAnimating()
                }
            }
        }
    }
    
    @objc private func clearHistory() {
        historyController?.didClearHistory()
    }
    
    @objc private func handleTap() {
        guard searchBar.isFirstResponder else { return }
        searchBar.resignFirstResponder()
        searchBar.text = viewModel.term
    }
}

// MARK: - UICollectionViewDelegate
extension SearchScreenViewController: UICollectionViewDelegate { }

// MARK: - UICollectionViewDelegateFlowLayout
extension SearchScreenViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == viewModel.imagesCount - 10 {
            viewModel.loadNextPage()
        }
    }
}

// MARK: - UICollectionViewDataSource
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

// MARK: - UISearchBarDelegate
extension SearchScreenViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        viewModel.searchBy(term: searchBar.text ?? "")
    }
}

// MARK: - HistoryDelegate
extension SearchScreenViewController: HistoryDelegate {
    func didCloseHistoryScreen(didCancel: Bool, term: String) {
        guard !didCancel else { return }
        searchBar.text = term
        viewModel.searchBy(term: term)
    }
}
