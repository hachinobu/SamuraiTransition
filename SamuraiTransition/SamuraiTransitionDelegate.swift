//
//  SamuraiTransitionDelegate.swift
//  SamuraiTransition
//
//  Created by Takahiro Nishinobu on 2016/11/27.
//  Copyright © 2016年 hachinobu. All rights reserved.
//

import Foundation

public protocol SamuraiTransitionDelegate: class {
    
    var zanPosition: CGPoint { get }
    var zanColor: UIColor { get }
    
}
