//
//  APIResults.swift
//  Lab4-MaxGillespie
//
//  Created by Max Gillespie on 10/15/18.
//  Copyright © 2018 Max Gillespie. All rights reserved.
//

import Foundation

struct APIResults:Decodable {
    let page: Int
    let total_results: Int
    let total_pages: Int
    let results: [Movie]
}

struct Movie: Codable {
    let id: Int!
    let poster_path: String?
    let title: String
    let release_date: String
    let vote_average: Double
    let overview: String
    let vote_count:Int!
}

