//
//  MyReportsViewController.swift
//  Detyra_iOS
//
//  Created by Arian Limani on 7/15/20.
//  Copyright © 2020 FitimHajredini. All rights reserved.
//

import UIKit
import SQLite3

class MyReportsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    var usernameMY:String?
    var reportsList = [Reports]()
    var db:OpaquePointer?
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reportsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell") as! CustomCellTableViewCell
//
//        var label:UILabel
//        label = cell.viewWithTag(1) as! UILabel
//        label.text = reportsList[indexPath.row].username
//        label = cell.viewWithTag(2) as! UILabel
//        label.text = reportsList[indexPath.row].report_for
//        label = cell.viewWithTag(3) as! UILabel
//        label.text = reportsList[indexPath.row].description

        cell.lblUsername.text = reportsList[indexPath.row].username
        cell.lblFor.text = reportsList[indexPath.row].report_for
        cell.lblDescription.text = reportsList[indexPath.row].description
        return cell
    }
    
    
    func readValues(){
        
        reportsList.removeAll()
        
        //this is our select query
        let queryString = "SELECT * FROM Reports";
        
        //statement pointer
        var stmt:OpaquePointer?
        
        //preparing the query
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error reading data: \(errmsg)")
            return
        }
        
        //binding the parameters
//        if sqlite3_bind_text(stmt, 1, usernameMY, -1, nil) != SQLITE_OK{
//            let errmsg = String(cString: sqlite3_errmsg(db)!);
//            print("failure binding username: \(errmsg)");
//            return;
//        }
        
        //traversing through all the records
        while(sqlite3_step(stmt) == SQLITE_ROW){
            let username1 = String(cString: sqlite3_column_text(stmt, 1))
            let report_for1 = String(cString: sqlite3_column_text(stmt, 2))
            let description1 = String(cString: sqlite3_column_text(stmt, 3))

            //adding values to list
            reportsList.append(Reports(username: String(describing: username1), report_for: String(describing: report_for1), description: String(describing: description1)))
        }
//        self.tableView.reloadData()
        
        
    }
    
    override func viewDidLoad() {
        tableView.delegate = self
        tableView.dataSource = self
        
        super.viewDidLoad()
        print(usernameMY!)
        
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("AEFvisionDatabase.sqlite");
        
        // Checking and opening the database
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("error in opening the database");
            return;
        }
        
        readValues()
        
    }


}
