//
//  DetailViewController.swift
//  Itunes Music
//
//  Created by Ivan Myrza on 02/03/2020.
//  Copyright © 2020 Ivan Myrza. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    let networkManager = NetworkManager()
    var results: [Results]?
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let artistLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Artist label"
        return label
    }()
    
    let genreLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Genre label"
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        self.view.addSubview(imageView)
        self.view.addSubview(artistLabel)
        self.view.addSubview(genreLabel)
        attachInfoToItems()
        setUpLayOuts()
    }
    
    func attachInfoToItems() {
        
        self.networkManager.getAlbumsData { (results) in
            
        guard let results = results,
            let URLString = results[0].artworkUrl100,
            let url = URL(string: URLString) else { return }
            
            DispatchQueue.global().async {
                
                guard let data = try? Data(contentsOf: url) else { return }
                
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.imageView.image = image
                    }
                }
            }
        }
    }
    
    func setUpLayOuts() {
        
        imageView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 100).isActive = true
        imageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        imageView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 1/2).isActive = true
        imageView.heightAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 1/2).isActive = true
        
        artistLabel.topAnchor.constraint(equalTo: self.imageView.bottomAnchor, constant: 10).isActive = true
        artistLabel.centerXAnchor.constraint(equalTo: self.imageView.centerXAnchor).isActive = true
        artistLabel.leftAnchor.constraint(equalTo: self.imageView.leftAnchor).isActive = true
        artistLabel.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 1/4).isActive = true
        artistLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        genreLabel.topAnchor.constraint(equalTo: self.artistLabel.bottomAnchor, constant: 10).isActive = true
        genreLabel.centerXAnchor.constraint(equalTo: self.imageView.centerXAnchor).isActive = true
        genreLabel.leftAnchor.constraint(equalTo: self.imageView.leftAnchor).isActive = true
        genreLabel.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 1/4).isActive = true
        genreLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
    
}
