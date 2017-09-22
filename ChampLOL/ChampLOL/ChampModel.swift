//
//  ChampModel.swift
//  ChampLOL
//
//  Created by Chung Tran on 9/22/17.
//  Copyright © 2017 Chung Tran. All rights reserved.
//

import Foundation

typealias JSON = Dictionary<AnyHashable, Any>

struct ChampModel {
    var id_Champ: Int
    var nameEN_Champ: String
    var nameVN_Champ: String
    var level_Champ: Int
    var url_Champ: String
    
    init?(json: JSON) {
        
        guard let id_Champ = json["id_Champ"] as? Int  else {return nil}
        guard let nameEN_Champ = json["nameEN_Champ"] as? String else {return nil}
        guard let nameVN_Champ = json["nameVN_Champ"] as? String else {return nil}
        guard let level_Champ = json["level_Champ"] as? Int else {return nil}
        guard let url_Champ = json["url_Champ"] as? String else {return nil}
        
        self.id_Champ = id_Champ
        self.nameEN_Champ = nameEN_Champ
        self.nameVN_Champ = nameVN_Champ
        self.level_Champ = level_Champ
        self.url_Champ = url_Champ
    }
}
