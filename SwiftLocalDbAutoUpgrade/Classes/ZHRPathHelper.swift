//
//  ZHRPathHelper.swift
//  SwiftDBOnlineUpgrade
//
//  Created by mars on 2018/1/30.
//  Copyright © 2018年 com.chengduzoharo.xiangzhu. All rights reserved.
//

import UIKit

class ZHRPathHelper: NSObject {
    
    /// 主目录
    static let homeDirectory: String = {
        return NSHomeDirectory()
    }()

    /// 文档路径
    static let documentsDirectory: URL = {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.endIndex - 1]
    }()
    
    //缓存路径
    static let cacheDirectory: URL = {
        let urls = FileManager.default.urls(for:.cachesDirectory, in: .userDomainMask)
        return urls[urls.endIndex - 1]
    }()
}

extension String {
    /// 转行为 file://XXXX
    ///
    /// - Returns:
    func filePath() -> String {
        return "file://" + self
    }
    
    
    /// file://XXXX 转为 XXXX
    ///
    /// - Returns:
    func path() -> String {
        let startIndex = self.index(self.startIndex, offsetBy: 7)
        return String(self[startIndex...])
    }
}
