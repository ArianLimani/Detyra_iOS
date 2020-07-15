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
    
    var db: OpaquePointer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // SQLite creation
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("AEFvisionDatabase.sqlite");
        
        // Checking and opening the database
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("error in opening the database");
            return;
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning();
        // Dispose of any resources that can be recreated.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
//    @IBAction func registerButtonTapped(_ sender: AnyObject) {
    
    
    @IBAction func singupOnClick(_ sender: Any) {
        
        let username = usernameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines);
        let userEmail = emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines);
        let userPassword = passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines);
        let userRepeatPassword = repeatPasswordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines);
        
        // Check for empty fields
        if (username!.isEmpty || userEmail!.isEmpty
            || userPassword!.isEmpty || userRepeatPassword!.isEmpty) {
            // Display an alert message
            displayMyAlertMessage(userMessage: "All fields are required!");
            return;
        }
        
        //Check if passwords match
        if(userPassword != userRepeatPassword) {
            // Display an alert message
            displayMyAlertMessage(userMessage: "Passwords don't match!");
            return;
        }
        
        // Store data in NSUserDefaults
        //        UserDefaults.standard.set(username, forKey:"username");
        //        UserDefaults.standard.set(userEmail, forKey:"userEmail");
        //        UserDefaults.standard.set(userPassword, forKey:"userPassword");
        
        //creating a statement
        var stmt: OpaquePointer?;
        
        //the insert query
        let queryString = "INSERT INTO Users (username, email, password) VALUES (?,?,?)";
        
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
        
        //executing the query to insert values
        if sqlite3_step(stmt) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(db)!);
            print("failure inserting into database: \(errmsg)");
            return;
        }
        
        //displaying a success message
        print("User successfully registered");
        
        
        
        
        
        
        
        
        
        
        // Display alert message with confirmation
        let myAlert = UIAlertController(title:"Alert", message: "Successfully registered!",preferredStyle: UIAlertControllerStyle.alert);
        let okAction = UIAlertAction(title:"OK", style:UIAlertActionStyle.default) {
            action in self.dismiss(animated: true,completion:nil);
        }
        myAlert.addAction(okAction);
        self.present(myAlert, animated: true, completion: nil);
        
    }
    
    func displayMyAlertMessage(userMessage:String) {
        let myAlert = UIAlertController(title:"Alert", message: userMessage, preferredStyle: UIAlertControllerStyle.alert);
        let okAction = UIAlertAction(title:"OK", style:UIAlertActionStyle.default, handler: nil);
        myAlert.addAction(okAction);
        self.present(myAlert, animated:true, completion:nil);
        
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
