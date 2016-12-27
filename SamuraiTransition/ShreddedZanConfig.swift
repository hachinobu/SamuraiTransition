//
//  ShreddedZanConfig.swift
//  SamuraiTransition
//
//  Created by Nishinobu.Takahiro on 2016/12/26.
//  Copyright © 2016年 hachinobu. All rights reserved.
//

import Foundation

class ShreddedZanConfig: ZanLineProtocol, SamuraiConfigProtocol {
    
    let containerFrame: CGRect
    let zanPoint: CGPoint
    let lineWidth: CGFloat
    let lineColor: UIColor
    let isHorizontal: Bool
    let shreddedCount: Int
    
    let limitCount: Int = 50
    
    lazy var oneSide: CGFloat = {
        if self.isHorizontal {
            return self.containerFrame.maxY / CGFloat(self.shreddedCount)
        }
        return self.containerFrame.maxX / CGFloat(self.shreddedCount)
    }()
    
    //conform SamuraiConfigProtocol
    lazy var lineLayers: [CAShapeLayer] = {
        let paths = self.shreddedLinePaths()
        return paths.map { self.zanLineLayer(from: $0, width: self.lineWidth, color: self.lineColor) }
    }()
    
    lazy var zanViewConfigList: [ZanViewConfigProtocol] = {
        let infos = self.inOutSideFrames()
        return infos.map { ZanViewConfig(inSideFrame: $0.inSideFrame, outSideFrame: $0.outSideFrame) }
    }()
    
    init(containerFrame: CGRect, zanPoint: CGPoint, lineWidth: CGFloat, lineColor: UIColor, isHorizontal: Bool, shreddedCount: Int) {
        self.containerFrame = containerFrame
        self.zanPoint = zanPoint
        self.lineWidth = lineWidth
        self.lineColor = lineColor
        self.isHorizontal = isHorizontal
        self.shreddedCount = shreddedCount > limitCount ? limitCount : shreddedCount
    }
    
}

extension ShreddedZanConfig {
    
    fileprivate func shreddedLinePaths() -> [UIBezierPath] {
        
        var paths: [UIBezierPath] = []
        for i in 1...shreddedCount {
            
            let position = oneSide * CGFloat(i)
            let path = UIBezierPath()
            if isHorizontal {
                
                if i % 2 == 0 {
                    path.move(to: CGPoint(x: containerFrame.minX, y: position))
                    path.addLine(to: CGPoint(x: containerFrame.maxX, y: position))
                } else {
                    path.move(to: CGPoint(x: containerFrame.maxX, y: position))
                    path.addLine(to: CGPoint(x: containerFrame.minX, y: position))
                }
                
            } else {
                
                if i % 2 == 0 {
                    path.move(to: CGPoint(x: position, y: containerFrame.minY))
                    path.addLine(to: CGPoint(x: position, y: containerFrame.maxY))
                } else {
                    path.move(to: CGPoint(x: position, y: containerFrame.maxY))
                    path.addLine(to: CGPoint(x: position, y: containerFrame.minY))
                }
                
            }
            
            paths.append(path)
            
        }
        
        return paths
        
    }
    
    fileprivate func inOutSideFrames() -> [(inSideFrame: CGRect, outSideFrame: CGRect)] {
        
        var sideFrames: [(inSideFrame: CGRect, outSideFrame: CGRect)] = []
        for i in 0..<shreddedCount {
            
            let point = oneSide * CGFloat(i)
            let inSideFrame: CGRect
            let outSideFrame: CGRect
            
            if isHorizontal {
                inSideFrame = CGRect(x: containerFrame.minX, y: point, width: containerFrame.maxX, height: oneSide)
                let outDistance = (i % 2 == 0) ? -(point + oneSide) : (containerFrame.maxY - point)
                outSideFrame = inSideFrame.offsetBy(dx: 0.0, dy: outDistance)
            } else {
                inSideFrame = CGRect(x: point, y: containerFrame.minY, width: oneSide, height: containerFrame.maxY)
                let outDistance = (i % 2 == 0) ? -(point + oneSide) : (containerFrame.maxX - point)
                outSideFrame = inSideFrame.offsetBy(dx: outDistance, dy: 0.0)
            }
            
            sideFrames.append((inSideFrame: inSideFrame, outSideFrame: outSideFrame))
            
        }
        
        return sideFrames
    }
    
}
