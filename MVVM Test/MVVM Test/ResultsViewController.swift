//
//  ResultsViewController.swift
//  MVVM Test
//
//  Created by Eugene Kuropatenko on 12/09/17.
//  Copyright © 2017 Home. All rights reserved.
//

import UIKit

class ResultsViewController: UIViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var mainTable: UITableView!
    @IBOutlet var blockView: UIView!
    @IBOutlet var searchView: UIView!
    
    var searchProvider:SearchProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchProvider = SearchProvider(updateCloser: {
            self.mainTable.reloadData()
        }, storageProvider: AppDelegate.storageProvider)
        mainTable.tableHeaderView = searchBar
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "selectRequest" {
            if let vc = segue.destination as? RequestsViewController {
                vc.selectCompletion =  { [weak self] request in
                    self?.searchProvider.storedRequest = request
                    self?.searchBar.text = request.name
                }
            }
        }
    }
    
    @IBAction func stopSearch(_ sender: Any) {
        mainTable.backgroundView = nil
        searchProvider?.stopSearch()
    }
}

extension ResultsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = searchProvider.results.count
        if count == 0 {
            tableView.separatorStyle = .none
            if tableView.backgroundView == nil || !searchProvider.isSearching {
                tableView.backgroundView = blockView
            }
        } else {
            tableView.separatorStyle = .singleLine
            tableView.backgroundView = nil
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let result = searchProvider.results[indexPath.row]
        var cell = tableView.dequeueReusableCell(withIdentifier: "repositoryCell", for: indexPath) as! RepositoryCellProtocol
        cell.title = result.title
        cell.descr = result.descr
        cell.stars = result.stars
        return cell as! UITableViewCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let result = searchProvider.results[indexPath.row]
        if let url = URL(string: result.path ?? ""), UIApplication.shared.canOpenURL(url) == true {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension ResultsViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchProvider?.search(searchBar.text ?? "")
        searchView.frame = mainTable.bounds
        mainTable.backgroundView = searchView
        searchBar.resignFirstResponder()
    }
}
