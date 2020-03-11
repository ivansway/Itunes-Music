//
//  NetworkManager.swift
//  Itunes Music
//
//  Created by Ivan Myrza on 02/03/2020.
//  Copyright © 2020 Ivan Myrza. All rights reserved.
//

import Foundation

protocol NetworkManagerDelegate {
    func refresh()
}

class NetworkManager {
    
    var jsonAlbum: Json_Base?
    var delegate: NetworkManagerDelegate?
    
    func getAlbumsData(completion: @escaping ([Results]?) -> ()) {
       
        guard let url = URL(string: "https://itunes.apple.com/search?term=music&limit=40") else { return }
        URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            if let data = data {
                do {
                    self?.jsonAlbum = try? JSONDecoder().decode(Json_Base.self, from: data)
                    self?.delegate?.refresh()
                }
                catch {
                    print(error.localizedDescription)
                }
                completion(self?.jsonAlbum?.results)
            }
        }.resume()
    }
}
