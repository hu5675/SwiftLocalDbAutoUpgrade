//
//  ZHRDBHelper.swift
//  Zoharo_swift
//
//  Created by b on 16/9/7.
//  Copyright © 2016年 ZHR. All rights reserved.
//

import UIKit
import FMDB

class ZHRDB {
    
    fileprivate var databaseName:String? = nil
    
    fileprivate var database:FMDatabase? = nil
    
    fileprivate var semaphore = DispatchSemaphore.init(value: 1)
    
    /// 数据库存放目录
    public let databasePath:String = {
        let documentPath = ZHRPathHelper.documentsDirectory.absoluteString
        let startIndex = documentPath.index(documentPath.startIndex, offsetBy: 7)
        return String(documentPath[startIndex...])
    }()
    
    
    
    public init(dbName:String,password:String?){
        self.databaseName = dbName
        self.checkDBExsit(dbName: dbName)
        self.openDatabase(dbPath: self.databasePath + dbName, password: password)
    }
    
    
    /**
     检查数据库是否存在 document 目录中，没有复制
     */
    private func checkDBExsit(dbName:String){
        let documentPath = ZHRPathHelper.documentsDirectory.absoluteString.appendingFormat(dbName)
        let startIndex = documentPath.index(documentPath.startIndex, offsetBy: 7)
        let dbFilePath = String(documentPath[startIndex...])
        print("数据库文件路径:\(dbFilePath)")
        
        if !FileManager.default.fileExists(atPath: dbFilePath) {
            //不存在
            let resoucePath = Bundle.main.path(forResource: dbName, ofType: nil)
            try! FileManager.default.copyItem(atPath: resoucePath!, toPath: dbFilePath)
        }
    }
    
    
    /**
     连接并打开数据库
     
     - parameter dbPath:
     - parameter password:
     */
    private func openDatabase(dbPath:String,password:String?){
        if self.database != nil {
            return;
        }
        self.database = FMDatabase(path: dbPath)
        self.database?.open()
        if let password = password { //加密数据库需要解密
            self.database?.setKey(password)
//            try! self.database?.executeQuery("PRAGMA cipher_migrate;", values: nil)
        }
        self.database?.shouldCacheStatements = true
    }
    
    
    
    /**
     关闭数据库连接 并释放
     */
    public func closeDatabase(){
        if self.database != nil {
            self.database?.close()
            self.database = nil
        }
    }
    
    
    /**
     列表查询
     
     - parameter sql:
     
     - returns:
     */
    func selectList(sql:String) -> [AnyObject]!{
        semaphore.wait()
        let resultSet = try? self.database?.executeQuery(sql, values: nil)
        var dataList = [AnyObject]()
        while(resultSet??.next() == true){
            let rowDict = resultSet??.resultDictionary
            if let rowDict = rowDict {
                dataList.append(rowDict as AnyObject)
            }
        }
        semaphore.signal()
        return dataList as [AnyObject]
    }
    
    
    
    /**
     列表查询
     
     - parameter sql:
     - parameter values:
     
     - returns:
     */
    func selectList(sql:String,values:[String:AnyObject]) -> [AnyObject]!{
        let resultSet =  self.database?.executeQuery(sql, withParameterDictionary: values)
        var dataList = [AnyObject]();
        while(resultSet?.next() == true){
            let rowDict = resultSet?.resultDictionary
            if let rowDict = rowDict {
                dataList.append(rowDict as AnyObject)
            }
        }
        return dataList as [AnyObject]
    }
    
    
    /**
     单个记录查询
     
     - parameter sql:
     
     - returns:
     */
    func selectOne(sql:String) -> [String:AnyObject]?{
        semaphore.wait()
        let resultSet = try? self.database?.executeQuery(sql, values: nil)
        while(resultSet??.next() == true){
            let rowDict = resultSet??.resultDictionary
            semaphore.signal()
            return rowDict as? [String : AnyObject]
        }
        semaphore.signal()
        return nil
    }
    
    
    /// 是否存在记录
    ///
    /// - Parameter sql:
    /// - Returns:
    func exsit(sql:String) -> Bool{
        semaphore.wait()
        let resultSet = try? self.database?.executeQuery(sql, values: nil)
        semaphore.signal()
        
        while(resultSet??.next() == true){
            return true
        }
        return false
    }
    
    /**
     更新sql语句
     
     - parameter sql:
     
     - returns:
     */
    internal func update(sql:String) -> Bool {
        return (self.database?.executeUpdate(sql, withArgumentsIn: []))!
    }
    
    /**
     删除
     
     - parameter sql:
     
     - returns:
     */
    internal func deleteSql(sql:String) -> Bool {
        return (self.database?.executeUpdate(sql, withArgumentsIn: []))!
    }
    
}
