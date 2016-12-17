//
//  ZanViewConfig.swift
//  SamuraiTransition
//
//  Created by Nishinobu.Takahiro on 2016/12/05.
//  Copyright © 2016年 hachinobu. All rights reserved.
//

import Foundation

struct ZanViewConfig: ZanViewConfigProtocol {
    
    let insideFrame: CGRect
    let outSideFrame: CGRect
    let mask: CAShapeLayer?
    let isAlphaAnimation: Bool
    
    init(insideFrame: CGRect, outSideFrame: CGRect, isAlphaAnimation: Bool = false, mask: CAShapeLayer? = nil) {
        self.insideFrame = insideFrame
        self.outSideFrame = outSideFrame
        self.isAlphaAnimation = isAlphaAnimation
        self.mask = mask
    }
    
}
