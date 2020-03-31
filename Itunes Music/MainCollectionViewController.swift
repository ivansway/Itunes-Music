//
//  MainCollectionViewController.swift
//  Itunes Music
//
//  Created by Ivan Myrza on 02/03/2020.
//  Copyright © 2020 Ivan Myrza. All rights reserved.
//

import UIKit

class MainCollectionViewController: UICollectionViewController, UISearchBarDelegate {
    
    private let reuseIdentifier = "Cell"
    var sortedResults = [Results]()
    var filteredResults = [Results]()
    var isSearching = false

    
    var networkManager = NetworkManager()
    let mainViewCell = MainViewCell()
    let searchBar = UISearchBar()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settings()
    }
    
    func settings() {
        configureSearchBar()
        sortResults()
        setCollectionViewLayOut()
        networkManager.delegate = self
        self.searchBar.delegate = self
        collectionView.register(MainViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }
    
    func sortResults() {
        self.networkManager.getAlbumsData { (results) in
            guard let results = results else { return }
            self.sortedResults = results.sorted(by: {
                guard let firstParam = $0.artistName else { return false }
                guard let secondParam = $1.artistName else { return false }
                return firstParam < secondParam
            })
        }
    }
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isSearching {
            return self.filteredResults.count
        } else {
            return self.sortedResults.count
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MainViewCell
        
        let imageView = UIImageView()
        imageView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        if isSearching {
            self.mainViewCell.setUpCellImage(indexPath.row, self.filteredResults) { (image) in
                imageView.image = image
            }
        } else {
            self.mainViewCell.setUpCellImage(indexPath.row, self.sortedResults) { (image) in
                imageView.image = image
            }
        }
        cell.contentView.addSubview(imageView)
        return cell
    }
    
    func setCollectionViewLayOut() {
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 33, bottom: 30, right: 33)
        layout.itemSize = CGSize(width: self.view.frame.width/4, height: self.view.frame.width/4)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        collectionView!.collectionViewLayout = layout
    }
    
    func configureSearchBar() {
        self.searchBar.placeholder = "Search"
        self.navigationItem.titleView = searchBar
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text == nil || searchBar.text == "" {
            isSearching = false
            view.endEditing(true)
            self.collectionView.reloadData()
        } else {
            isSearching = true
            searchBar.setShowsCancelButton(true, animated: true)
            filteredResults = self.sortedResults.filter({ (results) -> Bool in
                guard let artistName = results.artistName else { return false }
                return artistName.lowercased().contains(searchText.lowercased())
            })
            self.collectionView.reloadData()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.text? = ""
        searchBar.setShowsCancelButton(false, animated: true)
        self.searchBar.endEditing(true)
        isSearching = false
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.collectionView.reloadData()
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailVC = storyboard?.instantiateViewController(identifier: "DetailViewController") as! DetailViewController
        detailVC.results = self.sortedResults
        detailVC.indexPath = indexPath.row
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
}
