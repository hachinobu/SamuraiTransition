//
//  ZanViewInfo.swift
//  SamuraiTransition
//
//  Created by Nishinobu.Takahiro on 2016/12/05.
//  Copyright © 2016年 hachinobu. All rights reserved.
//

import Foundation

struct ZanViewInfo {
    
    let insideFrame: CGRect
    let outSideFrame: CGRect
    let mask: CAShapeLayer?
    
    init(insideFrame: CGRect, outSideFrame: CGRect, mask: CAShapeLayer? = nil) {
        self.insideFrame = insideFrame
        self.outSideFrame = outSideFrame
        self.mask = mask
    }
    
    func animateViewFrame(isPresenting: Bool) -> CGRect {
        return isPresenting ? insideFrame : outSideFrame
    }
    
}
