//
//  ZHRPlistHelper.swift
//  SwiftDBOnlineUpgrade
//
//  Created by mars on 2018/2/1.
//  Copyright © 2018年 com.chengduzoharo.xiangzhu. All rights reserved.
//

import UIKit

class ZHRPlistHelper: NSObject {

    /// plist中的表结构
    ///
    /// - Returns:
    class func tablesStructureForPlist(plistFileName:String) -> [ZHRTableModel?]? {
        ZHRPlistHelper.checkPlistExsit(plistName: plistFileName)
        
        let path = ZHRPathHelper.documentsDirectory.appendingPathComponent(plistFileName).absoluteString.path()
        let array = NSArray(contentsOfFile: path)
        let tables = [ZHRTableModel].deserialize(from: array)
        return tables
    }
    
    
    /// 复制最近plist到document中去
    ///
    /// - Parameter plistName:
    private class func checkPlistExsit(plistName:String){
        let plistUrl = ZHRPathHelper.documentsDirectory.appendingPathComponent(plistName).absoluteString
        
        if FileManager.default.fileExists(atPath: plistUrl.path()) {
            try? FileManager.default.removeItem(at: URL.init(string: plistUrl.filePath())!)
        }
        //不存在
        let resoucePath = Bundle.main.path(forResource: plistName, ofType: nil)
        try? FileManager.default.copyItem(atPath: resoucePath!, toPath: plistUrl.path())
    }
    
}
