//
//  UserDefaults.swift
//  Podcast
//
//  Created by prog on 3/11/19.
//  Copyright © 2019 prog. All rights reserved.
//

import Foundation
import UIKit
extension UserDefaults {
    static  let favoritedPodcastKey = "favoritedPodcastKey"
    static let downloadedEpisodesKey = "downloadedEpisodesKey"

    func savedPodcast() ->[Podcast]{
        guard let savedData = UserDefaults.standard.data(forKey: UserDefaults.favoritedPodcastKey) else{return[]}
        guard let SavedPodcast = NSKeyedUnarchiver.unarchiveObject(with: savedData ) as? [Podcast] else {return[]}
        return SavedPodcast
    }
    //for saving downloaded ep into userdefault at 0 index
    func downloadEpisode(episode: episode) {
        do {
            var episodes = downloadedEpisodes()
            //            episodes.append(episode)
            //insert episode at the front of the list
            episodes.insert(episode, at: 0)
            let data = try JSONEncoder().encode(episodes)
            UserDefaults.standard.set(data, forKey: UserDefaults.downloadedEpisodesKey)
            
        } catch let encodeErr {
            print("Failed to encode episode:", encodeErr)
        }
    }
    //for fetching array of downloaded episodes
    func downloadedEpisodes() -> [episode] {
        guard let episodesData = data(forKey: UserDefaults.downloadedEpisodesKey) else { return [] }
        
        do {
            let episodes = try JSONDecoder().decode([episode].self, from: episodesData)
            return episodes
        } catch let decodeErr {
            print("Failed to decode:", decodeErr)
        }
        
        return []
    }
    //deleting the episodes from episdoe array by filtering and saving again in userdefault
    func deleteEpisode(episode: episode) {
        let savedEpisodes = downloadedEpisodes()
        let filteredEpisodes = savedEpisodes.filter { (e) -> Bool in
            // you should use episode.collectionId to be safer with deletes
            return e.title != episode.title
        }
        
        do {
            let data = try JSONEncoder().encode(filteredEpisodes)
            UserDefaults.standard.set(data, forKey: UserDefaults.downloadedEpisodesKey)
        } catch let encodeErr {
            print("Failed to encode episode:", encodeErr)
        }
    }
    
    // filter those podcast that are not present
    func deletePodcast(podcast: Podcast) {
        let podcasts = self.savedPodcast()
        let filteredPodcasts = podcasts.filter { (p) -> Bool in
            return p.trackName != podcast.trackName && p.artistName != podcast.artistName
        }
        let data = NSKeyedArchiver.archivedData(withRootObject: filteredPodcasts)
        UserDefaults.standard.set(data, forKey: UserDefaults.favoritedPodcastKey)
    }

}
