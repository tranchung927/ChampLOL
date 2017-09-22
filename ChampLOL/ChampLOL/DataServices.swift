//
//  DataServices.swift
//  ChampLOL
//
//  Created by Chung Tran on 9/22/17.
//  Copyright © 2017 Chung Tran. All rights reserved.
//

import UIKit

class DataServices {
    
    static let share: DataServices = DataServices()
    private var _characters: [Character]?
    
    var characters: [Character] {
        set {
            _characters = newValue
        }
        get {
            if _characters == nil {
                updateChamp()
            }
            return _characters ?? []
        }
    }
    
    
    var isNeedLoadMore: Bool {
        return currentPage < totalPage
    }
    
    private let totalPage = 20
    private var currentPage = 0
    private var isLoading = false
    private var champUrl: URL? {
        return URL(string: "http://infomationchampion.pe.hu/showInfo.php?index=\(currentPage)&number=\(totalPage)")
    }
    
    func updateChamp() {
        guard isLoading == false else {
            return
        }
        
        if _characters == nil {
            _characters = []
        }
        
        guard let url = champUrl else {
            return
        }
        
        let urlRequest = URLRequest(url: url)
        
        makeDataTaskRequest(request: urlRequest)
    }
    
    private func makeDataTaskRequest(request: URLRequest) {
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            
            guard let aData = data else {
                return
            }
            do {
                if let result = try JSONSerialization.jsonObject(with: aData) as? [JSON] {
                    result.forEach({ (json) in
                        self._characters?.append(Character(json: json))
                    })
                    NotificationCenter.default.post(name: NotificationKey.didUpdateChamps, object: nil)
                    self.currentPage += 1
                    self.isLoading = false
                }
            } catch {
                print("Error")
            }
        }
        task.resume()
    }
    
}

struct NotificationKey {
    static var didUpdateChamps = Notification.Name(rawValue: "didUpdateChamps")
}
