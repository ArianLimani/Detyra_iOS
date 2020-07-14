//
//  ViewController.swift
//  Detyra_iOS
//
//  Created by FitimHajredini on 7/10/20.
//  Copyright © 2020 FitimHajredini. All rights reserved.
//

import UIKit
import SQLite3

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameTF: UITextField!;
    @IBOutlet weak var passwordTF: UITextField!;
    
    var db: OpaquePointer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // SQLite creation
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("AEFvisionDatabase.sqlite");
        
        // Checking and opening the database
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("error in opening the database");
            return;
        }
        
        //Creating a table
        if sqlite3_exec(db, "CREATE TABLE IF NOT EXISTS Users (id INTEGER PRIMARY KEY AUTOINCREMENT, username TEXT, email TEXT, password TEXT)", nil, nil, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error in creating table: \(errmsg)")
        }
        print("Databaza dhe tabela u krijuan me sukses!");
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.destination is NavigationViewController) {
            let vc = segue.destination as? NavigationViewController;
            vc?.usernameNV = usernameTF?.text;
        }
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func loginOnClick(_ sender: Any) {
        let username = usernameTF.text?.trimmingCharacters(in: .whitespacesAndNewlines);
        let userPassword = passwordTF.text?.trimmingCharacters(in: .whitespacesAndNewlines);
        
        var stmt: OpaquePointer?;
        let queryString = "SELECT * FROM Users WHERE username = ? and password = ?";
        
        //preparing the query
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!);
            print("error preparing insert: \(errmsg)");
            return;
        }
        
        //binding the parameters
        if sqlite3_bind_text(stmt, 1, username, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!);
            print("failure binding username: \(errmsg)");
            return;
        }
        if sqlite3_bind_text(stmt, 2, userPassword, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!);
            print("failure binding email: \(errmsg)");
            return;
        }
        if(sqlite3_step(stmt) == SQLITE_ROW) {
            print("Successful login");
            self.performSegue(withIdentifier: "FromLoginToMain", sender: self)
        }
    }
    
    
    
    
    //    if (sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK) {
    //        const char *sql = "SELECT * FROM Users WHERE username = ? and password = ?";
    //        sqlite3_stmt *selectstmt;
    //        if(sqlite3_prepare_v2(database, sql, -1, &selectstmt, NULL) == SQLITE_OK) {
    //            sqlite3_bind_text(selectstmt, 1, [login.text UTF8String], -1, SQLITE_TRANSIENT);
    //            sqlite3_bind_text(selectstmt, 2, [password.text UTF8String], -1, SQLITE_TRANSIENT);
    //            while(sqlite3_step(selectstmt) == SQLITE_ROW) {
    //            NSLog(@"Successful login");
    //            }
    //        }
    //    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

