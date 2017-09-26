//
//  RectangleZanConfig.swift
//  SamuraiTransition
//
//  Created by Takahiro Nishinobu on 2016/12/18.
//  Copyright © 2016年 hachinobu. All rights reserved.
//

import Foundation

class RectangleZanConfig: ZanLineProtocol, SamuraiConfigProtocol {
    
    let containerFrame: CGRect
    let zanPoint: CGPoint
    let lineWidth: CGFloat
    let lineColor: UIColor
    let rectangleWidth: CGFloat
    let rectangleHeight: CGFloat
    let cornerRadius: CGFloat
    
    //conform SamuraiConfigProtocol
    lazy var lineLayers: [CAShapeLayer] = {
        let path = self.rectangleAreaPath()
        let lineLayer = self.zanLineLayer(from: path, width: self.lineWidth, color: self.lineColor)
        return [lineLayer]
    }()
    
    lazy var zanViewConfigList: [ZanViewConfigProtocol] = {
        let maskLayers = self.zanMaskLayers()
        let oneSideConfig = ZanViewConfig(inSideFrame: self.containerFrame, outSideFrame: self.containerFrame.offsetBy(dx: 0.0, dy: self.containerFrame.maxY), isAlphaAnimation: true, mask: maskLayers.oneSide)
        let otherSideConfig = ZanViewConfig(inSideFrame: self.containerFrame, outSideFrame: self.containerFrame, mask: maskLayers.otherSide)
        return [oneSideConfig, otherSideConfig]
    }()
    
    init(containerFrame: CGRect, zanPoint: CGPoint, lineWidth: CGFloat, lineColor: UIColor, rectangleWidth: CGFloat, rectangleHeight: CGFloat, cornerRadius: CGFloat) {
        self.containerFrame = containerFrame
        self.zanPoint = zanPoint
        self.lineWidth = lineWidth
        self.lineColor = lineColor
        self.rectangleWidth = rectangleWidth
        self.rectangleHeight = rectangleHeight
        self.cornerRadius = cornerRadius
    }
    
}

extension RectangleZanConfig {
    
    fileprivate func rectangleAreaPath() -> UIBezierPath {
        let x: CGFloat = zanPoint.x - rectangleWidth / 2.0
        let y: CGFloat = zanPoint.y - rectangleHeight / 2.0
        let path = UIBezierPath(roundedRect: CGRect(x: x, y: y, width: rectangleWidth, height: rectangleHeight), cornerRadius: cornerRadius)
        return path
    }
    
    fileprivate func zanMaskLayers() -> (oneSide: CAShapeLayer, otherSide: CAShapeLayer) {
        
        let oneSide = CAShapeLayer()
        let outerRectanglePath = rectangleAreaPath()
        outerRectanglePath.addLine(to: CGPoint(x: outerRectanglePath.currentPoint.x, y: containerFrame.minY))
        outerRectanglePath.addLine(to: CGPoint(x: containerFrame.minX, y: outerRectanglePath.currentPoint.y))
        outerRectanglePath.addLine(to: CGPoint(x: outerRectanglePath.currentPoint.x, y: containerFrame.maxY))
        outerRectanglePath.addLine(to: CGPoint(x: containerFrame.maxX, y: outerRectanglePath.currentPoint.y))
        outerRectanglePath.addLine(to: CGPoint(x: outerRectanglePath.currentPoint.x, y: containerFrame.minY))
        outerRectanglePath.addLine(to: CGPoint(x: containerFrame.minX, y: outerRectanglePath.currentPoint.y))
        oneSide.path = outerRectanglePath.cgPath
        
        let otherSide = CAShapeLayer()
        let innerRectanglePath = rectangleAreaPath()
        otherSide.path = innerRectanglePath.cgPath
        
        return (oneSide, otherSide)
    }
    
}
