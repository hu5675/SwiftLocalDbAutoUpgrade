//
//  ZHRUpgradeManager.swift
//  SwiftDBOnlineUpgrade
//
//  Created by mars on 2018/1/30.
//  Copyright © 2018年 com.chengduzoharo.xiangzhu. All rights reserved.
//

import UIKit

open class ZHRUpgradeManager: NSObject {

    open static let shared:ZHRUpgradeManager =  ZHRUpgradeManager.init()
    
    /// 根据plist中的数据库结构 更新 本地的数据库db结构
    ///
    /// - Parameters:
    ///   - plistName:
    ///   - dbName:
    /// - Returns:
    open func upgrade(plistName:String,dbName:String) -> Bool {
        ZHRDBManager.dbName = dbName
        
        let plistTables = ZHRPlistHelper.tablesStructureForPlist(plistFileName: plistName) ?? []
        let dbTables = ZHRDBManager.shared.queryAllTable() ?? []
        let result = self.checkModifyTables(plistTables: plistTables, dbTables: dbTables)
        
        let r1 = self.dynamicCreateTables(tables: result.addTables)
        let r2 = self.dynamicDeleteTables(tables: result.deleteTables)
        let r3 = self.dynamicDeleteFields(deleteFieldTables: result.deleteFieldsTables, originTables: dbTables)
        let r4 = self.dynamicAddFields(addFieldTables: result.addFieldsTables)
        
        return r1 && r2 && r3 && r4
    }
    
    
    /// 对比plist中的表结构  和 本地库中的表结构
    ///
    /// - Parameters:
    ///   - plistTables:
    ///   - dbTables:
    /// - Returns:
    fileprivate func checkModifyTables(plistTables:[ZHRTableModel?],dbTables:[ZHRTableModel?]) -> (addTables:[ZHRTableModel],deleteTables:[ZHRTableModel],addFieldsTables:[ZHRTableModel],deleteFieldsTables:[ZHRTableModel]){
        
        var addTables:[ZHRTableModel] = []
        var deleteTables:[ZHRTableModel] = []
        var addFieldsTables:[ZHRTableModel] = []
        var deleteFieldsTables:[ZHRTableModel] = []
        
        //临时变量 存储数据库中和plist中同时包含的表 也就是这些表的字段可能发生变化
        var plistTempTables: [ZHRTableModel] = []
        var dbTempTables: [ZHRTableModel] = []
        
        //查找新添加的表
        for pTable in plistTables {
            if let pTable = pTable {
                let filter = dbTables.filter({ (dTable) -> Bool in
                    if dTable?.table_name == pTable.table_name {
                        return true
                    }
                    return false
                })
                if filter.count == 0 {
                    addTables.append(pTable)
                }else{
                    plistTempTables.append(pTable)
                }
            }
        }
        
        //查找删除的表
        for dTable in dbTables {
            if let dTable = dTable {
                let filter = plistTables.filter({ (pTable) -> Bool in
                    if pTable?.table_name == dTable.table_name {
                        return true
                    }
                    return false
                })
                if filter.count == 0 {
                    deleteTables.append(dTable)
                }else{
                    dbTempTables.append(dTable)
                }
            }
        }
        
        //查找变化的字段 只支持添加或删除字段
        for pTable in plistTempTables {
            for dTable in dbTempTables {
                if pTable.table_name == dTable.table_name {
                    //比较字段
                    let fieldResult = self.checkModifyFields(plistTable: pTable, dbTable: dTable)
                    if fieldResult.addFieldTable.fields!.count > 0 {
                        addFieldsTables.append(fieldResult.addFieldTable)
                    }
                    if fieldResult.deleteFieldTable.fields!.count > 0 {
                        deleteFieldsTables.append(fieldResult.deleteFieldTable)
                    }
                }
            }
        }
        return (addTables,deleteTables,addFieldsTables,deleteFieldsTables)
    }
    
    
    
