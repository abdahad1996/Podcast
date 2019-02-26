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
        
    }
    
    //MARK:- TABCONTROLLERS
    func setUpTabControllers(){
        
        viewControllers = [generateNavigationController(for: ViewController(), title: "Favourites", image: UIImage(named: "favorites") ?? UIImage())
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
