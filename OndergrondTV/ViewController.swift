//
//  ViewController.swift
//  OndergrondTV
//
//  Created by Supervisor on 04-11-16.
//  Copyright © 2016 Nerdvana. All rights reserved.
//

import UIKit
import youtube_ios_player_helper

struct HeaderStructure {
    var image: UIImage
    var title: String
}

class ViewController: UIViewController {
    
    let videoCategorie: [[UIColor]] = generateRandomData()
    var videos = [Video]()
    
    var arrayOfHeaders = [HeaderStructure]()
    var headerViewHeight: CGFloat = 60

    @IBOutlet var videoTableView: UITableView!
    @IBOutlet var videoView: YTPlayerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.videoView.delegate = self
        
        self.arrayOfHeaders = [HeaderStructure.init(image: #imageLiteral(resourceName: "ondergrondlogo"), title: "Ondergrond TV"), HeaderStructure.init(image: #imageLiteral(resourceName: "ondergrondlogo"), title: "Ondergrond TV"), HeaderStructure.init(image: #imageLiteral(resourceName: "ondergrondlogo"), title: "Ondergrond TV")]
        
        API.fetchVideoPlaylist { (videoResult) in
            DispatchQueue.main.async {
                
                switch videoResult {
                case let .Success(videos):
                    self.videos = videos
                    print("Successfully found \(videos.count) items.")
                    
                case let .Failure(error):
                    self.videos.removeAll()
                    print("Error fetching videos, error: \(error)")
                    
                case .None:
                    break
                }
            }
        }


    }
    
}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return 3 //videoCategorie.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "VideoCategorieCell", for: indexPath) as! VideoCategorieCell
        
        return cell 
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return arrayOfHeaders.count
    }
    
   
}

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {

        guard let videoCategorieCell = cell as? VideoCategorieCell else { return }

        videoCategorieCell.setCollectionViewDataSourceDelegate(dataSourceDelegate: self, forRow: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return self.headerViewHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = Bundle.main.loadNibNamed("HeaderView", owner: self, options: nil)?.first as! HeaderView
        
        headerView.headerImageView.image = arrayOfHeaders[section].image
        headerView.headerLabel.text = arrayOfHeaders[section].title
        
        return headerView
        
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, YTPlayerViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return videos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VideoCell", for: indexPath) as! VideoCell
        
//        cell.backgroundColor = videoCategorie[collectionView.tag][indexPath.item]

        cell.video = self.videos[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let video = videos[indexPath.item]
        let videoID = video.ID
        self.videoView.load(withVideoId: videoID)
        
    }
    func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
        self.videoView.playVideo()
    }
}

func generateRandomData() -> [[UIColor]] {
    let numberOfRows = 20
    let numberOfItemsPerRow = 15
    
    return (0..<numberOfRows).map { _ in
        return (0..<numberOfItemsPerRow).map { _ in UIColor.randomColor() }
    }
}

extension UIColor {
    class func randomColor() -> UIColor {
        
        let hue = CGFloat(arc4random() % 100) / 100
        let saturation = CGFloat(arc4random() % 100) / 100
        let brightness = CGFloat(arc4random() % 100) / 100
        
        return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1.0)
    }
}



