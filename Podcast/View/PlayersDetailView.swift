//
//  PlayersDetailView.swift
//  Podcast
//
//  Created by prog on 2/27/19.
//  Copyright © 2019 prog. All rights reserved.
//

import UIKit
import SDWebImage
import AVKit

class PlayersDetailView: UIView {

    var episode:episode!{
        didSet{
            guard let url = URL(string: episode.imageUrl ?? "") else{
                return
            }
            
            episodeImageView.sd_setImage(with: url, completed: nil)
            miniEpisodeImageView.sd_setImage(with: url, completed: nil)
            descriptionLabel.text = episode.title
            miniTitleLabel.text=episode.title
            
            authorLabel.text = episode.author
            playEpisode()
        }
        
        
    }
    
    
    let player : AVPlayer = {
        let player = AVPlayer()
        player.automaticallyWaitsToMinimizeStalling = false

        return player
    
    
    }()
    
    fileprivate func playEpisode(){
        guard let url = URL(string: episode.streamUrl ) else{
            return
        }
        let playerItem = AVPlayerItem(url: url)
        player.replaceCurrentItem(with: playerItem)
        player.play()
        
    }
    
    
    fileprivate func observePlayerCurrentTime(){
        let Inteval = CMTimeMake(value: 1,timescale: 2)
        player.addPeriodicTimeObserver(forInterval: Inteval, queue: .main) {[weak self]  (time) in
//            let totalSeconds = CMTimeGetSeconds(time)
//            print(totalSeconds)
            self?.currentTimeLabel.text = time.toDisplayString()
            let totalDurationTime = self?.player.currentItem?.duration
            self?.durationLabel.text = totalDurationTime?.toDisplayString()
            self?.updateCurrentTimeSlider()
        }
    }
    fileprivate func updateCurrentTimeSlider(){
        let currentTime = CMTimeGetSeconds(player.currentTime())
        let totalDuration = CMTimeGetSeconds(player.currentItem?.duration ?? CMTimeMake(value: 20, timescale: 1))
        let percentage = (currentTime/totalDuration)
        currentTimeSlider.value = Float(percentage)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        
        addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePan)))
        
        observePlayerCurrentTime()
        let time = CMTimeMake(value: 1, timescale: 3)
        let times = [NSValue(time: time)]
        player.addBoundaryTimeObserver(forTimes: times, queue: .main) {[weak self ] in
         self?.enlargeEpisodeImageView()
            print("invoked after ")
        }
    }
    @objc func handlePan(gesture:UIPanGestureRecognizer){
        if gesture.state == .began{
            
        }
        else if gesture.state == .changed{
            let translation = gesture.translation(in: self.superview)
            self.transform = CGAffineTransform(translationX: 0, y: translation.y)
            print(translation.y)
            self.maximizedStackView.alpha = -translation.y/300
            self.miniPlayerView.alpha = 1 + translation.y/300
        }
        else if gesture.state == .ended{
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.transform = CGAffineTransform.identity
                self.miniPlayerView.alpha=1

            }, completion: nil)
        }
    }
    
    deinit {
        print("dfhfdh")
    }
    static func initFromNib() -> PlayersDetailView{
        return Bundle.main.loadNibNamed("PlayerDetailView", owner: self, options: nil)?.first as! PlayersDetailView
    }
    
    @objc func tapToMaximizePlayerDetailView(){
        guard  let tabBarController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController else{
            return
        }
        tabBarController.maximizePlayerDetailView(episode: nil)
    }
    //MARK:- IB ACTIONS AND OUTLET
    
    // maximizedstackview
    
    @IBAction func handleVolumeChange(_ sender: UISlider) {
        player.volume = sender.value
    }
    
    @IBAction func handleCurrentTimeSliderChange(_ sender: UISlider) {
       
            let percentage = currentTimeSlider.value
            guard let duration = player.currentItem?.duration else { return }
            let durationInSeconds = CMTimeGetSeconds(duration)
            let seekTimeInSeconds = Float64(percentage) * durationInSeconds
        let seekTime = CMTimeMakeWithSeconds(seekTimeInSeconds, preferredTimescale: 1)
            
            player.seek(to: seekTime)
        
    }
    fileprivate func seekToCurrentTime(delta:Int64){
        let currentTime = player.currentTime()
        let changeInTime = CMTimeMake(value: delta, timescale: 1)
        let appendedCmTime = CMTimeAdd(currentTime, changeInTime)
        player.seek(to: appendedCmTime)
    }
    @IBAction func handleFastForward(_ sender: Any) {
        seekToCurrentTime(delta: 15)
    }
    
    @IBAction func handleRewind(_ sender: Any) {
        seekToCurrentTime(delta: -15)
    }
    
    @IBOutlet weak var currentTimeSlider: UISlider!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var currentTimeLabel: UILabel!
    
     @IBAction func dismissBtn(_ sender: Any) {
        guard let tabBarController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController else {
            return
        }
        tabBarController.minimizePlayerDetailView()
        
     }
 
   
    
    @IBOutlet weak var authorLabel: UILabel!

    @IBOutlet weak var descriptionLabel: UILabel! {
        didSet{

                descriptionLabel.numberOfLines = 2

        }
    }
    




fileprivate func enlargeEpisodeImageView() {
    UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
        self.episodeImageView.transform = .identity
    })
}

fileprivate let shrunkenTransform = CGAffineTransform(scaleX: 0.7, y: 0.7)

fileprivate func shrinkEpisodeImageView() {
    UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
        self.episodeImageView.transform = self.shrunkenTransform
    })
}

@IBOutlet weak var episodeImageView: UIImageView! {
    didSet {
        episodeImageView.layer.cornerRadius = 5
        episodeImageView.clipsToBounds = true
        episodeImageView.transform = shrunkenTransform
    }
}

@IBOutlet weak var playPauseButton: UIButton! {
    didSet {
        playPauseButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
        playPauseButton.addTarget(self, action: #selector(handlePlayPause), for: .touchUpInside)
//        playPauseButton.addTarget(self, action: #selector(handlePlayPause), for: .touchUpInside)
    }
}

@objc func handlePlayPause() {
//    print("Trying to play and pause")
    if player.timeControlStatus == .paused {
        player.play()
        playPauseButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
        miniPlayPauseButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
        enlargeEpisodeImageView()
    } else {
        player.pause()
        playPauseButton.setImage(#imageLiteral(resourceName: "play"), for: .normal)
        miniPlayPauseButton.setImage(#imageLiteral(resourceName: "play"), for: .normal)

        
        shrinkEpisodeImageView()
    }
   
}
    
    //miniplayerview
    
    @IBOutlet weak var miniEpisodeImageView: UIImageView!
    @IBOutlet weak var miniTitleLabel: UILabel!{
        didSet{
        }
    }
    
    @IBOutlet weak var miniPlayPauseButton: UIButton! {
        didSet {
            miniPlayPauseButton.addTarget(self, action: #selector(handlePlayPause), for: .touchUpInside)
            miniPlayPauseButton.imageEdgeInsets = .init(top: 8, left: 8, bottom: 8, right: 8)
        }
    }
    
    @IBOutlet weak var miniFastForwardButton: UIButton! {
        didSet {
            miniFastForwardButton.imageEdgeInsets = .init(top: 8, left: 8, bottom: 8, right: 8)
            miniFastForwardButton.addTarget(self, action: #selector(handleFastForward(_:)), for: .touchUpInside)
        }
    }
    
    
    @IBOutlet weak var miniPlayerView: UIView!
    @IBOutlet weak var maximizedStackView: UIStackView!


}
