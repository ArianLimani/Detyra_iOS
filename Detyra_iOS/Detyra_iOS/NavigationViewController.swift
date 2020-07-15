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
        
        self.performSegue(withIdentifier: "NavigationToMainPage", sender: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
