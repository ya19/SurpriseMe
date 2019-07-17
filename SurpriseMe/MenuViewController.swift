//
//  MenuViewController.swift
//  SurpriseMe
//
//  Created by Yossi Appo on 17/07/2019.
//  Copyright © 2019 Surprise. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {

    @IBOutlet weak var table: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        table.backgroundColor = UIColor(red: 0/255.0, green: 128.0/255.0, blue: 128.0/255.0, alpha: 1)
        self.view.backgroundColor = .clear
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
extension MenuViewController:UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.table.frame.height / 8
    }
}
extension MenuViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuCell") as! MenuTableViewCell
        cell.populate(title: "title 1")
        return cell
    }
    
    
}
