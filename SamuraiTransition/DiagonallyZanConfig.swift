//
//  DiagonallyZanConfig.swift
//  SamuraiTransition
//
//  Created by Nishinobu.Takahiro on 2016/12/07.
//  Copyright © 2016年 hachinobu. All rights reserved.
//

import Foundation

class DiagonallyZanConfig: ZanLineProtocol, SamuraiConfigProtocol {
    
    let containerFrame: CGRect
    let zanPoint: CGPoint
    let lineWidth: CGFloat
    let lineColor: UIColor
    
    //conform SamuraiConfigProtocol
    lazy var lineLayers: [CAShapeLayer] = {
        let lineLayer = self.zanLineLayer(from: CGPoint(x: self.containerFrame.maxX, y: self.containerFrame.minY), end: CGPoint(x: self.calculateTopRightToBottomLeftX(containerFrame: self.containerFrame, zanPoint: self.zanPoint), y: self.containerFrame.maxY), width: self.lineWidth, color: self.lineColor)
        return [lineLayer]
    }()
    
    lazy var zanViewConfigList: [ZanViewConfigProtocol] = {
        let maskLayers = self.zanMaskLayers()
        let oneSideConfig = ZanViewConfig(inSideFrame: self.containerFrame, outSideFrame: self.containerFrame.offsetBy(dx: self.containerFrame.width, dy: self.containerFrame.height), mask: maskLayers.oneSide)
        let otherSideConfig = ZanViewConfig(inSideFrame: self.containerFrame, outSideFrame: self.containerFrame.offsetBy(dx: -self.containerFrame.width, dy: -self.containerFrame.height), mask: maskLayers.otherSide)
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
    
    fileprivate func zanMaskLayers() -> (oneSide: CAShapeLayer, otherSide: CAShapeLayer) {
        
        let bottomX = calculateTopRightToBottomLeftX(containerFrame: containerFrame, zanPoint: zanPoint)
        let oneSidePath = rightAreaBezierPath(bottomX: bottomX)
        let oneSideLayer = CAShapeLayer()
        oneSideLayer.path = oneSidePath.cgPath
        
        let otherSidePath = leftAreaBezierPath(bottomX: bottomX)
        let otherSideLayer = CAShapeLayer()
        otherSideLayer.path = otherSidePath.cgPath
        
        return (oneSideLayer, otherSideLayer)
    }
    
    fileprivate func rightAreaBezierPath(bottomX: CGFloat) -> UIBezierPath {
        
        let oneSidePath = UIBezierPath()
        oneSidePath.move(to: CGPoint(x: containerFrame.maxX, y: containerFrame.minY))
        oneSidePath.addLine(to: zanPoint)
        oneSidePath.addLine(to: CGPoint(x: bottomX, y: containerFrame.maxY))
        oneSidePath.addLine(to: CGPoint(x: containerFrame.maxX, y: containerFrame.maxY))
        oneSidePath.addLine(to: CGPoint(x: containerFrame.maxX, y: containerFrame.minY))
        oneSidePath.close()
        
        return oneSidePath
    }
    
    fileprivate func leftAreaBezierPath(bottomX: CGFloat) -> UIBezierPath {
        
        let otherSidePath = UIBezierPath()
        otherSidePath.move(to: CGPoint(x: containerFrame.minX, y: containerFrame.minY))
        otherSidePath.addLine(to: CGPoint(x: containerFrame.maxX, y: containerFrame.minY))
        otherSidePath.addLine(to: CGPoint(x: bottomX, y: containerFrame.maxY))
        otherSidePath.addLine(to: CGPoint(x: containerFrame.minX, y: containerFrame.maxY))
        otherSidePath.addLine(to: CGPoint(x: containerFrame.minX, y: containerFrame.minY))
        otherSidePath.close()
        
        return otherSidePath
    }
    
}
