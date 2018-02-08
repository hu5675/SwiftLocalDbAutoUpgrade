//
//  ZHRDBManager.swift
//  SwiftDBOnlineUpgrade
//
//  Created by mars on 2018/1/30.
//  Copyright © 2018年 com.chengduzoharo.xiangzhu. All rights reserved.
//

import UIKit

class ZHRDBManager: NSObject {

    static let shared:ZHRDBManager =  ZHRDBManager.init()
    
    static var dbName:String = "Record.db"
    
    public var db:ZHRDB! = ZHRDB(dbName: dbName, password: nil)
    
    
    /// 查询本地数据库表结构信息
    ///
    /// - Returns:
    func queryAllTable() -> [ZHRTableModel?]? {
        let sql = "select name as table_name from sqlite_master where type='table' and name != 'sqlite_sequence'"
        let result =  ZHRDBManager.shared.db.selectList(sql: sql)
        let tables = [ZHRTableModel].deserialize(from: result) ?? []
        for table in tables {
            if let table = table {
                let tSql = " PRAGMA table_info(\(table.table_name ?? "")) "
                let tResult =  ZHRDBManager.shared.db.selectList(sql: tSql)
                let fields = [ZHRFieldModel].deserialize(from: tResult) ?? []
                table.fields = fields
            }
        }
        return tables
    }
}
