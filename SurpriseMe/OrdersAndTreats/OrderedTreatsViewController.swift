//
//  OrderedTreatsViewController.swift
//  SurpriseMe
//
//  Created by Youval Ella on 17/07/2019.
//  Copyright © 2019 Surprise. All rights reserved.
//

import UIKit

class OrderedTreatsViewController: UIViewController {
    @IBOutlet weak var popUpView: UIView!
    
    @IBOutlet weak var orderedTreatsTable: UITableView!
    
    
    @IBAction func closePopUp(_ sender: SAButton) {
        PopUp.remove(controller: self)
    }
    
    
    var treats:[Treat]?
    var getters:[String:String]?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(white: 0, alpha: 0.5)

        orderedTreatsTable.delegate = self
        orderedTreatsTable.dataSource = self

    }
    
}

extension OrderedTreatsViewController : UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.height / 5
    }
}

extension OrderedTreatsViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return treats!.count
//        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: "orderedTreatCell") as! OrderedTreatsTableCell
        
        cell.populate(treat: treats![indexPath.row],getter: getters![treats![indexPath.row].id]!)
        
        return cell
    }
}
