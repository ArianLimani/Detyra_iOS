//
//  Reports.swift
//  Detyra_iOS
//
//  Created by Arian Limani on 7/15/20.
//  Copyright © 2020 FitimHajredini. All rights reserved.
//

import Foundation

public class Reports{
    var id:Int?
    var username:String
    var report_for:String
    var description:String
    
    init(username: String, report_for:String, description:String){
        self.username=username
        self.report_for=report_for
        self.description=description
    }
}
