//
//  HorizontalZanConfig.swift
//  SamuraiTransition
//
//  Created by Nishinobu.Takahiro on 2016/12/07.
//  Copyright © 2016年 hachinobu. All rights reserved.
//

import Foundation

class HorizontalZanConfig: OneLineZanProtocol, SamuraiConfigProtocol {
    
    let containerFrame: CGRect
    let zanPoint: CGPoint
    let width: CGFloat
    let color: UIColor
    
    //conform SamuraiConfigProtocol
    lazy var lineLayers: [CAShapeLayer] = {
        let lineLayer = self.zanLineLayer(from: CGPoint(x: self.containerFrame.minX, y: self.zanPoint.y), end: CGPoint(x: self.containerFrame.maxX, y: self.zanPoint.y), width: self.width, color: self.color)
        return [lineLayer]
    }()
    
    lazy var zanViewConfigList: [ZanViewConfigProtocol] = {
        let divided = self.containerFrame.divided(atDistance: self.zanPoint.y, from: .minYEdge)
        let slice = divided.slice
        let remainder = divided.remainder
        
        let oneSideConfig = ZanViewConfig(insideFrame: slice, outSideFrame: slice.offsetBy(dx: 0.0, dy: -slice.height))
        let otherSideConfig = ZanViewConfig(insideFrame: remainder, outSideFrame: remainder.offsetBy(dx: 0.0, dy: remainder.height))
        
        return [oneSideConfig, otherSideConfig]
    }()
    
    init(containerFrame: CGRect, zanPoint: CGPoint, width: CGFloat, color: UIColor) {
        self.containerFrame = containerFrame
        self.zanPoint = zanPoint
        self.width = width
        self.color = color
    }
    
}
