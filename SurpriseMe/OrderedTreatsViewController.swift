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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(white: 0, alpha: 0.5)
        print("======= \(treats)")

        orderedTreatsTable.delegate = self
        orderedTreatsTable.dataSource = self

        // Do any additional setup after loading the view.
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
        
        cell.populate(treat: treats![indexPath.row])
        print(treats)
        
        return cell
    }
}
