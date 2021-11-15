//
//  HistoryScreenTableViewController.swift
//  SapChallenge
//
//  Created by Svilen Kirov on 11.11.21.
//

import UIKit

protocol HistoryDelegate: AnyObject {
    func didCloseHistoryScreen(didCancel: Bool, term: String)
}

class HistoryScreenTableViewController: UITableViewController {
    
    private let reuseIdentifier = "TableViewCell"
    weak var delegate: HistoryDelegate?
    var viewModel: HistoryScreenViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "History"
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.searchesCount
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? TableViewCell else {
            return UITableViewCell()
        }
        cell.title.text = viewModel.getSearchHistory[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.didCloseHistoryScreen(didCancel: false, term: viewModel.getSearchHistory[indexPath.row])
        navigationController?.popViewController(animated: true)
    }
}
