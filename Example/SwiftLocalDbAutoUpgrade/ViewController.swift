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

    @IBOutlet weak var addTablesButton:UIButton!
    @IBOutlet weak var addFieldsButton:UIButton!
    @IBOutlet weak var deleteFieldsButton:UIButton!
    @IBOutlet weak var deleteTablesButton:UIButton!
    
    @IBOutlet weak var tableView:UITableView!
    
    var dataSource:[ZHRTableModel?]? = nil
    
    var plistFileName:String = "tables.plist"
    let dbName = "Record.db"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
    }

    @IBAction func viewCurrentTableStruct(sender:UIButton) -> Void {
        self.dataSource = ZHRDBManager.shared.queryAllTable()
        self.tableView.reloadData()
    }
    
    @IBAction func addTablesUpgrade(sender:UIButton) -> Void {
        plistFileName = "tables_add_tables.plist"
        let result = ZHRUpgradeManager.shared.upgrade(plistName: plistFileName,dbName: dbName)
        print("删除表-数据库升级:\(result)")
        self.viewCurrentTableStruct(sender: sender)
    }
    
    @IBAction func addFieldsUpgrade(sender:UIButton) -> Void {
        plistFileName = "tables_add_fields.plist"
        let result = ZHRUpgradeManager.shared.upgrade(plistName: plistFileName,dbName: dbName)
        print("添加字段-数据库升级:\(result)")
        self.viewCurrentTableStruct(sender: sender)
    }
    
    @IBAction func deleteTablesUpgrade(sender:UIButton) -> Void {
        plistFileName = "tables.plist"
        let result = ZHRUpgradeManager.shared.upgrade(plistName: plistFileName,dbName: dbName)
        print("删除表-数据库升级:\(result)")
        self.viewCurrentTableStruct(sender: sender)
    }
    
    @IBAction func deleteFieldsUpgrade(sender:UIButton) -> Void {
        plistFileName = "tables_delete_fields.plist"
        let result = ZHRUpgradeManager.shared.upgrade(plistName: plistFileName,dbName: dbName)
        print("删除字段-数据库升级:\(result)")
        self.viewCurrentTableStruct(sender: sender)
    }
}

extension ViewController : UITableViewDelegate{
    
}

extension ViewController : UITableViewDataSource{
    
    public func numberOfSections(in tableView: UITableView) -> Int{
        return self.dataSource?.count ?? 0
    }
    
    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?  {
        let table = self.dataSource?[section]
        return "表名:\(table?.table_name ?? "")"
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource?[section]?.fields?.count ?? 0
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let field = self.dataSource?[indexPath.section]?.fields?[indexPath.row]
        cell.textLabel?.text = "字段:\(field?.name ?? "")"
        return cell
    }
}
