//
//  TriangleZanConfig.swift
//  SamuraiTransition
//
//  Created by Nishinobu.Takahiro on 2016/12/19.
//  Copyright © 2016年 hachinobu. All rights reserved.
//

import Foundation

class TriangleZanConfig: OneLineZanProtocol, SamuraiConfigProtocol {
    
    let containerFrame: CGRect
    let zanPoint: CGPoint
    let lineWidth: CGFloat
    let lineColor: UIColor
    let oneSide: CGFloat
    
    //conform SamuraiConfigProtocol
    lazy var lineLayers: [CAShapeLayer] = {
        
        let path = self.trianglePath()
        let triangleLineLayer = self.zanLineLayer(from: path, width: self.lineWidth, color: self.lineColor)
        
        return [triangleLineLayer]
    }()
    
    lazy var zanViewConfigList: [ZanViewConfigProtocol] = {
        
        let maskLayers = self.zanMaskLayers()
        let oneSideConfig = ZanViewConfig(insideFrame: self.containerFrame, outSideFrame: self.containerFrame.offsetBy(dx: 0.0, dy: self.containerFrame.maxY), isAlphaAnimation: true, mask: maskLayers.oneSide)
        let otherSideConfig = ZanViewConfig(insideFrame: self.containerFrame, outSideFrame: self.containerFrame, mask: maskLayers.otherSide)
        return [oneSideConfig, otherSideConfig]
        
    }()
    
    init(containerFrame: CGRect, zanPoint: CGPoint, lineWidth: CGFloat, lineColor: UIColor, oneSide: CGFloat) {
        self.containerFrame = containerFrame
        self.zanPoint = zanPoint
        self.lineWidth = lineWidth
        self.lineColor = lineColor
        self.oneSide = oneSide
    }
    
}

extension TriangleZanConfig {
    
    fileprivate func zanMaskLayers() -> (oneSide: CAShapeLayer, otherSide: CAShapeLayer) {
        
        let oneSide = CAShapeLayer()
        let outerTrianglePath = trianglePath()
        outerTrianglePath.addLine(to: CGPoint(x: outerTrianglePath.currentPoint.x, y: containerFrame.minY))
        outerTrianglePath.addLine(to: CGPoint(x: containerFrame.maxX, y: outerTrianglePath.currentPoint.y))
        outerTrianglePath.addLine(to: CGPoint(x: outerTrianglePath.currentPoint.x, y: containerFrame.maxY))
        outerTrianglePath.addLine(to: CGPoint(x: containerFrame.minX, y: outerTrianglePath.currentPoint.y))
        outerTrianglePath.addLine(to: CGPoint(x: outerTrianglePath.currentPoint.x, y: containerFrame.minY))
        outerTrianglePath.addLine(to: CGPoint(x: containerFrame.maxX, y: outerTrianglePath.currentPoint.y))
        oneSide.path = outerTrianglePath.cgPath
        
        let otherSide = CAShapeLayer()
        let innerTrianglePath = trianglePath()
        otherSide.path = innerTrianglePath.cgPath
        
        return (oneSide, otherSide)
        
    }
    
    fileprivate func trianglePath() -> UIBezierPath {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: zanPoint.x, y: zanPoint.y - oneSide / 2.0))
        path.addLine(to: CGPoint(x: path.currentPoint.x - oneSide / 2.0, y: path.currentPoint.y + oneSide))
        path.addLine(to: CGPoint(x: path.currentPoint.x + oneSide, y: path.currentPoint.y))
        path.addLine(to: CGPoint(x: zanPoint.x, y: zanPoint.y - oneSide / 2.0))
        return path
    }
    
}
