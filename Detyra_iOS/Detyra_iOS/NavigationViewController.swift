//
//  NavigationViewController.swift
//  Detyra_iOS
//
//  Created by Arian Limani on 7/13/20.
//  Copyright © 2020 FitimHajredini. All rights reserved.
//

import UIKit

class NavigationViewController: UINavigationController {

    var usernameNV: String?
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.destination is MainPageViewController) {
            let vc = segue.destination as? MainPageViewController;
            vc?.username = usernameNV;
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.performSegue(withIdentifier: "NavigationToMainPage", sender: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
