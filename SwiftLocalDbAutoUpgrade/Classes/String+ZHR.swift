//
//  String+Mars.swift
//  SwiftDBOnlineUpgrade
//
//  Created by mars on 2018/2/7.
//  Copyright © 2018年 com.chengduzoharo.xiangzhu. All rights reserved.
//

extension String{
    /// 下标取字符串
    ///
    /// - Parameter r:  xxx[1..<4]
    subscript(r:Range<Int>) -> String{
        get{
            let startIndex = self.utf8.index(self.startIndex, offsetBy: r.lowerBound)
            let endIndex = self.utf8.index(self.startIndex, offsetBy: r.upperBound)
            return String(self[startIndex..<endIndex])
        }
    }
}
