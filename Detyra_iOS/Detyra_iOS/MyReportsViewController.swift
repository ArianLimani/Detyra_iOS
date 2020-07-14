//
//  MyReportsViewController.swift
//  Detyra_iOS
//
//  Created by FitimHajredini on 7/14/20.
//  Copyright © 2020 FitimHajredini. All rights reserved.
//

import UIKit

class MyReportsViewController: UITableViewController {
  
    @IBOutlet var ReportsTV: UITableView!
    
    let carsArray = ["BMW","VW", "Mercedes", "Audi", "Toyota", "Ford", "Tesla", "Koenigsegg"];
    let cellID = "cellID";
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        ReportsTV.dataSource = self;
        ReportsTV.delegate = self;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return carsArray.count;
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: cellID);
        if (cell == nil) {
            cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: cellID);
        }
        cell?.textLabel?.text = carsArray[indexPath.row];
        
        return cell!;
    }
    
    // OnClick tableView row method()
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = carsArray[indexPath.row];
        NSLog(selectedItem);
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
