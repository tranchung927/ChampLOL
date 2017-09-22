//
//  ViewController.swift
//  ChampLOL
//
//  Created by Chung Tran on 9/22/17.
//  Copyright © 2017 Chung Tran. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var imageDownloadsInProgress : Dictionary<Int,IconDownloader> = [:]
    let champIconSize = CGSize(width: 48, height: 48)
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        registerNotification()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        terminateAllDownload()
        Cache.images.removeAllObjects()
    }
    
    func terminateAllDownload() {
        
        // dừng lại tất cả các connection đang pending
        
        let allDownloads = imageDownloadsInProgress.values
        allDownloads.forEach {$0.cancelDownload()}
        imageDownloadsInProgress.removeAll()
    }

    func registerNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleNotification), name: NotificationKey.didUpdateChamps, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        terminateAllDownload()
    }
    func handleNotification() {
        DispatchQueue.main.async(execute: {
            self.tableView.reloadData()
        })

    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataServices.share.isNeedLoadMore ? DataServices.share.characters.count + 1 : DataServices.share.characters.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case DataServices.share.characters.count:
            let cell = tableView.dequeueReusableCell(withIdentifier: "LoadMore", for: indexPath)
            DataServices.share.updateChamp()
            return cell
        default:
            let character = DataServices.share.characters[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TableViewCell
            cell.name.text = character.nameEN_Champ
            cell.info.text = character.nameVN_Champ
            cell.level.text = "Độ khó: \(character.level_Champ)"
            
            if character.iconChamp != nil {
                if let image = Cache.images.object(forKey: "\(character.url_Champ)" as NSString) as? UIImage {
                    cell.icon.image = image
                } else {
                    if let image = UIImage(data: character.iconChamp!)?.cropIfNeed(aspectFillToSize: champIconSize) {
                        Cache.images.setObject(image, forKey: "\(character.url_Champ)" as NSString)
                        cell.icon.image = image
                    }
                }
            } else {
                if (self.tableView.isDragging == false && self.tableView.isDecelerating == false) {
                    self.startDownloadIcon(for: character, at: indexPath)
                }
                cell.icon.image = UIImage(named: "Placeholder.png")
            }
            
            return cell
        }
    }
}

// MARK: UIScrollViewDelegate
extension ViewController: UIScrollViewDelegate {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            loadImagesForOnscreenRows()
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        loadImagesForOnscreenRows()
    }
}

// MARK: Load Image
extension ViewController {
    func startDownloadIcon(for character: Character, at indexPath: IndexPath) {
        
        // Nếu iconDownloader đã có rồi thì dùng luôn.
        // Chưa có thì khởi tạo cho lần sau dùng lại
        
        var iconDowloader = imageDownloadsInProgress[indexPath.row]
        if iconDowloader == nil {
            iconDowloader = IconDownloader()
            iconDowloader?.character = character
            iconDowloader?.completionHandler = {[unowned self] in
                let cell = self.tableView.cellForRow(at: indexPath) as? TableViewCell
                guard let iconChampData = character.iconChamp, let image = UIImage(data: iconChampData)?.cropIfNeed(aspectFillToSize: self.champIconSize) else {
                    return
                }
                cell?.icon.image = image
            }
            imageDownloadsInProgress[indexPath.row] = iconDowloader
        }
        iconDowloader?.startDownload()
    }
    func loadImagesForOnscreenRows() {
        guard DataServices.share.characters.count > 0 else {return}
        let visiblePaths = tableView.indexPathsForVisibleRows
        visiblePaths?.forEach {[unowned self] indexPath in
            let charactor = DataServices.share.characters[indexPath.row]
            if charactor.url_Champ != "" {
                self.startDownloadIcon(for: charactor, at: indexPath)
            }
        }
    }

}
