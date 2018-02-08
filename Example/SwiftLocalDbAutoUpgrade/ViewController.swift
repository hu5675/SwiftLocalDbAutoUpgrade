//
//  ViewController.swift
//  SwiftLocalDbAutoUpgrade
//
//  Created by hu5675 on 02/07/2018.
//  Copyright (c) 2018 hu5675. All rights reserved.
//

import UIKit
import SwiftLocalDbAutoUpgrade

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let plistFileName:String = "tables.plist"
        let dbName = "Record.db"
        
        let result = ZHRUpgradeManager.shared.upgrade(plistName: plistFileName,dbName: dbName)
        print("数据库升级:\(result)")
        
    }

}

