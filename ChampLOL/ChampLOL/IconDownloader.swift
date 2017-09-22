//
//  IconDownloader.swift
//  ChampLOL
//
//  Created by Chung Tran on 9/22/17.
//  Copyright © 2017 Chung Tran. All rights reserved.
//
import Foundation

class IconDownloader {
    
    var character: Character?
    var completionHandler: (() -> Void)?
    var downloadTask: URLSessionDataTask?
    
    func startDownload() {
        guard character != nil else {return}
        guard let url = URL(string: character!.url_Champ) else {return}
        let request = URLRequest(url: url)
        downloadTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            
            OperationQueue.main.addOperation { [unowned self] in
                self.character?.iconChamp = data
                self.completionHandler?()
            }
        }
        downloadTask?.resume()
    }
    
    func cancelDownload() {
        downloadTask?.cancel()
        downloadTask = nil
    }
}
