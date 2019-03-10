//
//  MainTabBarController.swift
//  Podcast
//
//  Created by prog on 2/22/19.
//  Copyright © 2019 prog. All rights reserved.
//

import UIKit
class MainTabBarController : UITabBarController{
    override func viewDidLoad() {
        super .viewDidLoad()
        UINavigationBar.appearance().prefersLargeTitles = true
//        view.backgroundColor = .red
        setUpTabControllers()
        tabBar.tintColor = .purple
        setUpPlayersDetailView()
//        perform(#selector(minimizePlayerDetailView), with: nil, afterDelay: 1)
        
    }
    
    
    //Mark:- PLAYER DETAIL VIEW FUNCTIONS
    let playerDetailView = PlayersDetailView.initFromNib()
    var maximizedConstraint:NSLayoutConstraint!
    var minimizedConstraint:NSLayoutConstraint!
    var bottomAnchorConstraint: NSLayoutConstraint!

    
    func maximizePlayerDetailView(episode:episode?,playlistEpisodes: [episode] = []){
        
        minimizedConstraint.isActive = false
        maximizedConstraint.isActive = true
        maximizedConstraint.constant = 0
        
        bottomAnchorConstraint.constant = 0
        
        
       
        if episode != nil{
            playerDetailView.episode = episode
        }
        playerDetailView.playlistEpisodes = playlistEpisodes

        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
//            self.tabBar.transform = .identity
            self.tabBar.transform = CGAffineTransform(translationX: 0, y: 100)

            self.playerDetailView.maximizedStackView.alpha=1
            self.playerDetailView.miniPlayerView.alpha=0
        }, completion: nil)
        
    }
    
    @objc func minimizePlayerDetailView(){
        print("111")
        maximizedConstraint.isActive = false
        bottomAnchorConstraint.constant = view.frame.height
        minimizedConstraint.isActive = true
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
//            self.tabBar.transform = CGAffineTransform(translationX: 0, y: 100)
                        self.tabBar.transform = .identity

            self.playerDetailView.maximizedStackView.alpha=0
            self.playerDetailView.miniPlayerView.alpha=1

        }, completion: nil)
        
    }
    
    func setUpPlayersDetailView(){
        view.insertSubview(playerDetailView, belowSubview: tabBar)
        playerDetailView.translatesAutoresizingMaskIntoConstraints = false
        minimizedConstraint=playerDetailView.topAnchor.constraint(equalTo: tabBar.topAnchor, constant: -64)
//        minimizedConstraint.isActive=true
        
        maximizedConstraint=playerDetailView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height)
        maximizedConstraint.isActive = true
        bottomAnchorConstraint = playerDetailView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: view.frame.height)
        bottomAnchorConstraint.isActive = true
        
        playerDetailView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0)
            .isActive=true
        playerDetailView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive=true
       
    }
    
    
    //MARK:- TABCONTROLLERS
    func setUpTabControllers(){
        let ColletionViewFlowLayout = UICollectionViewFlowLayout()
        let favouriteController = FavoritesController(collectionViewLayout: ColletionViewFlowLayout)
        viewControllers = [generateNavigationController(for: favouriteController, title: "Favourites", image: UIImage(named: "favorites") ?? UIImage())
            ,generateNavigationController(for: PodcastSearchController(), title: "Search", image: UIImage(named: "search") ?? UIImage()),
             generateNavigationController(for: ViewController(), title: "Download", image: UIImage(named: "downloads") ?? UIImage())
        
        
        
        ]
    }
    //MARK:- HELPER FUNCTION
    func generateNavigationController(for rootViewController : UIViewController,title:String,image:UIImage) -> UIViewController {
        let navController = UINavigationController(rootViewController: rootViewController)
        rootViewController.navigationItem.title = title
        rootViewController.tabBarItem.title = title
        rootViewController.tabBarItem.image = image
        return navController
    }
}
