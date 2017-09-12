//
//  ViewController.swift
//  RepoFinder
//
//  Created by Konstantin Efimenko on 9/12/17.
//  Copyright © 2017 Konstantin Efimenko. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    
    fileprivate let searchHistoryKey = "SearchHistoryKey"
    fileprivate let cellReuseIdentifier = "Cell"
    
    fileprivate enum ShowMode {
        case results
        case history
    }
    
    fileprivate var resultList = [String]()
    fileprivate var showMode = ShowMode.history
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        resultList = ArchiveService().getHistory(key: searchHistoryKey)
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension SearchViewController : UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        RestApi().getRepositories(pattern: searchBar.text!,
                                  success: {array in
                                    DispatchQueue.main.async{
                                        self.showMode = ShowMode.results
                                        ArchiveService().addToSaved(searchBar.text!, key: self.searchHistoryKey)
                                        self.resultList = array
                                        self.tableView.reloadData()
                                    }
                                    },
                                  fail: {})
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        showMode = ShowMode.history
        resultList = ArchiveService().getHistory(key: searchHistoryKey)
        tableView.reloadData()
    }

}

extension SearchViewController : UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier)
        cell?.textLabel?.text = resultList[indexPath.row]
        return cell!
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if showMode == ShowMode.history {
           searchBar.text = resultList[indexPath.row]
        }
    }
}
