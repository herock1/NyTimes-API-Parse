//
//  NewsCell.swift
//  Hello-iOS
//
//  Created by Herock Hasan on 19/5/18.
//  Copyright © 2018 Herock Hasan. All rights reserved.
//

import UIKit

class NewsCell: UITableViewCell {

    
    @IBOutlet weak var newscategory: UILabel!
    @IBOutlet weak var newsdate: UILabel!
    @IBOutlet weak var newsTitle: UILabel!
    @IBOutlet weak var newsDetails: UILabel!
    @IBOutlet weak var newImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
