//
//  MainCollectionViewController.swift
//  Itunes Music
//
//  Created by Ivan Myrza on 02/03/2020.
//  Copyright © 2020 Ivan Myrza. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class MainCollectionViewController: UICollectionViewController, UISearchBarDelegate {
    
    var networkManager = NetworkManager()
    let mainViewCell = MainViewCell()
    let detailViewController = DetailViewController()
    
    let searchBar = UISearchBar()
    var sortedResults = [Results]()
    var filteredResults = [Results]()
    var isSearching = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureSearchBar()
        sortResults()
        setCollectionViewLayOut()
        networkManager.delegate = self
        self.searchBar.delegate = self
        
        collectionView.register(MainViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.allowsSelection = true
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
            return filteredResults.count
        } else {
            return sortedResults.count
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MainViewCell
        
        let imageView = UIImageView()
        imageView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)

        if isSearching {
            self.mainViewCell.setUpCellImage(indexPath.row, filteredResults) { (image) in
                imageView.image = image
            }
        } else {
            self.mainViewCell.setUpCellImage(indexPath.row, sortedResults) { (image) in
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
            self.filteredResults = sortedResults.filter({ (results) -> Bool in
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
        self.isSearching = false
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.collectionView.reloadData()
    }

    
    // MARK: UICollectionViewDelegate
    
    /*
     // Uncomment this method to specify if the specified item should be highlighted during tracking
     override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
     return true
     }
     */
    
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        
        self.navigationController?.pushViewController(DetailViewController(), animated: false)

        return true
    }
    
    
    /*
     // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
     override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
     return false
     }
     
     override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
     return false
     }
     
     override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
     
     }
     */
    
}

extension MainCollectionViewController: NetworkManagerDelegate {
    
    func refresh() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
}
