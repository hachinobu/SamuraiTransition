//
//  Zan.swift
//  SamuraiTransition
//
//  Created by Takahiro Nishinobu on 2016/11/26.
//  Copyright © 2016年 hachinobu. All rights reserved.
//

import Foundation

public enum Zan {
    
    case horizontal
    case vertical
    case diagonally
    case cross
    case x
    case jagged(width: CGFloat)
    case circle(radius: CGFloat)
    
    func samuraiConfig(containerFrame: CGRect, zanPoint: CGPoint, lineWidth: CGFloat, color: UIColor) -> SamuraiConfigProtocol {
        
        switch self {
        case .horizontal:
            return HorizontalZanConfig(containerFrame: containerFrame, zanPoint: zanPoint, width: lineWidth, color: color)
            
        case .vertical:
            return VerticalZanConfig(containerFrame: containerFrame, zanPoint: zanPoint, width: lineWidth, color: color)
            
        case .diagonally:
            return DiagonallyZanConfig(containerFrame: containerFrame, zanPoint: zanPoint, width: lineWidth, color: color)
            
        case .cross:
            return CrossZanConfig(containerFrame: containerFrame, zanPoint: zanPoint, width: lineWidth, color: color)
            
        case .x:
            return XZanConfig(containerFrame: containerFrame, zanPoint: zanPoint, width: lineWidth, color: color)
            
        case let .jagged(jaggedWidth) where jaggedWidth > 0.0:
            return JaggedZanConfig(containerFrame: containerFrame, zanPoint: zanPoint, width: lineWidth, color: color, jaggedWidth: jaggedWidth)
            
        case .jagged:
            return JaggedZanConfig(containerFrame: containerFrame, zanPoint: zanPoint, width: lineWidth, color: color)
            
        case let .circle(radius):
            return CircleZanConfig(containerFrame: containerFrame, zanPoint: zanPoint, width: lineWidth, color: color, radius: radius)
        
        }
        
    }
    
}
