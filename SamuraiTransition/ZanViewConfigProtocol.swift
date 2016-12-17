//
//  ZanViewConfigProtocol.swift
//  SamuraiTransition
//
//  Created by Nishinobu.Takahiro on 2016/12/07.
//  Copyright © 2016年 hachinobu. All rights reserved.
//

import Foundation

public protocol ZanViewConfigProtocol {
    
    var insideFrame: CGRect { get }
    var outSideFrame: CGRect { get }
    var isAlphaAnimation: Bool { get }
    var mask: CAShapeLayer? { get }
    
}

extension ZanViewConfigProtocol {
    
    func viewFrame(isPresenting: Bool) -> CGRect {
        return isPresenting ? insideFrame : outSideFrame
    }
    
}
