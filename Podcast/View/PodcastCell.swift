//
//  PodcastCell.swift
//  Podcast
//
//  Created by prog on 2/23/19.
//  Copyright © 2019 prog. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage
class PodcastCell:UITableViewCell{
    
    @IBOutlet weak var trackName: UILabel!
    @IBOutlet weak var artistName: UILabel!
    @IBOutlet weak var episodeCount: UILabel!
    @IBOutlet weak var podcastImageView: UIImageView!
    
    var podcast:Podcast! {
        didSet{
            trackName.text = podcast.trackName
            artistName.text = podcast.artistName
            episodeCount.text = "\(podcast.trackCount ?? 0 ) episodes"
            guard let url = URL(string: podcast.artworkUrl600 ?? "") else {
                return
            }
            
            
            podcastImageView.sd_setImage(with: url, completed: nil)
        }
    }
}
