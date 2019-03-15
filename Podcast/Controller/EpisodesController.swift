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
        setUpNavigationItem()
    }
    //  Mark:- right navigationItem
     let favoritedPodcastKey = "favoritedPodcastKey"

    func setUpNavigationItem(){
        let savedPodcast = UserDefaults.standard.savedPodcast()
       
//        let fetchBarButtonItem = UIBarButtonItem(title: "fetch", style: .plain, target: self, action: #selector(handleFetch))
        let hasFavorited = savedPodcast.index(where:{
            $0.artistName == self.podcast?.artistName && $0.trackName == self.podcast?.artistName
        }) != nil
        if hasFavorited{
            let heartBarButton = UIBarButtonItem(image: #imageLiteral(resourceName: "heart"), style: .plain, target: nil, action: nil)
            navigationItem.setRightBarButton(heartBarButton, animated: true)
        }else{
            let favoritesBarButtonItem = UIBarButtonItem(title: "favorites", style: .plain, target: self, action: #selector(handleSaveFavorite))
            navigationItem.setRightBarButtonItems([favoritesBarButtonItem], animated: true )
        }
        
    }
    @objc func handleSaveFavorite(){
        guard let podcast = podcast else {return }
        //1-turning podcast into data
       
        
        var listOfPodcast = UserDefaults.standard.savedPodcast()
        listOfPodcast.append(podcast)
        
        let data = NSKeyedArchiver.archivedData(withRootObject: listOfPodcast)
        UserDefaults.standard.set(data, forKey:favoritedPodcastKey )
        print("favorites")
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "heart"), style: .plain, target: nil, action: nil)
        showBadgeHighlights()
    }
    func showBadgeHighlights(){
        UIApplication.mainTabBarController()?.viewControllers?[0].tabBarItem.badgeValue = "new"
    }
    fileprivate func showDownloadBadgeHighlight() {
        UIApplication.mainTabBarController()?.viewControllers?[2].tabBarItem.badgeValue = "New"
    }
//    @objc func handleFetch(){
//        print("fetch")
//        let savedPodcast = UserDefaults.standard.savedPodcast()
//        savedPodcast.forEach { (p) in
//            print("\(p.trackName)")
//
//        }
//
//    }
    
    
    
    
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
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let downloadAction = UITableViewRowAction(style: .normal, title: "Download") { (_, _) in
            print("Downloading episode into UserDefaults")
            let episode = self.episodes[indexPath.row]
            UserDefaults.standard.downloadEpisode(episode: episode)
            
//             download the podcast episode using Alamofire
            APIService.shared.downloadEpisode(episode: episode)
            self.showDownloadBadgeHighlight()
            
        }
        
        return [downloadAction]
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
