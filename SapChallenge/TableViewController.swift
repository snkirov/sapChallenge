//
//  TableViewController.swift
//  SapChallenge
//
//  Created by Svilen Kirov on 11.11.21.
//

import UIKit

protocol HistoryDelegate: NSObject {
    func didCloseHistoryScreen(didCancel: Bool, term: String)
}

class TableViewController: UITableViewController {
    
    private let reuseIdentifier = "TableViewCell"
    weak var delegate: HistoryDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "History"

    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? TableViewCell else {
            return UITableViewCell()
        }

        cell.title.text = "Abra kadabra"

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.didCloseHistoryScreen(didCancel: false, term: "Whooray")
        navigationController?.popViewController(animated: true)
    }
}
