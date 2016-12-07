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
    
    func samuraiConfig(containerFrame: CGRect, zanPoint: CGPoint, width: CGFloat, color: UIColor) -> SamuraiConfigProtocol {
        
        switch self {
        case .horizontal:
            return HorizontalZanConfig(containerFrame: containerFrame, zanPoint: zanPoint, width: width, color: color)
            
        case .vertical:
            return VerticalZanConfig(containerFrame: containerFrame, zanPoint: zanPoint, width: width, color: color)
            
        case .diagonally:
            return DiagonallyZanConfig(containerFrame: containerFrame, zanPoint: zanPoint, width: width, color: color)
        }
        
    }
    
}
