//
//  ChoppedZanConfig.swift
//  SamuraiTransition
//
//  Created by Takahiro Nishinobu on 2017/02/10.
//  Copyright © 2017年 hachinobu. All rights reserved.
//

import Foundation

class ChoppedZanConfig:  ZanLineProtocol, SamuraiConfigProtocol {
    
    let containerFrame: CGRect
    let zanPoint: CGPoint
    let lineWidth: CGFloat
    let lineColor: UIColor
    let oneSide: CGFloat
    
    private let minimumOneSide: CGFloat = 3.0
    
    lazy var lineLayers: [CAShapeLayer] = {
        return self.choppedLineLayers()
    }()
    
    lazy var zanViewConfigList: [ZanViewConfigProtocol] = {
        return self.zanViewConfigs()
    }()
    
    init(containerFrame: CGRect, zanPoint: CGPoint, lineWidth: CGFloat, lineColor: UIColor, oneSide: CGFloat) {
        self.containerFrame = containerFrame
        self.zanPoint = zanPoint
        self.lineWidth = lineWidth
        self.lineColor = lineColor
        self.oneSide = oneSide > minimumOneSide ? oneSide : minimumOneSide
    }
    
}

extension ChoppedZanConfig {
    
    fileprivate func choppedLineLayers() -> [CAShapeLayer] {
        
        var lineLayers: [CAShapeLayer] = []
        var isBreakLoop: (horizontal: Bool, vertical: Bool) = (false, false)
        
        for i in (1...Int.max) {
            
            let position = oneSide * CGFloat(i)
            isBreakLoop.horizontal = position > containerFrame.maxX
            isBreakLoop.vertical = position > containerFrame.maxY
            if isBreakLoop.horizontal && isBreakLoop.vertical {
                break
            }
            
            let isEven: Bool = i % 2 == 0
            let yPositions: (start: CGFloat, end: CGFloat) = isEven ?
                (containerFrame.minY, containerFrame.maxY) : (containerFrame.maxY, containerFrame.minY)
            
            let verticalPath = UIBezierPath()
            verticalPath.move(to: CGPoint(x: position, y: yPositions.start))
            verticalPath.addLine(to: CGPoint(x: position, y: yPositions.end))
            let verticalLineLayer = zanLineLayer(from: verticalPath, width: lineWidth, color: lineColor)
            lineLayers.append(verticalLineLayer)
            
            let xPositions: (start: CGFloat, end: CGFloat) = isEven ?
                (containerFrame.minX, containerFrame.maxX) : (containerFrame.maxX, containerFrame.minX)
            
            let horizontalPath = UIBezierPath()
            horizontalPath.move(to: CGPoint(x: xPositions.start, y: position))
            horizontalPath.addLine(to: CGPoint(x: xPositions.end, y: position))
            let horizontalLineLayer = zanLineLayer(from: horizontalPath, width: lineWidth, color: lineColor)
            lineLayers.append(horizontalLineLayer)
            
        }
        
        return lineLayers
        
    }
    
    fileprivate func zanViewConfigs() -> [ZanViewConfigProtocol] {
        
        let zanSize: CGSize = CGSize(width: oneSide, height: oneSide)
        var zanConfigs: [ZanViewConfigProtocol] = []
        
        for i in (0...Int.max) {
            
            let positionY = CGFloat(i) * oneSide
            
            for j in (0...Int.max) {
                
                let positionX = CGFloat(j) * oneSide
                let frame = CGRect(origin: CGPoint(x: positionX, y: positionY), size: zanSize)
                let zan = ZanViewConfig(inSideFrame: frame, outSideFrame: frame, isScaleAnimation: true)
                zanConfigs.append(zan)
                
                if frame.maxX >= containerFrame.maxX {
                    break
                }
                
            }
            
            if (positionY + oneSide) >= containerFrame.maxY {
                break
            }
            
        }
        
        return zanConfigs
        
    }
    
}
