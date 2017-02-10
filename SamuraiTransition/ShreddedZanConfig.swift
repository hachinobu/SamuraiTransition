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
    
    private let limitCount: Int = 50
    
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
        
        return (1...shreddedCount).map { count -> UIBezierPath in
            
            let position = oneSide * CGFloat(count)
            let path = UIBezierPath()
            let isEven: Bool = count % 2 == 0
            
            if isHorizontal {
                
                if isEven {
                    path.move(to: CGPoint(x: containerFrame.minX, y: position))
                    path.addLine(to: CGPoint(x: containerFrame.maxX, y: position))
                } else {
                    path.move(to: CGPoint(x: containerFrame.maxX, y: position))
                    path.addLine(to: CGPoint(x: containerFrame.minX, y: position))
                }
                
            } else {
                
                if isEven {
                    path.move(to: CGPoint(x: position, y: containerFrame.minY))
                    path.addLine(to: CGPoint(x: position, y: containerFrame.maxY))
                } else {
                    path.move(to: CGPoint(x: position, y: containerFrame.maxY))
                    path.addLine(to: CGPoint(x: position, y: containerFrame.minY))
                }
                
            }
            
            return path
        }
        
    }
    
    fileprivate func inOutSideFrames() -> [(inSideFrame: CGRect, outSideFrame: CGRect)] {
        
        return (0..<shreddedCount).map { count -> (inSideFrame: CGRect, outSideFrame: CGRect) in
            
            let point = oneSide * CGFloat(count)
            let inSideFrame: CGRect
            let outSideFrame: CGRect
            let isEven: Bool = count % 2 == 0
            
            if isHorizontal {
                inSideFrame = CGRect(x: containerFrame.minX, y: point, width: containerFrame.maxX, height: oneSide)
                let outDistance = isEven ? -(point + oneSide) : (containerFrame.maxY - point)
                outSideFrame = inSideFrame.offsetBy(dx: 0.0, dy: outDistance)
            } else {
                inSideFrame = CGRect(x: point, y: containerFrame.minY, width: oneSide, height: containerFrame.maxY)
                let outDistance = isEven ? -(point + oneSide) : (containerFrame.maxX - point)
                outSideFrame = inSideFrame.offsetBy(dx: outDistance, dy: 0.0)
            }
            
            return (inSideFrame, outSideFrame)
        }
        
    }
    
}
