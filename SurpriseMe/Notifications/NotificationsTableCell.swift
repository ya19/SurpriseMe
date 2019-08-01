//
//  NotificationsTableCell.swift
//  SurpriseMe
//
//  Created by Youval Ella on 31/07/2019.
//  Copyright © 2019 Surprise. All rights reserved.
//

import UIKit

class NotificationsTableCell: UITableViewCell {

    @IBOutlet weak var notificationImage: UIImageView!
    
    @IBOutlet weak var notificationTitle: UILabel!
    
    @IBOutlet weak var notificationDescription: UILabel!
    
    @IBOutlet weak var notificationDate: UILabel!
    
    @IBAction func acceptTapped(_ sender: UIButton) {
    }
    
    @IBAction func denyTapped(_ sender: Any) {
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func populate(notification : Notification?){
        notificationImage.image = notification!.image ?? #imageLiteral(resourceName: "placeholder")
        notificationTitle.text = notification!.notificationType.description
        notificationDescription.text = "\(notification!.sender!.firstName) \(notification!.notificationType.getDescription())"
        notificationDate.text = "Date and time of notification"
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
