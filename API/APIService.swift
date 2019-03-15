//
//  APIService.swift
//  Podcast
//
//  Created by prog on 2/23/19.
//  Copyright © 2019 prog. All rights reserved.
//

import Foundation
import Alamofire
import FeedKit

extension Notification.Name {
    
    static let downloadProgress = NSNotification.Name("downloadProgress")
    static let downloadComplete = NSNotification.Name("downloadComplete")
}

class APIService {
    typealias EpisodeDownloadCompleteTuple = (fileUrl: String, episodeTitle: String)
    let baseUrl = "https://itunes.apple.com/search"

    static let shared = APIService()
    
    
    
    func fetchPodcast(searchText :String,completionHandler: @escaping ([Podcast]) -> () ){
        let parameters = ["term" : searchText,"media" : "podcast"]
        Alamofire.request(baseUrl, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseData { (response) in
            if let error = response.error{
                print("error is \(error)")
            }
            guard let data = response.data  else {
                
                return
                
            }
            do {
                let searchArray = try JSONDecoder().decode(SearchResult.self,from: data)
//                self.podcasts = searchArray.results
//                self.tableView.reloadData()
                completionHandler(searchArray.results)
                
                
            }
            catch{
                print(error)
            }
            
        }
    }
    func downloadEpisode(episode:episode){
        let downloadRequest = DownloadRequest.suggestedDownloadDestination()
        Alamofire.download(episode.streamUrl, to: downloadRequest).downloadProgress { (Progress) in
            
            
            
            print(Progress.fractionCompleted)
            
            NotificationCenter.default.post(name: .downloadProgress, object: nil, userInfo: ["title": episode.title, "progress": Progress.fractionCompleted])
            
            }.response { (resp) in
                print(resp.destinationURL?.absoluteString ?? "hahahaha" )
                
                let episodeDownloadComplete = EpisodeDownloadCompleteTuple(fileUrl: resp.destinationURL?.absoluteString ?? "", episode.title)
                NotificationCenter.default.post(name: .downloadComplete, object: episodeDownloadComplete, userInfo: nil)
                
                
                var downloadedEpisodes = UserDefaults.standard.downloadedEpisodes()
                guard let index = downloadedEpisodes.index(where:{
                    $0.title == episode.title && $0.author == episode.author
                }) else {return}
                do {
                    
                    let data = try JSONEncoder().encode(downloadedEpisodes)
                    UserDefaults.standard.set(data, forKey: UserDefaults.downloadedEpisodesKey)
                } catch let err {
                    print("Failed to encode downloaded episodes with file url update:", err)
                }
//                print(downloadedEpisodes[index].fileURL ?? "no fileurl")
        }
        
        
        
        var downloadedEpisodes = UserDefaults.standard.downloadedEpisodes()
       guard let index = downloadedEpisodes.index(where:{
            $0.title == episode.title && $0.author == episode.author
       }) else {return}
        do {
            
            let data = try JSONEncoder().encode(downloadedEpisodes)
            UserDefaults.standard.set(data, forKey: UserDefaults.downloadedEpisodesKey)
        } catch let err {
            print("Failed to encode downloaded episodes with file url update:", err)
        }
        print(downloadedEpisodes[index].fileUrl ?? "no fileurl")
        
        
    }
    
    func parseEpisodeService(feedURL:String ,completionHandler:@escaping ([episode])->()){
        guard let url = URL(string: feedURL) else {
            return
        }
        
        DispatchQueue.global(qos: .background).async {
            let parser = FeedParser(URL: url)
            parser.parseAsync { (Result) in
                
                if Result.isSuccess {
                    guard let feed = Result.rssFeed else {
                        return
                    }
                    completionHandler(feed.toEpisodes())
                    //                self.episodes = feed.toEpisodes()
                    
                    
                    
                }
                else {
                    print("the error is \(String(describing: Result.error))")
                }
                
            }
        }
       
    }
}
