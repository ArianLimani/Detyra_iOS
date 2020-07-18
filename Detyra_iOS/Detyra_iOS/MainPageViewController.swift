//
//  MainPageViewController.swift
//  Detyra_iOS
//
//  Created by Arian Limani on 7/13/20.
//  Copyright © 2020 FitimHajredini. All rights reserved.
//

import UIKit
import SQLite3

class MainPageViewController: UIViewController {
    
    var username:String?;
    @IBOutlet weak var welcomLbl: UILabel!;
    
    @IBOutlet weak var tfReportFor: UITextField!
    
    @IBOutlet weak var errorLbl: UILabel!
    
    
    @IBOutlet weak var tfDescription: UITextView!
    
    var db: OpaquePointer?
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.destination is MyReportsViewController) {
            let vc = segue.destination as? MyReportsViewController;
            vc?.usernameMY = username!;
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.setHidesBackButton(true, animated: true);
        
        
        welcomLbl.text = "Welcome, \(username!)!";
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func sendBtn(_ sender: Any) {
        var stmt: OpaquePointer?;
        
        let reportFor = tfReportFor.text?.trimmingCharacters(in: .whitespacesAndNewlines);
        let description = tfDescription.text?.trimmingCharacters(in: .whitespacesAndNewlines);
        
        if(reportFor!.isEmpty || description!.isEmpty){
            errorLbl.text="All fields required"
        }
        
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("AEFvisionDatabase.sqlite");
        
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("error in opening the database");
            return;
        }
        
        let queryString1 = "INSERT INTO Reports(username, report_for, description) VALUES (?,?,?)";
        
        if sqlite3_prepare(db, queryString1, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!);
            print("error preparing insert: \(errmsg)");
            return;
        }
        
        if sqlite3_bind_text(stmt, 1, username, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!);
            print("failure binding username: \(errmsg)");
            return;
        }
        
        if sqlite3_bind_text(stmt, 2, reportFor, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!);
            print("failure binding email: \(errmsg)");
            return;
        }
        
        if sqlite3_bind_text(stmt, 3, description, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!);
            print("failure binding password: \(errmsg)");
            return;
        }
        
        
        if sqlite3_step(stmt) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(db)!);
            print("failure inserting into database: \(errmsg)");
            return;
        }
        
        sqlite3_finalize(stmt)
        sqlite3_close(db)
        
        tfReportFor.text = ""
        tfDescription.text = ""
        
    }
    
    @IBAction func MyReportsBtn(_ sender: Any) {
        self.performSegue(withIdentifier: "ToMyReports", sender: self)

    }
    
}
