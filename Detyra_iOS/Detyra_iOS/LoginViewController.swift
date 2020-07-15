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
    
    @IBOutlet weak var errorLbl: UILabel!
    
    
    var db: OpaquePointer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("AEFvisionDatabase.sqlite");
        
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("error in opening the database");
            return;
        }
        
        if sqlite3_exec(db, "CREATE TABLE IF NOT EXISTS Users (id INTEGER PRIMARY KEY AUTOINCREMENT, username TEXT, email TEXT, password TEXT)", nil, nil, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error in creating table: \(errmsg)")
        }
        
        if sqlite3_exec(db, "CREATE TABLE IF NOT EXISTS Reports (id INTEGER PRIMARY KEY AUTOINCREMENT, username TEXT, report_for TEXT, description TEXT)", nil, nil, nil) != SQLITE_OK {
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
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func loginOnClick(_ sender: Any) {
        let username = usernameTF.text?.trimmingCharacters(in: .whitespacesAndNewlines);
        let userPassword = passwordTF.text?.trimmingCharacters(in: .whitespacesAndNewlines);
        
        if(username!.isEmpty || userPassword!.isEmpty) {
            errorLbl.text = "All fields required"
            return
        }
        
        var stmt: OpaquePointer?;
        let queryString = "SELECT * FROM Users WHERE username = ? and password = ?";
        
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!);
            print("error preparing insert: \(errmsg)");
            return;
        }
        
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
            sqlite3_finalize(stmt)
            sqlite3_close(db)
            self.performSegue(withIdentifier: "FromLoginToMain", sender: self)
        } else {
            errorLbl.text="This user does not exist"
        }
        
    }

}

