//
//  ZHRTableModel.swift
//  SwiftDBOnlineUpgrade
//
//  Created by mars on 2018/1/30.
//  Copyright © 2018年 com.chengduzoharo.xiangzhu. All rights reserved.
//

import UIKit
import HandyJSON

class ZHRTableModel: HandyJSON {

    required init() {
        
    }
    
    var table_name:String? = nil
    
    var fields:[ZHRFieldModel?]? = nil
}
