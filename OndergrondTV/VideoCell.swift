//
//  VideoCell.swift
//  OndergrondTV
//
//  Created by Supervisor on 07-12-16.
//  Copyright © 2016 Nerdvana. All rights reserved.
//

import UIKit

class VideoCell: UICollectionViewCell {
    
    @IBOutlet weak var thumbnailImageView: UIImageView!
    
    
    var video: Video? {
        didSet {
            
            if let video = video {
                DispatchQueue.global(qos: .userInitiated).async {
                    
                    if let url = URL(string: video.thumbnail) {
                        let data = try! Data(contentsOf: url)
                        
                        DispatchQueue.main.async {
                            self.thumbnailImageView.image = UIImage(data: data)
                        }
                    }
                }
            }
        }
    }
}
