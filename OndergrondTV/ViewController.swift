//
//  ViewController.swift
//  OndergrondTV
//
//  Created by Supervisor on 04-11-16.
//  Copyright © 2016 Nerdvana. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let videoCategorie: [[UIColor]] = generateRandomData()
    let videos = [Video]()

    @IBOutlet var videoView: UIView!
    @IBOutlet var videoTableView: UITableView!
    
    var apiKey = "AIzaSyCLgeLAV-oQCA2x63EuCUqcekrMVE9uzHE"
    var channelID = "UCcKJov9QO24HcGaP4w2wweg"
    var uploadsID = "UUcKJov9QO24HcGaP4w2wweg"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
//        func performGetRequest(targetUrl: URL!, completion: (data: Data?, HTTPSStatusCode: Int, error: Error?) -> Void) {
//            
//        }
//        var urlString = "https://www.googleapis.com/youtube/v3/channels?part=contentDetails,snippet&id=\(channelID)&key=\(apiKey)"
        self.test()

    }
    
    func test() {
        let url = URL(string: "https://www.googleapis.com/youtube/v3/channels?part=contentDetails,snippet&id=\(channelID)&key=\(apiKey)")
        let upload = URL(string: "https://www.googleapis.com/youtube/v3/playlistItems?part=snippet&maxResults=50&playlistId=\(uploadsID)&key=\(apiKey)")
        print(upload)
        
        let task = URLSession.shared.dataTask(with: upload!) { data, response, error in
            guard error == nil else {
                print(error)
                return
            }
            guard let data = data else {
                print("Data is empty")
                return
            }
            
            let jsonResult = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: AnyObject]
            
            let items = jsonResult["items"] as! [[String: AnyObject]]
            
            for item in items {
               
                print("SNIPPET = \(item["snippet"]!["title"]!)")
            }
//            print(items)
        }
        
        task.resume()
    }
}


extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return videoCategorie.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "VideoCategorieCell", for: indexPath) as! VideoCategorieCell
        
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {

        guard let videoCategorieCell = cell as? VideoCategorieCell else { return }

        videoCategorieCell.setCollectionViewDataSourceDelegate(dataSourceDelegate: self, forRow: indexPath.row)
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return videoCategorie[collectionView.tag].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VideoCell", for: indexPath)
        
        cell.backgroundColor = videoCategorie[collectionView.tag][indexPath.item]

        return cell
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



