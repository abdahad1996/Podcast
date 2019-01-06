//
//  MainTabBarController.swift
//  Podcast
//
//  Created by prog on 1/7/19.
//  Copyright © 2019 prog. All rights reserved.
//

import UIKit
class MainTabBarController : UITabBarController{
    override func viewDidLoad() {
        super.viewDidLoad()
        UINavigationBar.appearance().prefersLargeTitles = true
        tabBar.tintColor = .purple

       
        setupViewControllers()
        
    }
    //MARK:-SETUP CONTROLLER
    fileprivate func setupViewControllers(){
        
        viewControllers = [
            generateNavigationViewController(with: PodcastSearchController(), title: "favourties", image:UIImage(named:"favorites")! ),
            generateNavigationViewController(with: ViewController(), title: "search", image:UIImage(named:"search")! ),
            generateNavigationViewController(with: ViewController(), title: "download", image:UIImage(named:"downloads")! )

            
            
        ]
    }
    
    
    //MARK:-HELPER FUNCTION

    
    fileprivate func  generateNavigationViewController (with rootViewController : UIViewController,title :String,image:UIImage) -> UIViewController{
        let navigationController = UINavigationController(rootViewController: rootViewController)
        rootViewController.navigationItem.title = title
        navigationController.tabBarItem.title = title
        navigationController.tabBarItem.image = image
        
        return navigationController
    }
}
