//
//  apiQuery.swift
//  Lab4-MaxGillespie
//
//  Created by Max Gillespie on 10/21/18.
//  Copyright © 2018 Max Gillespie. All rights reserved.
//

import Foundation
import UIKit

class query {
    let myKey = "b22035528c5cb1a161ee6f7b96e12d07"
    
    var searchResults: APIResults?
    var baseURL = "https://api.themoviedb.org/3/search/movie?api_key=b22035528c5cb1a161ee6f7b96e12d07&query="
    var currentSearch = ""
    
    init() {
        searchResults = nil
    }
    
    func searchForMovie(title:String) {
        let searchableTitle = parseTitle(title: title)
        currentSearch = searchableTitle
        let URL = "https://api.themoviedb.org/3/search/movie?api_key=\(myKey)&query=\(searchableTitle)"
        
        queryAPI(queryURL: URL)
        
        print("searching for \(title)...")
    }
    
    func parseTitle(title:String) -> String {
        let s = title.replacingOccurrences(of: " ", with: "+")
        
        return s
    }
    
    func queryAPI(queryURL: String) {
        guard let url = URL(string: queryURL) else {
            print("Error: cannot create URL")
            return
        }
        
        let request = URLRequest(url: url)
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let task = session.dataTask(with: request) {
            (data, response, error) in
            
            guard let responseData = data else {
                print("ERROR #1")
                return
            }
            
            guard error == nil else {
                print("ERROR #2")
                print(error!)
                return
            }

            do {
                let data = Data(responseData)

                guard let movieInfo = try JSONDecoder().decode(APIResults?.self, from: data)
                    else {
                        print("ERROR #3: JSON conversion")
                        return
                }
                
                self.searchResults = movieInfo
                //print(self.searchResults)
            } catch  {
                print("error trying to convert data to JSON")
                return
            }
        }
        task.resume()
    }
}