    /// 比较本地库 和 plist 同一表名 对应的字段
    ///
    /// - Parameters:
    ///   - plistTable:
    ///   - dbTable:
    /// - Returns:
    fileprivate func checkModifyFields(plistTable:ZHRTableModel,dbTable:ZHRTableModel) -> (addFieldTable:ZHRTableModel,deleteFieldTable:ZHRTableModel){
        
        let addFieldTable:ZHRTableModel = ZHRTableModel()
        addFieldTable.table_name = plistTable.table_name
        addFieldTable.fields = [ZHRFieldModel]()
        
        let deleteFieldTable:ZHRTableModel = ZHRTableModel()
        deleteFieldTable.table_name = plistTable.table_name
        deleteFieldTable.fields = [ZHRFieldModel]()
        
        //查找添加的字段
        for pField in plistTable.fields ?? [] {
            let filter = (dbTable.fields ?? []).filter({ (dField) -> Bool in
                if dField?.name == pField?.name {
                    return true
                }
                return false
            })
            if filter.count == 0 {
                addFieldTable.fields?.append(pField)
            }
        }
        
        //查找删除的字段
        for dField in dbTable.fields ?? [] {
            let filter = (plistTable.fields ?? []).filter({ (pField) -> Bool in
                if pField?.name == dField?.name {
                    return true
                }
                return false
            })
            if filter.count == 0 {
                deleteFieldTable.fields?.append(dField)
            }
        }
        return (addFieldTable,deleteFieldTable)
    }
    
    
    /// 根据表结构动态创建table
    ///
    /// - Parameter tables:
    /// - Returns:
    fileprivate func dynamicCreateTables(tables:[ZHRTableModel]) -> Bool{
        for table in tables {
            if let table_name = table.table_name,let fields = table.fields {
                if fields.count > 0 {
                    var sql = " create table \(table_name) ("
                    for (_,field) in fields.enumerated() {
                        sql += "\(field?.type ?? "text"),"
                    }
                    sql = sql[0..<sql.utf8.count - 1]
                    sql += ")"
                    
                    let result = ZHRDBManager.shared.db.update(sql: sql)
                    if !result {
                        return result
                    }
                }
            }
        }
        return true
    }
    
    /// 动态删除表
    ///
    /// - Parameter tables:
    /// - Returns:
    fileprivate func dynamicDeleteTables(tables:[ZHRTableModel]) -> Bool{
        for table in tables {
            if let table_name = table.table_name {
                let sql = " drop table \(table_name)"
                let result = ZHRDBManager.shared.db.update(sql: sql)
                if !result {
                    return result
                }
            }
        }
        return true
    }
    
    /// 动态删除表
    ///
    /// - Parameter tables:
    /// - Returns:
    fileprivate func dynamicDeleteFields(deleteFieldTables:[ZHRTableModel],originTables:[ZHRTableModel?]) -> Bool{
        guard deleteFieldTables.count > 0 else {
            return true
        }
        for table in deleteFieldTables {
            let filter = originTables.filter({ (model) -> Bool in
                return model?.table_name == table.table_name
            })
            if filter.count >= 1 {
                let allFieldTable = filter[0]
                if let table_name = table.table_name ,let fields = table.fields,let allFields = allFieldTable?.fields {
                    var sql = "create table temp as select "
                    for field in allFields {
                        let filter = fields.filter({ (model) -> Bool in
                            return model?.name == field?.name
                        })
                        if filter.count == 0 {
                            sql += " \(field?.name ?? ""),"
                        }
                    }
                    sql = sql[0..<sql.utf8.count - 1]
                    sql += " from \(table_name) where 1=1"
                    let result = ZHRDBManager.shared.db.update(sql: sql)
                    if !result {
                        return result
                    }
                    
                    _ = ZHRDBManager.shared.db.update(sql:"drop table \(table_name)")
                    _ = ZHRDBManager.shared.db.update(sql:"alter table temp rename to \(table_name)")
                }
            }
        }
        return true
    }
    
    /// 动态添加字段
    ///
    /// - Parameter addFieldTables:
    /// - Returns:
    fileprivate func dynamicAddFields(addFieldTables:[ZHRTableModel]) -> Bool{
        guard addFieldTables.count > 0 else {
            return true
        }
        for table in addFieldTables {
            if let table_name = table.table_name ,let fields = table.fields {
                let sql = "alter table \(table_name) add "
                for field in fields { //一列一列的添加
                    let columnSql = sql + "\(field?.type ?? "")"
                    let result = ZHRDBManager.shared.db.update(sql:columnSql)
                    if !result {
                        return result
                    }
                }
            }
        }
        return true
    }
}
