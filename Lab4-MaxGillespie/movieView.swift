//
//  fetchData.swift
//  Lab4-MaxGillespie
//
//  Created by Max Gillespie on 10/21/18.
//  Copyright © 2018 Max Gillespie. All rights reserved.
//

import Foundation
import UIKit

class movieView: cvController, UINavigationBarDelegate {
    var currentMovie:Movie? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(displayP3Red: 0.95, green: 0.95, blue: 0.95, alpha: 1)
    }
    
    func populateView(mov:Movie, img:UIImage) {
        currentMovie = mov
        let w = UIScreen.main.bounds.width
        let h = UIScreen.main.bounds.height
        let movieTitle = mov.title
        
        self.navigationItem.title = movieTitle
        
        let greyBgd = UIImageView(frame: CGRect(x:0, y:60, width: w, height: h/2 - 50))
        greyBgd.backgroundColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1)
        
        let moviePic = UIImageView(frame: CGRect(x:1.25*w/5, y:60, width: 2.5*w/5, height:h/2 - 50))
        moviePic.image = img
        
        let released = UILabel(frame: CGRect(x: 0, y: h/2 + 30, width: w, height: 50))
        released.text = "Released: \(String(mov.release_date).prefix(4))"
        released.font = UIFont(name: released.font.fontName, size: 25)
        released.textAlignment = .center
        
        let score = UILabel(frame: CGRect(x: 0, y: h/2 + 90, width: w, height: 50))
        score.text = "Score: \(mov.vote_average)/10"
        score.font = UIFont(name: score.font.fontName, size: 25)
        score.textAlignment = .center
        
        let rating = UILabel(frame: CGRect(x: 0, y: h/2 + 150, width: w, height: 50))
        rating.text = "Number of Voters: \(mov.vote_count!)"
        rating.font = UIFont(name: rating.font.fontName, size: 25)
        rating.textAlignment = .center
        
        let addtoFavorites = UIButton(frame: CGRect(x:w/4, y:h/2+210, width:w/2, height:50))
        addtoFavorites.setTitle("add to favorites", for: .normal)
        addtoFavorites.backgroundColor = UIColor.red
        addtoFavorites.layer.cornerRadius = 10
        addtoFavorites.addTarget(self, action: #selector(addFavorites), for: .touchUpInside)
        
        
        let tmdbCredit = UILabel(frame: CGRect(x: 0, y: h - 90, width: w, height: 50))
        tmdbCredit.text = "all info taken from TMDB (the movie darabase) api"
        tmdbCredit.font = UIFont(name: tmdbCredit.font.fontName, size: 8)
        tmdbCredit.textAlignment = .center
        
        
        view.addSubview(greyBgd)
        view.addSubview(moviePic)
        view.addSubview(released)
        view.addSubview(score)
        view.addSubview(rating)
        view.addSubview(addtoFavorites)
        view.addSubview(tmdbCredit)
    }
    
    func populateFavorites (mov:Movie) {
        let w = self.view.frame.size.width
        let h = self.view.frame.size.height
        self.navigationItem.title = "Description"

        
        let scrollDescripton = UIScrollView(frame: CGRect(x: w/10, y: h/10, width: 4*w/5, height: 4*h/5))
        let description = UILabel(frame: CGRect(x: 0, y:0, width: 4*w/5, height: 4*h/5))
        
        description.font = UIFont(name: "Arial", size: 24.0)
        description.text = mov.overview
        description.numberOfLines = 0
        description.sizeToFit()
        description.lineBreakMode = .byWordWrapping

        
        scrollDescripton.addSubview(description)
        
        view.addSubview(scrollDescripton)
    }
    
    @objc func addFavorites (sender: UIButton!) {
        var favorites:[Movie] = []
        
        if let data = UserDefaults.standard.value(forKey:"favorites") as? Data {
            favorites = try! PropertyListDecoder().decode(Array<Movie>.self, from: data)
        }
        
        favorites.append(currentMovie!)
        
        
        UserDefaults.standard.set(try? PropertyListEncoder().encode(favorites), forKey: "favorites")
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
