//
//  PodcastSearchController.swift
//  Podcast
//
//  Created by prog on 1/7/19.
//  Copyright © 2019 prog. All rights reserved.
//

import UIKit
class PodcastSearchController : UITableViewController,UISearchBarDelegate{
    let podcasts = [
        Podcast(title: "football", artist: "abdul"),
        Podcast(title: "cricket", artist: "hadi"),
        Podcast(title: "hockey", artist: "qazi"),

    ]
    
    let cellID = "cellID"
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupSearchBar()
        
    }
    //MARK:- SETUP SEARCHCONTROLLER
    fileprivate func setupSearchBar(){
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("textdidchange")
    }
    
    //MARK:- SETUP TABLEVIEW
    fileprivate func setupTableView(){
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return podcasts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        let podcast = self.podcasts[indexPath.row]
        print(podcast.artist)
        cell.textLabel?.text = "\(podcast.title)\n\(podcast.artist)"
        cell.textLabel?.numberOfLines = -1

        cell.imageView?.image = UIImage(named :"appicon")
        return cell
    }
    
}
