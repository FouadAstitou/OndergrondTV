//
//  HeaderView.swift
//  OndergrondTV
//
//  Created by Supervisor on 07-12-16.
//  Copyright © 2016 Nerdvana. All rights reserved.
//

import UIKit

class HeaderView: UITableViewCell {
    @IBOutlet weak var headerImageView: UIImageView!
    @IBOutlet weak var headerLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
