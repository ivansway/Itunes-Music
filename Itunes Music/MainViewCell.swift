//
//  MainViewCell.swift
//  Itunes Music
//
//  Created by Ivan Myrza on 02/03/2020.
//  Copyright © 2020 Ivan Myrza. All rights reserved.
//

import UIKit

class MainViewCell: UICollectionViewCell {
    
    var networkManager = NetworkManager()
    
    func setUpCellImage(_ indexPath: Int,_ results: [Results]?, completion: @escaping (UIImage) -> ()) {
        
        guard let results = results,
            let URLString = results[indexPath].artworkUrl100,
            let url = URL(string: URLString) else { return }
        
        DispatchQueue.global().async {
            guard let data = try? Data(contentsOf: url) else { return }
            if let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    completion(image)
                }
            }
        }
    }
}
