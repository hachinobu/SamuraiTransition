//
//  ZanLineProtocol.swift
//  SamuraiTransition
//
//  Created by Nishinobu.Takahiro on 2016/12/07.
//  Copyright © 2016年 hachinobu. All rights reserved.
//

import Foundation

public protocol ZanLineProtocol {
    
    func zanLineLayer(from start: CGPoint, end: CGPoint, width: CGFloat, color: UIColor) -> CAShapeLayer
    func calculateTopRightToBottomLeftX(containerFrame: CGRect, zanPoint: CGPoint) -> CGFloat
    func calculateTopLeftToBottomRightX(containerFrame: CGRect, zanPoint: CGPoint) -> CGFloat
    
}

public extension ZanLineProtocol {
    
    func zanLineLayer(from start: CGPoint, end: CGPoint, width: CGFloat, color: UIColor) -> CAShapeLayer {
        
        let path = UIBezierPath()
        path.move(to: start)
        path.addLine(to: end)
        let lineLayer = zanLineLayer(from: path, width: width, color: color)
        return lineLayer
        
    }
    
    func zanLineLayer(from path: UIBezierPath, width: CGFloat, color: UIColor) -> CAShapeLayer {
        
        let zanLineLayer = CAShapeLayer()
        zanLineLayer.path = path.cgPath
        zanLineLayer.fillColor = nil
        zanLineLayer.strokeColor = color.cgColor
        zanLineLayer.lineWidth = width
        return zanLineLayer
        
    }
    
    func calculateTopRightToBottomLeftX(containerFrame: CGRect, zanPoint: CGPoint) -> CGFloat {
        
        let ratio = calculateRatioY(containerFrame: containerFrame, zanPoint: zanPoint)
        let width = (containerFrame.maxX - zanPoint.x) * ratio
        let bottomX = containerFrame.maxX - width
        
        return bottomX
    }
    
    func calculateTopLeftToBottomRightX(containerFrame: CGRect, zanPoint: CGPoint) -> CGFloat {
        
        let ratio = calculateRatioY(containerFrame: containerFrame, zanPoint: zanPoint)
        let bottomX = zanPoint.x * ratio
        
        return bottomX
    }
    
    private func calculateRatioY(containerFrame: CGRect, zanPoint: CGPoint) -> CGFloat {
        let ratio = containerFrame.maxY / zanPoint.y
        if ratio.isInfinite {
            fatalError("zanPosition.y is not 0. It will be infinite.")
        }
        return ratio
    }
    
}
