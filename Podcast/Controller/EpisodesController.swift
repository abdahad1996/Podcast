//
//  EpisodesController.swift
//  Podcast
//
//  Created by prog on 2/26/19.
//  Copyright © 2019 prog. All rights reserved.
//

import Foundation
import UIKit
import FeedKit

class EpisodesController:UITableViewController{
    
    var podcast: Podcast? {
        didSet{
            navigationItem.title = podcast?.trackName
            parseEpisodes()
            
            
        }
    }
    fileprivate let cellID = "cellID"
    var episodes = [episode]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
    }
    
    //Mark:-PARSE XML USING FEEDKIT
    var timer : Timer?
    fileprivate func parseEpisodes(){
        guard let feedURL = podcast?.feedUrl else {
            return
        }
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (timer) in
            APIService.shared.parseEpisodeService(feedURL: feedURL) { (episodeArray) in
                self.episodes = episodeArray
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    
                }
            }
        })
       
        
    }
   
    
    //MARK:- SETUPTABLEVIEW
    
    fileprivate func setUpTableView(){
        let nib = UINib(nibName: "EpisodeCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: cellID)
        tableView.tableFooterView = UIView()

    }
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let activityIndicatorView = UIActivityIndicatorView(style: .whiteLarge)
        activityIndicatorView.color = .darkGray
        activityIndicatorView.startAnimating()
        return activityIndicatorView
        
    }
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return episodes.count == 0 ? 200:0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let episode = episodes[indexPath.row]
        guard let tabBarController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController else {
            return
        }
        tabBarController.maximizePlayerDetailView(episode: episode,playlistEpisodes: self.episodes)
        
  
        
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return episodes.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let  cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! EpisodeCell
        let ep = episodes[indexPath.row]
        cell.episode = ep
        
        return cell
            
        
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 132
    }
}
