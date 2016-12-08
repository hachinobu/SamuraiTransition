//
//  VerticalZanConfig.swift
//  SamuraiTransition
//
//  Created by Nishinobu.Takahiro on 2016/12/07.
//  Copyright © 2016年 hachinobu. All rights reserved.
//

import Foundation

class VerticalZanConfig: OneLineZanProtocol, SamuraiConfigProtocol {
    
    let containerFrame: CGRect
    let zanPoint: CGPoint
    let width: CGFloat
    let color: UIColor
    
    //conform SamuraiConfigProtocol
    lazy var lineLayers: [CAShapeLayer] = {
        let lineLayer = self.zanLineLayer(from: CGPoint(x: self.zanPoint.x, y: self.containerFrame.minY), end: CGPoint(x: self.zanPoint.x, y: self.containerFrame.maxY), width: self.width, color: self.color)
        return [lineLayer]
    }()
    
    lazy var zanViewConfigList: [ZanViewConfigProtocol] = {
        let divided = self.containerFrame.divided(atDistance: self.zanPoint.x, from: .minXEdge)
        let slice = divided.slice
        let remainder = divided.remainder
        
        let oneSideConfig = ZanViewConfig(insideFrame: slice, outSideFrame: slice.offsetBy(dx: -slice.width, dy: 0.0))
        let otherSideConfig = ZanViewConfig(insideFrame: remainder, outSideFrame: remainder.offsetBy(dx: remainder.width, dy: 0.0))
        
        return [oneSideConfig, otherSideConfig]
    }()
    
    init(containerFrame: CGRect, zanPoint: CGPoint, width: CGFloat, color: UIColor) {
        self.containerFrame = containerFrame
        self.zanPoint = zanPoint
        self.width = width
        self.color = color
    }
    
}
