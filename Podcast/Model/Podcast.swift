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
struct Podcast:Decodable {
    let trackName :String?
    let artistName : String?
    let artworkUrl600:String?
    let trackCount:Int?
    let feedUrl:String?
}

