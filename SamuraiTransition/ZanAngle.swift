//
//  ZanAngle.swift
//  SamuraiTransition
//
//  Created by Takahiro Nishinobu on 2016/11/26.
//  Copyright © 2016年 hachinobu. All rights reserved.
//

import Foundation

public enum ZanAngle {
    
    case horizontal
    case vertical
    
    func isHorizontal() -> Bool {
        return self == .horizontal
    }
    
}
