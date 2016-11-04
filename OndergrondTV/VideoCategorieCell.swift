//
//  VideoCategorieCell.swift
//  OndergrondTV
//
//  Created by Supervisor on 04-11-16.
//  Copyright © 2016 Nerdvana. All rights reserved.
//

import UIKit

class VideoCategorieCell: UITableViewCell {
    
    @IBOutlet private weak var videoCollectionView: UICollectionView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setCollectionViewDataSourceDelegate
        <D: UICollectionViewDataSource & UICollectionViewDelegate>
        (dataSourceDelegate: D, forRow row: Int) {
        
        videoCollectionView.delegate = dataSourceDelegate
        videoCollectionView.dataSource = dataSourceDelegate
        videoCollectionView.tag = row
        videoCollectionView.reloadData()
    }
}
