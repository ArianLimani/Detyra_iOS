//
//  SignupViewController.swift
//  Detyra_iOS
//
//  Created by FitimHajredini on 7/11/20.
//  Copyright © 2020 FitimHajredini. All rights reserved.
//

import UIKit
import SQLite3

class SignupViewController: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!;
    @IBOutlet weak var emailTextField: UITextField!;
    @IBOutlet weak var passwordTextField: UITextField!;
    @IBOutlet weak var repeatPasswordTextField: UITextField!;
    
    @IBOutlet weak var errorLbl: UILabel!
    
    
    var db: OpaquePointer?
    var validation = Validation()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("AEFvisionDatabase.sqlite");
        
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("error in opening the database");
            return;
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning();
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    @IBAction func singupOnClick(_ sender: Any) {
        
        let username = usernameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines);
        let userEmail = emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines);
        let userPassword = passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines);
        let userRepeatPassword = repeatPasswordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines);
        
        if (username!.isEmpty || userEmail!.isEmpty
            || userPassword!.isEmpty || userRepeatPassword!.isEmpty) {
            errorLbl.text = "All fields are required!"
            return;
        }
        
        let isValidateUsername = self.validation.validateName(name: username!)
        if (isValidateUsername == false) {
            errorLbl.text="Invalid username, 3-18 characters required"
            return
        }
        let isValidateEmail = self.validation.validateEmailId(emailID: userEmail!)
        if (isValidateEmail == false){
            errorLbl.text="Invalid email, @student.uni-pr.edu needed"
            return
        }
        let isValidatePass = self.validation.validatePassword(password: userPassword!)
        if (isValidatePass == false) {
            errorLbl.text="Password too weak"
            return
        }
        
        if(userPassword != userRepeatPassword) {
            errorLbl.text="Passwords don't match"
            
            return;
        }
        
        if (isValidateUsername == true || isValidateEmail == true || isValidatePass == true) {
            let queryString1 = "SELECT * FROM Users WHERE username = ? OR email = ?"
            var stmt1:OpaquePointer?;
            
            if sqlite3_prepare(db, queryString1, -1, &stmt1, nil) != SQLITE_OK{
                let errmsg = String(cString: sqlite3_errmsg(db)!);
                print("error preparing insert: \(errmsg)");
                return;
            }
            
            if sqlite3_bind_text(stmt1, 1, username, -1, nil) != SQLITE_OK{
                let errmsg = String(cString: sqlite3_errmsg(db)!);
                print("failure binding username: \(errmsg)");
                return;
            }
            
            if sqlite3_bind_text(stmt1, 2, userEmail, -1, nil) != SQLITE_OK{
                let errmsg = String(cString: sqlite3_errmsg(db)!);
                print("failure binding email: \(errmsg)");
                return;
            }
            
            if(sqlite3_step(stmt1) == SQLITE_ROW) {
                errorLbl.text = "This user already exists"
                sqlite3_finalize(stmt1)
                return
            } else {
                var stmt: OpaquePointer?;
                
                let queryString = "INSERT INTO Users (username, email, password) VALUES (?,?,?)";
                
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
                
                if sqlite3_bind_text(stmt, 2, userEmail, -1, nil) != SQLITE_OK{
                    let errmsg = String(cString: sqlite3_errmsg(db)!);
                    print("failure binding email: \(errmsg)");
                    return;
                }
                
                if sqlite3_bind_text(stmt, 3, userPassword, -1, nil) != SQLITE_OK{
                    let errmsg = String(cString: sqlite3_errmsg(db)!);
                    print("failure binding password: \(errmsg)");
                    return;
                }
                
                if sqlite3_step(stmt) != SQLITE_DONE {
                    let errmsg = String(cString: sqlite3_errmsg(db)!);
                    print("failure inserting into database: \(errmsg)");
                    return;
                }
                
                let myAlert = UIAlertController(title:"Signed Up", message: "Successfully registered!",preferredStyle: UIAlertControllerStyle.alert);
                let okAction = UIAlertAction(title:"OK", style:UIAlertActionStyle.default) {
                    action in self.dismiss(animated: true,completion:nil);
                }
                myAlert.addAction(okAction);
                self.present(myAlert, animated: true, completion: nil);
                
            }
        }
    }
}
