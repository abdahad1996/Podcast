//
//  APIService.swift
//  Podcast
//
//  Created by prog on 2/23/19.
//  Copyright © 2019 prog. All rights reserved.
//

import Foundation
import Alamofire

class APIService {
    
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
}
