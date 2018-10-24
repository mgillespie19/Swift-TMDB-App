//
//  cvDataGen.swift
//  Lab4-MaxGillespie
//
//  Created by Max Gillespie on 10/21/18.
//  Copyright © 2018 Max Gillespie. All rights reserved.
//

import Foundation

// COLLECTION VIEW POPULATION
func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
}

func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 21
}

func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cvCell", for: indexPath)
    
    cell.backgroundColor = UIColor.black
    
    return cell
}

func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
    let movieDetails = movieView()
    
    navigationController?.pushViewController(movieDetails, animated: true)
}
