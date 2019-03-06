//
//  EpisodeCellTableViewCell.swift
//  Podcast
//
//  Created by prog on 2/26/19.
//  Copyright © 2019 prog. All rights reserved.
//

import UIKit
import SDWebImage

class EpisodeCell: UITableViewCell {
    var episode:episode! {
        didSet{
            episodeTitle.text = episode.title
            EpisodeDescription.text = episode.description
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM dd, yyyy"
            episodePubDate.text = dateFormatter.string(from: episode.pubDate)
            guard let url = URL(string: episode.imageUrl ?? "")else {
                return
            }
            
            episodeImageView.sd_setImage(with:url)
            
        }
        
        
    }

    @IBOutlet weak var episodeImageView: UIImageView!
    @IBOutlet weak var episodeTitle: UILabel!
    @IBOutlet weak var EpisodeDescription: UILabel!
    @IBOutlet weak var episodePubDate: UILabel!
}
