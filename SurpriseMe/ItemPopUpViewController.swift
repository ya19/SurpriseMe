//
//  ItemPopUpViewController.swift
//  SurpriseMe
//
//  Created by hackeru on 14/07/2019.
//  Copyright © 2019 Surprise. All rights reserved.
//

import UIKit

class ItemPopUpViewController: UIViewController {
    var item:Product?
    @IBAction func popUpClose(_ sender: UIButton) {
        self.view.removeFromSuperview()
    }
    
    
    @IBOutlet weak var itemDescription: UITextView!
    
    @IBOutlet weak var itemPrice: UILabel!
    @IBOutlet weak var itemTitle: UILabel!
    @IBOutlet weak var itemImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(white: 0, alpha: 0.5)
        initViews()
        // Do any additional setup after loading the view.
    }
    
    func initViews(){
        itemImage.image = item?.image
        itemTitle.text = item?.name
        itemPrice.text = "Price: \(item?.price ?? 0.0)"
        itemDescription.text = item?.desc
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
