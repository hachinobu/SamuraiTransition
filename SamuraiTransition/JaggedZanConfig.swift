//
//  JaggedZanConfig.swift
//  SamuraiTransition
//
//  Created by Nishinobu.Takahiro on 2016/12/16.
//  Copyright © 2016年 hachinobu. All rights reserved.
//

import Foundation

class JaggedZanConfig: ZanLineProtocol, SamuraiConfigProtocol {
    
    let containerFrame: CGRect
    let zanPoint: CGPoint
    let lineWidth: CGFloat
    let lineColor: UIColor
    let jaggedWidth: CGFloat
    
    fileprivate lazy var jaggedRatio: CGFloat = {
        let zanWidth = self.containerFrame.maxX - self.zanPoint.x
        let ratio = self.zanPoint.y / zanWidth
        if ratio.isInfinite {
            fatalError("It will be infinite.")
        }
        return ratio
    }()
    
    fileprivate lazy var jaggedHeight: CGFloat = {
        return self.jaggedWidth * self.jaggedRatio
    }()
    
    fileprivate lazy var jaggedStartPoint: CGPoint = {
        return CGPoint(x: self.containerFrame.maxX - self.lineWidth, y: self.containerFrame.minY)
    }()
    
    fileprivate var leftAreaOffsetSize: CGSize
    fileprivate var rightAreaOffsetSize: CGSize
    
    //conform SamuraiConfigProtocol
    lazy var lineLayers: [CAShapeLayer] = {
        let path = self.jaggedPath()
        let lineLayer = self.zanLineLayer(from: path, width: self.lineWidth, color: self.lineColor)
        
        return [lineLayer]
    }()
    
    lazy var zanViewConfigList: [ZanViewConfigProtocol] = {
        
        let left = self.containerFrame
        let right = self.containerFrame
        let maskLayer = self.zanMaskLayers()
        
        let oneSideConfig = ZanViewConfig(inSideFrame: left, outSideFrame: left.offsetBy(dx: -self.leftAreaOffsetSize.width, dy: -self.leftAreaOffsetSize.height), mask: maskLayer.leftAreaMask)
        let otherSideConfig = ZanViewConfig(inSideFrame: right, outSideFrame: right.offsetBy(dx: self.rightAreaOffsetSize.width, dy: self.rightAreaOffsetSize.height), mask: maskLayer.rightAreaMask)
        
        return [oneSideConfig, otherSideConfig]
    }()
    
    init(containerFrame: CGRect, zanPoint: CGPoint, lineWidth: CGFloat, lineColor: UIColor, jaggedWidth: CGFloat) {
        self.containerFrame = containerFrame
        self.zanPoint = zanPoint
        self.lineWidth = lineWidth
        self.lineColor = lineColor
        self.jaggedWidth = jaggedWidth > 0.0 ? jaggedWidth : 4.0
        self.leftAreaOffsetSize = self.containerFrame.size
        self.rightAreaOffsetSize = self.containerFrame.size
    }
    
}

extension JaggedZanConfig {
    
    fileprivate func zanMaskLayers() -> (leftAreaMask: CAShapeLayer, rightAreaMask: CAShapeLayer) {
        
        let leftAreaMaskLayer = CAShapeLayer()
        let leftAreaPath = serratedLeftAreaPath()
        leftAreaMaskLayer.path = leftAreaPath.cgPath
        
        let rightAreaMaskLayer = CAShapeLayer()
        let rightAreaPath = serratedRightAreaPath()
        rightAreaMaskLayer.path = rightAreaPath.cgPath
        
        return (leftAreaMaskLayer, rightAreaMaskLayer)
        
    }
    
    fileprivate func jaggedPath() -> UIBezierPath {
        
        let stepWidth = jaggedWidth * 2
        let path = UIBezierPath()
        path.move(to: jaggedStartPoint)
        while true {
            path.addLine(to: CGPoint(x: path.currentPoint.x + jaggedWidth, y: path.currentPoint.y + jaggedHeight))
            path.addLine(to: CGPoint(x: path.currentPoint.x - stepWidth, y: path.currentPoint.y))
            if path.currentPoint.y > containerFrame.maxY || path.currentPoint.x < 0.0 {
                break
            }
        }
        
        return path
        
    }
    
    private func serratedLeftAreaPath() -> UIBezierPath {
        
        let path = jaggedPath()
        leftAreaOffsetSize = CGSize(width: jaggedStartPoint.x, height: path.currentPoint.y)
        path.addLine(to: CGPoint(x: containerFrame.minX, y: containerFrame.maxY))
        path.addLine(to: CGPoint(x: containerFrame.minX, y: containerFrame.minY))
        path.addLine(to: jaggedStartPoint)
        
        return path
        
    }
    
    private func serratedRightAreaPath() -> UIBezierPath {
        
        let path = jaggedPath()
        let rightAreaWidth = path.currentPoint.x <= 0.0 ? containerFrame.maxX : containerFrame.maxX - path.currentPoint.x
        rightAreaOffsetSize = CGSize(width: rightAreaWidth, height: containerFrame.maxY)
        path.addLine(to: CGPoint(x: path.currentPoint.x, y: containerFrame.maxY))
        path.addLine(to: CGPoint(x: containerFrame.maxX, y: containerFrame.maxY))
        path.addLine(to: CGPoint(x: containerFrame.maxX, y: containerFrame.minY))
        path.addLine(to: jaggedStartPoint)
        
        return path
        
    }
    
}
