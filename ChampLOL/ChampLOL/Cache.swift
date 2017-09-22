//
//  Cache.swift
//  ChampLOL
//
//  Created by Chung Tran on 9/22/17.
//  Copyright © 2017 Chung Tran. All rights reserved.
//

import Foundation

class Cache {
    static var image : NSCache<NSString, AnyObject> = {
        let result = NSCache<NSString, AnyObject>()
        result.countLimit = 30
        result.totalCostLimit = 10 * 1024 * 1024
        return result
    }()
}
