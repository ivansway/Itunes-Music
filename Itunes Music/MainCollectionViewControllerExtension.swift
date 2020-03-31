//
//  MainCollectionViewControllerExtension.swift
//  Itunes Music
//
//  Created by Ivan Myrza on 18/03/2020.
//  Copyright © 2020 Ivan Myrza. All rights reserved.
//

import Foundation

extension MainCollectionViewController: NetworkManagerDelegate {
    
    func refresh() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
}
