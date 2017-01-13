//
//  Device.swift
//  SamuraiTransition
//
//  Created by Nishinobu.Takahiro on 2017/01/13.
//  Copyright © 2017年 hachinobu. All rights reserved.
//

import Foundation

struct Device {
    
    static var isSimulator: Bool {
        return TARGET_OS_SIMULATOR != 0
    }
    
}

