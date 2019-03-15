//
//  Podcast.swift
//  Podcast
//
//  Created by prog on 1/7/19.
//  Copyright © 2019 prog. All rights reserved.
//

import Foundation
struct SearchResult:Decodable {
    let resultCount:Int?
    let results : [Podcast]
}
class Podcast:NSObject, Decodable,NSCoding {
    func encode(with aCoder: NSCoder) {
        print("podcast turned into data")
        aCoder.encode(trackName ?? "", forKey: "trackNameKey")
        aCoder.encode(artistName ?? "", forKey: "artistNameKey")
        aCoder.encode(artworkUrl600 ?? "", forKey: "artworkKey")
        aCoder.encode(feedUrl ?? "", forKey: "feedKey")
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.trackName = aDecoder.decodeObject(forKey: "trackNameKey") as? String
        self.artistName = aDecoder.decodeObject(forKey: "artistNameKey") as? String
        self.artworkUrl600 = aDecoder.decodeObject(forKey: "artworkKey") as? String
        self.feedUrl = aDecoder.decodeObject(forKey: "feedKey") as? String
        
    }
    
    var trackName :String?
    var artistName : String?
    var artworkUrl600:String?
    var trackCount:Int?
    var feedUrl:String?
}

