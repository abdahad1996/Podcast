//
//  RSSFeed.swift
//  Podcast
//
//  Created by prog on 2/27/19.
//  Copyright © 2019 prog. All rights reserved.
//

import Foundation
import FeedKit
extension RSSFeed {
    func toEpisodes() -> [episode] {
           var episodeArray = [episode]()
        let imageUrl = iTunes?.iTunesImage?.attributes?.href
        
        guard let feedItems = items else {
            return []
        }
        
        feedItems.forEach({ (item) in
            
            var ep = episode(feedItem: item)
            if ep.imageUrl == nil {
                ep.imageUrl = imageUrl
            }
            episodeArray.append(ep)
        })
        return episodeArray
    }
}
