//
//  DiagonallyZanConfig.swift
//  SamuraiTransition
//
//  Created by Nishinobu.Takahiro on 2016/12/07.
//  Copyright © 2016年 hachinobu. All rights reserved.
//

import Foundation

class DiagonallyZanConfig: OneLineZanProtocol, SamuraiConfigProtocol {
    
    let containerFrame: CGRect
    let zanPoint: CGPoint
    let lineWidth: CGFloat
    let lineColor: UIColor
    
    //conform SamuraiConfigProtocol
    lazy var lineLayers: [CAShapeLayer] = {
        let lineLayer = self.zanLineLayer(from: CGPoint(x: self.containerFrame.maxX, y: self.containerFrame.minY), end: CGPoint(x: self.zanPointBottomX(), y: self.containerFrame.maxY), width: self.lineWidth, color: self.lineColor)
        return [lineLayer]
    }()
    
    lazy var zanViewConfigList: [ZanViewConfigProtocol] = {
        let maskLayers = self.zanMaskLayers()
        let oneSideConfig = ZanViewConfig(insideFrame: self.containerFrame, outSideFrame: self.containerFrame.offsetBy(dx: self.containerFrame.width, dy: self.containerFrame.height), mask: maskLayers.oneSide)
        let otherSideConfig = ZanViewConfig(insideFrame: self.containerFrame, outSideFrame: self.containerFrame.offsetBy(dx: -self.containerFrame.width, dy: -self.containerFrame.height), mask: maskLayers.otherSide)
        return [oneSideConfig, otherSideConfig]
    }()
    
    init(containerFrame: CGRect, zanPoint: CGPoint, lineWidth: CGFloat, lineColor: UIColor) {
        self.containerFrame = containerFrame
        self.zanPoint = zanPoint
        self.lineWidth = lineWidth
        self.lineColor = lineColor
    }
    
}

extension DiagonallyZanConfig {
    
    fileprivate func zanPointBottomX() -> CGFloat {
        
        let ratio = containerFrame.maxY / zanPoint.y
        if ratio.isInfinite {
            fatalError("zanPosition.y is not 0. It will be infinite.")
        }
        let width = (containerFrame.maxX - zanPoint.x) * ratio
        let bottomX = containerFrame.maxX - width
        
        return bottomX
    }
    
    fileprivate func zanMaskLayers() -> (oneSide: CAShapeLayer, otherSide: CAShapeLayer) {
        
        let bottomX = zanPointBottomX()
        let oneSidePath = oneSideBezierPath(containerFrame: containerFrame, zanPoint: zanPoint, bottomX: bottomX)
        let oneSideLayer = CAShapeLayer()
        oneSideLayer.path = oneSidePath.cgPath
        let otherSidePath = otherSideBezierPath(containerFrame: containerFrame, zanPoint: zanPoint, bottomX: bottomX)
        let otherSideLayer = CAShapeLayer()
        otherSideLayer.path = otherSidePath.cgPath
        
        return (oneSideLayer, otherSideLayer)
    }
    
}
