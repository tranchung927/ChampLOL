//
//  ViewController.swift
//  ChampLOL
//
//  Created by Chung Tran on 9/22/17.
//  Copyright © 2017 Chung Tran. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        registerNotification()
        DataServices.share.updateChamp()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func registerNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleNotification), name: NotificationKey.didUpdateChamps, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    func handleNotification() {
        for i in DataServices.share.characters {
            print(i.nameEN_Champ)
        }
    }
}

