//
//  ZHRTableModel.swift
//  SwiftDBOnlineUpgrade
//
//  Created by mars on 2018/1/30.
//  Copyright © 2018年 com.chengduzoharo.xiangzhu. All rights reserved.
//

import UIKit
import HandyJSON

open class ZHRTableModel: HandyJSON {

    required public init() {
        
    }
    
    open var table_name:String? = nil
    
    open var fields:[ZHRFieldModel?]? = nil
}
