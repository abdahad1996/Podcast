//
//  Favorites.swift
//  Podcast
//
//  Created by prog on 3/10/19.
//  Copyright © 2019 prog. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class FavoritesController: UICollectionViewController,UICollectionViewDelegateFlowLayout {

    var podcastSavedlocallyArray = UserDefaults.standard.savedPodcast()
    override func viewDidLoad() {
        super.viewDidLoad()

      setUpCollectionView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        collectionView.reloadData()
        podcastSavedlocallyArray=UserDefaults.standard.savedPodcast()
        UIApplication.mainTabBarController()?.viewControllers?[0].tabBarItem.badgeValue = nil

    }
    // setupcollectionview
    func setUpCollectionView(){
        collectionView?.backgroundColor = .white
        self.collectionView!.register(favoriteCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        let gestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPressDelete))
        collectionView.addGestureRecognizer(gestureRecognizer)
    }
    

   
    // Mark:LongPressDelete from Favorite controller
    @objc func longPressDelete(gesture:UILongPressGestureRecognizer){
        let location = gesture.location(in: collectionView)
        guard let selectedIndexItem = collectionView.indexPathForItem(at: location) else {return}
        let alertController = UIAlertController(title: "Remove Podcast?", message: nil, preferredStyle: .actionSheet)
        
        alertController.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { (_) in
            let selectedPodcast = self.podcastSavedlocallyArray[selectedIndexItem.item]
            self.podcastSavedlocallyArray.remove(at: selectedIndexItem.item)
            self.collectionView.deleteItems(at: [selectedIndexItem])
            UserDefaults.standard.deletePodcast(podcast: selectedPodcast)
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alertController, animated: true)

        
    }
    
    
    // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let savedPodcast = UserDefaults.standard.savedPodcast()
        let episodeViewController = EpisodesController()
        episodeViewController.podcast = savedPodcast[indexPath.item]
        navigationController?.pushViewController(episodeViewController, animated: true)
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return podcastSavedlocallyArray.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? favoriteCell else{
            return UICollectionViewCell()
        }
        cell.podcast = podcastSavedlocallyArray[indexPath.item]
        
        
    
        // Configure the cell
    
        return cell
    }

    //MARK:- UICOLLECTIONVIEWDELEGATEFLOWLAYOUT
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 3*16)/2
        return CGSize(width: width, height: width+46)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
       return  UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
    
    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
