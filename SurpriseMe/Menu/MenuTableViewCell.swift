//
//  MenuTableViewCell.swift
//  SurpriseMe
//
//  Created by Yossi Appo on 17/07/2019.
//  Copyright © 2019 Surprise. All rights reserved.
//

import UIKit

class MenuTableViewCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var menuItemImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func populate(title:String, image: UIImage?){
        self.title.text = title
        self.menuItemImage.image = image
    }
}
