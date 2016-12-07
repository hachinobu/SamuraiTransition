//
//  ZanConfigProtocol.swift
//  SamuraiTransition
//
//  Created by Nishinobu.Takahiro on 2016/12/07.
//  Copyright © 2016年 hachinobu. All rights reserved.
//

import Foundation

public protocol SamuraiConfigProtocol {
    
    var lineLayers: [CAShapeLayer] { get }
    var zanViewConfigList: [ZanViewConfigProtocol] { get }
    
}
