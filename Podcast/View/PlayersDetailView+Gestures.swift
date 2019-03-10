//
//  PlayersDetailView+Gestures.swift
//  Podcast
//
//  Created by prog on 3/6/19.
//  Copyright © 2019 prog. All rights reserved.
//

import Foundation
import UIKit
extension PlayersDetailView{
    

    
    @objc func handlePan(gesture:UIPanGestureRecognizer){
        if gesture.state == .began{
            
        }
        else if gesture.state == .changed{
            handlePanChanged(gesture)
        }
        else if gesture.state == .ended{
            
            handlePanEnded(gesture: gesture)
        }
    }
    // pan gesture methods
     func handlePanEnded( gesture: UIPanGestureRecognizer) {
        let velocity = gesture.velocity(in: self.superview)
        let translation = gesture.translation(in: self.superview)
        print("traslation : \(translation.y) velocity : \(velocity.y)")
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            
            self.transform = CGAffineTransform.identity
            
            if translation.y < -300 || velocity.y < -500{
              UIApplication.mainTabBarController()?.maximizePlayerDetailView(episode: nil)
//                gesture.isEnabled=false
                
            }
            else{
                
                self.miniPlayerView.alpha=1
                self.maximizedStackView.alpha=0
            }
            
        }, completion: nil)
    }
    
     func handlePanChanged(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self.superview)
        self.transform = CGAffineTransform(translationX: 0, y: translation.y)
        print(translation.y)
        self.maximizedStackView.alpha = -translation.y/300
        self.miniPlayerView.alpha = 1 + translation.y/300
    }
   
    
    @objc func tapToMaximizePlayerDetailView(){
        UIApplication.mainTabBarController()?.maximizePlayerDetailView(episode: nil)

//        panGesture.isEnabled=false
    }
    
    
}
