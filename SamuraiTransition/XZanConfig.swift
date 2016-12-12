//
//  XZanConfig.swift
//  SamuraiTransition
//
//  Created by Nishinobu.Takahiro on 2016/12/12.
//  Copyright © 2016年 hachinobu. All rights reserved.
//

import Foundation

class XZanConfig: OneLineZanProtocol, SamuraiConfigProtocol {
    
    let containerFrame: CGRect
    let zanPoint: CGPoint
    let width: CGFloat
    let color: UIColor
    
    //conform SamuraiConfigProtocol
    lazy var lineLayers: [CAShapeLayer] = {
        
        let oneCrossLineLayer = self.zanLineLayer(from: CGPoint(x: self.containerFrame.maxX, y: 0.0), end: CGPoint(x: self.calculateBottomLeftX(containerFrame: self.containerFrame, zanPoint: self.zanPoint), y: self.containerFrame.maxY), width: self.width, color: self.color)
        let otherCrossLineLayer = self.zanLineLayer(from: CGPoint(x: 0.0, y: 0.0), end: CGPoint(x: self.calculateBottomRightX(containerFrame: self.containerFrame, zanPoint: self.zanPoint), y: self.containerFrame.maxY), width: self.width, color: self.color)
        
        return [oneCrossLineLayer, otherCrossLineLayer]
    }()
    
    lazy var zanViewConfigList: [ZanViewConfigProtocol] = {
        
        let xLayers = self.zanXMaskLayers()
        let topViewConfig = ZanViewConfig(insideFrame: self.containerFrame, outSideFrame: self.containerFrame.offsetBy(dx: 0.0, dy: -self.zanPoint.y), mask: xLayers.top)
        let leftViewConfig = ZanViewConfig(insideFrame: self.containerFrame, outSideFrame: self.containerFrame.offsetBy(dx: -self.zanPoint.x, dy: 0.0), mask: xLayers.left)
        let bottomViewConfig = ZanViewConfig(insideFrame: self.containerFrame, outSideFrame: self.containerFrame.offsetBy(dx: 0.0, dy: (self.containerFrame.height - self.zanPoint.y)), mask: xLayers.bottom)
        let rightViewConfig = ZanViewConfig(insideFrame: self.containerFrame, outSideFrame: self.containerFrame.offsetBy(dx: self.containerFrame.width - self.zanPoint.x, dy: 0.0), mask: xLayers.right)
        
        return [topViewConfig, leftViewConfig, bottomViewConfig, rightViewConfig]
        
    }()
    
    init(containerFrame: CGRect, zanPoint: CGPoint, width: CGFloat, color: UIColor) {
        self.containerFrame = containerFrame
        self.zanPoint = zanPoint
        self.width = width
        self.color = color
    }
    
}

extension XZanConfig {
    
    fileprivate func zanXMaskLayers() -> (top: CAShapeLayer, left: CAShapeLayer, bottom: CAShapeLayer, right: CAShapeLayer) {
        
        let topLeftSideRightAnglePoint = CGPoint(x: containerFrame.minX, y: containerFrame.minY)
        let topRightSideRightAnglePoint = CGPoint(x: containerFrame.maxX, y: containerFrame.minY)
        let bottomLeftSideRightAnglePoint = CGPoint(x: containerFrame.minX, y: containerFrame.maxY)
        let bottomRightSideRightAnglePoint = CGPoint(x: containerFrame.maxX, y: containerFrame.maxY)
        let bottomLeftPoint = CGPoint(x: calculateBottomLeftX(containerFrame: containerFrame, zanPoint: zanPoint), y: containerFrame.maxY)
        let bottomRightPoint = CGPoint(x: calculateBottomRightX(containerFrame: containerFrame, zanPoint: zanPoint), y: containerFrame.maxY)
        
        let topAreaPath = triangleAreaPath(point1: topLeftSideRightAnglePoint, point2: zanPoint, point3: topRightSideRightAnglePoint)
        let leftAreaPath = rectangleAreaPath(point1: topLeftSideRightAnglePoint, point2: zanPoint, point3: bottomLeftPoint, point4: bottomLeftSideRightAnglePoint)
        let bottomAreaPath = triangleAreaPath(point1: bottomLeftPoint, point2: zanPoint, point3: bottomRightPoint)
        let rightAreaPath = rectangleAreaPath(point1: topRightSideRightAnglePoint, point2: zanPoint, point3: bottomRightPoint, point4: bottomRightSideRightAnglePoint)
        
        let topAreaLayer = CAShapeLayer()
        topAreaLayer.path = topAreaPath.cgPath
        
        let leftAreaLayer = CAShapeLayer()
        leftAreaLayer.path = leftAreaPath.cgPath
        
        let bottomAreaLayer = CAShapeLayer()
        bottomAreaLayer.path = bottomAreaPath.cgPath
        
        let rightAreaLayer = CAShapeLayer()
        rightAreaLayer.path = rightAreaPath.cgPath
        
        return (topAreaLayer, leftAreaLayer, bottomAreaLayer, rightAreaLayer)
        
    }
    
    private func triangleAreaPath(point1: CGPoint, point2: CGPoint, point3: CGPoint) -> UIBezierPath {
        let path = UIBezierPath()
        path.move(to: point1)
        path.addLine(to: point2)
        path.addLine(to: point3)
        path.addLine(to: point1)
        path.close()
        
        return path
    }
    
    private func rectangleAreaPath(point1: CGPoint, point2: CGPoint, point3: CGPoint, point4: CGPoint) -> UIBezierPath {
        let path = UIBezierPath()
        path.move(to: point1)
        path.addLine(to: point2)
        path.addLine(to: point3)
        path.addLine(to: point4)
        path.addLine(to: point1)
        path.close()
        
        return path
    }
    
}
