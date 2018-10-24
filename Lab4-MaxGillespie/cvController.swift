//
//  cvController.swift
//  Lab4-MaxGillespie
//
//  Created by Max Gillespie on 10/21/18.
//  Copyright © 2018 Max Gillespie. All rights reserved.
//

import UIKit
import Foundation

class cvController: UIViewController, UICollectionViewDataSource, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var allMovies: UICollectionView!
    @IBOutlet weak var allFavorites: UITableView!
    
    var movies:[Movie] = []
    var imageCache:[UIImage] = []
    var cvFavorites:[String] = []
    let q = query()
    
    // var favorites:[Movie] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Movies"
        
        if (allMovies.self != nil){
            loadMovies()
        }
        
        if allFavorites != nil {
            loadFavorites()
        }
        print ("viewdidload")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if allFavorites != nil && allFavorites.self != nil && allFavorites.dataSource != nil {
            
            allFavorites.reloadData()
            print("favorites loaded")
        }
    }
    
    func loadMovies() {
            searchBar.delegate = self
        
            allMovies.dataSource = self
            allMovies.delegate = self
            allMovies.allowsSelection = true
            allMovies.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cvCell")
    }
    
    func loadFavorites() {
        allFavorites.dataSource = self
        allFavorites.delegate = self
        allFavorites.allowsSelection = true
        allFavorites.register(UITableViewCell.self, forCellReuseIdentifier: "tvCell")
    }
    
    // TABLE VIEW POPULATION
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var favorites:[Movie] = []
        if let data = UserDefaults.standard.value(forKey:"favorites") as? Data {
            favorites = try! PropertyListDecoder().decode(Array<Movie>.self, from: data)
        }
        
        return favorites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var favorites:[Movie] = []
        if let data = UserDefaults.standard.value(forKey:"favorites") as? Data {
            favorites = try! PropertyListDecoder().decode(Array<Movie>.self, from: data)
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "tvCell")! as UITableViewCell
        
        if (favorites.count > 0) {
            //cell.textLabel!.text = favorites[indexPath.row].title
            cell.textLabel!.text = favorites[indexPath.row].title
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var favorites:[Movie] = []
        if let data = UserDefaults.standard.value(forKey:"favorites") as? Data {
            favorites = try! PropertyListDecoder().decode(Array<Movie>.self, from: data)
        }
        
        let movieDetails = movieView()
        
        movieDetails.populateFavorites(mov: favorites[indexPath[1]])
        
        navigationController?.pushViewController(movieDetails, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            print("Deleted")
            
            var favorites:[Movie] = []
            if let data = UserDefaults.standard.value(forKey:"favorites") as? Data {
                favorites = try! PropertyListDecoder().decode(Array<Movie>.self, from: data)
                }
            
            favorites.remove(at: indexPath[1])
            UserDefaults.standard.set(try? PropertyListEncoder().encode(favorites), forKey: "favorites")
            allFavorites.reloadData()
        }
    }
    
    
    // COLLECTION VIEW POPULATION
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cvCell", for: indexPath)
        
        cell.backgroundColor = UIColor.white
        
        if indexPath[1] < imageCache.count {
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 120, height: 160))
            let image = imageCache[indexPath[1]]
            imageView.image = image
            
            let titleView = UILabel(frame: CGRect(x:0, y:120, width:120, height: 40))
            titleView.text = movies[indexPath[1]].title
            titleView.backgroundColor = UIColor(displayP3Red: 0.2, green: 0.2, blue: 0.2, alpha: 0.6)
            titleView.font = UIFont(name: titleView.font.fontName, size: 15)
            titleView.textAlignment = .center
            titleView.textColor = UIColor.white
            
            cell.contentView.addSubview(imageView)
            cell.contentView.addSubview(titleView)
        }
        
        return cell
    }
    
    
    
    func loadResults(search: String) {
        q.searchForMovie(title: search)
        
        if let results = q.searchResults {
            movies = (q.searchResults?.results)!
        }
    }
    
    func cacheImages() {
        imageCache = []
        var count = 0
        
        for movie in movies {
            if (count > 21) {
                break
            }
            
            guard let path = movie.poster_path else {
                print ("ERROR #5")
                imageCache.append(UIImage(named: "imgNotFound.png")! )
                continue
            }
                        
            let urlString = "https://image.tmdb.org/t/p/w200/\(path)"
            
            guard let url = URL(string: urlString) else {
                print ("ERROR #6")
                imageCache.append(UIImage(contentsOfFile: "imgNotFound.png")! )
                continue
            }
            
            guard let data = try? Data(contentsOf: url) else {
                print ("ERROR #7")
                imageCache.append(UIImage(contentsOfFile: "imgNotFound.png")! )
                continue
            }
            
            guard let image = UIImage(data: data) else {
                print ("ERROR #8")
                imageCache.append(UIImage(contentsOfFile: "imgNotFound.png")! )
                continue
            }
            imageCache.append(image)
            
            
            count += 1
        }
    }
}

extension cvController: UICollectionViewDelegate {
   
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movieDetails = movieView()
        
        movieDetails.populateView(mov: movies[indexPath[1]], img:imageCache[indexPath[1]])
        
        navigationController?.pushViewController(movieDetails, animated: true)
    }
}


extension cvController: UISearchBarDelegate {
    // Searchbar searching
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        DispatchQueue.global(qos: .userInitiated).async {
            
            self.loadResults(search: searchText) // load movies array in cvController
            self.cacheImages()
            
            DispatchQueue.main.async {
                self.allMovies.reloadData()
            }
        }
        
    }
    
    
}


