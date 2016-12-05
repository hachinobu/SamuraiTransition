//
//  ZanAngle.swift
//  SamuraiTransition
//
//  Created by Takahiro Nishinobu on 2016/11/26.
//  Copyright © 2016年 hachinobu. All rights reserved.
//

import Foundation

public enum ZanAngle {
    
    case horizontal
    case vertical
    case diagonally
    
    func zanLineLayers(containerFrame: CGRect, zanPoint: CGPoint, width: CGFloat, color: UIColor) -> [CAShapeLayer] {
        
        switch self {
        case .horizontal:
            let lineLayer = zanLineLayer(from: CGPoint(x: containerFrame.minX, y: zanPoint.y), end: CGPoint(x: containerFrame.maxX, y: zanPoint.y), width: width, color: color)
            return [lineLayer]
            
        case .vertical:
            let lineLayer = zanLineLayer(from: CGPoint(x: zanPoint.x, y: containerFrame.minY), end: CGPoint(x: zanPoint.x, y: containerFrame.maxY), width: width, color: color)
            return [lineLayer]
            
        case .diagonally:
            let bottomX = diagnoallyBottomX(containerFrame: containerFrame, zanPoint: zanPoint)
            let lineLayer = zanLineLayer(from: CGPoint(x: containerFrame.maxX, y: containerFrame.minY), end: CGPoint(x: bottomX, y: containerFrame.maxY), width: width, color: color)
            return [lineLayer]
            
        }
        
    }
    
    func angleZanViewInfoList(containerFrame: CGRect, zanPoint: CGPoint) -> [ZanViewInfo] {
        
        switch self {
        case .horizontal:
            let divided = containerFrame.divided(atDistance: zanPoint.y, from: .minYEdge)
            let slice = divided.slice
            let remainder = divided.remainder
            let oneAnimateViewInfo = ZanViewInfo(insideFrame: slice, outSideFrame: slice.offsetBy(dx: 0.0, dy: -slice.height))
            let otherAnimateViewInfo = ZanViewInfo(insideFrame: remainder, outSideFrame: remainder.offsetBy(dx: 0.0, dy: remainder.height))
            
            return [oneAnimateViewInfo, otherAnimateViewInfo]
            
        case .vertical:
            let divided = containerFrame.divided(atDistance: zanPoint.x, from: .minXEdge)
            let slice = divided.slice
            let remainder = divided.remainder
            let oneAnimateViewInfo = ZanViewInfo(insideFrame: slice, outSideFrame: slice.offsetBy(dx: -slice.width, dy: 0.0))
            let otherAnimateViewInfo = ZanViewInfo(insideFrame: remainder, outSideFrame: remainder.offsetBy(dx: remainder.width, dy: 0.0))
            
            return [oneAnimateViewInfo, otherAnimateViewInfo]
            
        case .diagonally:
            let maskLayers = maskLayer(containerFrame: containerFrame, zanPoint: zanPoint)
            let oneAnimateViewInfo = ZanViewInfo(insideFrame: containerFrame, outSideFrame: containerFrame.offsetBy(dx: containerFrame.width, dy: containerFrame.height), mask: maskLayers.oneSide)
            let otherAnimateViewInfo = ZanViewInfo(insideFrame: containerFrame, outSideFrame: containerFrame.offsetBy(dx: -containerFrame.width, dy: -containerFrame.height), mask: maskLayers.otherSide)
            
            return [oneAnimateViewInfo, otherAnimateViewInfo]
            
        }
        
    }
    
    private func zanLineLayer(from start: CGPoint, end: CGPoint, width: CGFloat, color: UIColor) -> CAShapeLayer {
        
        let zanLineLayer = CAShapeLayer()
        let path = UIBezierPath()
        path.move(to: start)
        path.addLine(to: end)
        zanLineLayer.path = path.cgPath
        zanLineLayer.fillColor = nil
        zanLineLayer.strokeColor = color.cgColor
        zanLineLayer.lineWidth = width
        return zanLineLayer
        
    }
    
    private func diagnoallyBottomX(containerFrame: CGRect, zanPoint: CGPoint) -> CGFloat {
        
        let ratio = containerFrame.maxY / zanPoint.y
        if ratio.isInfinite {
            fatalError("zanPosition.y is not 0. It will be infinite.")
        }
        let width = (containerFrame.maxX - zanPoint.x) * ratio
        let bottomX = containerFrame.maxX - width
        
        return bottomX
    }
    
    private func maskLayer(containerFrame: CGRect, zanPoint: CGPoint) -> (oneSide: CAShapeLayer, otherSide: CAShapeLayer) {
        
        let bottomX = diagnoallyBottomX(containerFrame: containerFrame, zanPoint: zanPoint)
        let oneSidePath = oneSideBezierPath(containerFrame: containerFrame, zanPoint: zanPoint, bottomX: bottomX)
        let oneSideLayer = CAShapeLayer()
        oneSideLayer.path = oneSidePath.cgPath
        let otherSidePath = otherSideBezierPath(containerFrame: containerFrame, zanPoint: zanPoint, bottomX: bottomX)
        let otherSideLayer = CAShapeLayer()
        otherSideLayer.path = otherSidePath.cgPath
        
        return (oneSideLayer, otherSideLayer)
    }
    
    private func oneSideBezierPath(containerFrame: CGRect, zanPoint: CGPoint, bottomX: CGFloat) -> UIBezierPath {
        
        let oneSidePath = UIBezierPath()
        oneSidePath.move(to: CGPoint(x: containerFrame.maxX, y: containerFrame.minY))
        oneSidePath.addLine(to: zanPoint)
        oneSidePath.addLine(to: CGPoint(x: bottomX, y: containerFrame.maxY))
        oneSidePath.addLine(to: CGPoint(x: containerFrame.maxX, y: containerFrame.maxY))
        oneSidePath.addLine(to: CGPoint(x: containerFrame.maxX, y: containerFrame.minY))
        oneSidePath.close()
        
        return oneSidePath
    }
    
    private func otherSideBezierPath(containerFrame: CGRect, zanPoint: CGPoint, bottomX: CGFloat) -> UIBezierPath {
        
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
